----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2024 10:34:18 AM
-- Design Name: 
-- Module Name: test_env - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0)
--           outt : out STD_LOGIC_VECTOR (31 downto 0)
           );
end test_env;

architecture Behavioral of test_env is

component MPG is
    Port ( enable : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
end component;

component SSD is
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR (31 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component IFetch is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           Jump : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           Jump_Address : in STD_LOGIC_VECTOR(31 downto 0);
           Branch_Address : in STD_LOGIC_VECTOR(31 downto 0);
           PC_4 : out STD_LOGIC_VECTOR(31 downto 0);
           Instruction : out STD_LOGIC_VECTOR(31 downto 0)
           );
end component;

component ID is
    Port ( clk : in STD_LOGIC;
           RegWrite : in STD_LOGIC;
           Instr : in STD_LOGIC_VECTOR (25 downto 0);
--           RegDst : in STD_LOGIC;
           WD : in STD_LOGIC_VECTOR (31 downto 0);
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (31 downto 0);
           RD2 : out STD_LOGIC_VECTOR (31 downto 0);
           Ext_Imm : out STD_LOGIC_VECTOR (31 downto 0);
           func : out STD_LOGIC_VECTOR (5 downto 0);
           sa : out STD_LOGIC_VECTOR (4 downto 0);
           WriteAddress : in STD_LOGIC_VECTOR (4 downto 0);
           Addr_Target : out STD_LOGIC_VECTOR (4 downto 0);
           Addr_Dest : out STD_LOGIC_VECTOR (4 downto 0));
end component;


component UC is
    Port ( Instr : in STD_LOGIC_VECTOR (5 downto 0);
           RegDst : out STD_LOGIC;
           ExtOp : out STD_LOGIC;
           ALUSrc : out STD_LOGIC;
           BranchOnEqual : out STD_LOGIC;
           BranchOnGreaterThanZero : out STD_LOGIC;
           BranchOnGreaterThanOrEqualToZero : out STD_LOGIC;
           Jump : out STD_LOGIC;
           ALUOp : out STD_LOGIC_VECTOR (5 downto 0);
           MemWrite : out STD_LOGIC;
           MemtoReg : out STD_LOGIC;
           RegWrite : out STD_LOGIC);
end component;

component EX is
     Port ( RD1 : in STD_LOGIC_VECTOR (31 downto 0);
           ALUSrc : in STD_LOGIC;
           RD2 : in STD_LOGIC_VECTOR (31 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR (31 downto 0);
           sa : in STD_LOGIC_VECTOR (4 downto 0);
           func : in STD_LOGIC_VECTOR (5 downto 0);
           ALUOp : in STD_LOGIC_VECTOR(5 downto 0);
           PC_4 : in STD_LOGIC_VECTOR (31 downto 0);
           Zero : out STD_LOGIC;
           GreaterThanZero : out STD_LOGIC;
           GreaterOrEqualToZero : out STD_LOGIC;
           ALURes : out STD_LOGIC_VECTOR (31 downto 0);
           Branch_Address : out STD_LOGIC_VECTOR (31 downto 0);
           RegDst : in STD_LOGIC;
           Addr_Target : in STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
           Addr_Dest : in STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
           Addr_RegWrite : out STD_LOGIC_VECTOR (4 downto 0) := (others => '0')
           );
end component;

component MEM is
    Port ( clk : in STD_LOGIC;
           MemWrite : in STD_LOGIC;
           ALUResIn : in STD_LOGIC_VECTOR (31 downto 0);
           RD2 : in STD_LOGIC_VECTOR (31 downto 0);
           MemData : out STD_LOGIC_VECTOR (31 downto 0);
           ALUResOut : out STD_LOGIC_VECTOR (31 downto 0);
           view: in STD_LOGIC_VECTOR (5 downto 0);
           test_en: in STD_LOGIC);
end component;

signal enable: std_logic := '0';
signal digits: std_logic_vector (31 downto 0) := (others => '0');

-- IFetch
signal reset_IF : STD_LOGIC :='0';
signal Jump_IF : STD_LOGIC :='0';
signal PCSrc_IF : STD_LOGIC :='0';
signal Jump_Address_IF : STD_LOGIC_VECTOR(31 downto 0) := x"00000000";
signal Branch_Address_IF : STD_LOGIC_VECTOR(31 downto 0) := x"00000000";
signal PC_4_IF : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal Instruction_IF : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

--ID
signal RegWrite_ID : STD_LOGIC :='0';
signal Instruction_ID : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal WD_ID : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal ExtOp_ID : STD_LOGIC :='0';
signal RD1_ID : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal RD2_ID : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal Ext_Imm_ID : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal func_ID : STD_LOGIC_VECTOR (5 downto 0) := (others => '0');
signal sa_ID : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
signal WriteAddress_ID : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
signal Addr_Target_ID : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
signal Addr_Dest_ID : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');

--UC
signal Instruction_UC : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal RegDst_UC : STD_LOGIC := '0';
signal ExtOp_UC : STD_LOGIC := '0';
signal ALUSrc_UC : STD_LOGIC := '0';
signal BranchOnEqual_UC : STD_LOGIC := '0';
signal BranchOnGreaterThanZero_UC : STD_LOGIC := '0';
signal BranchOnGreaterThanOrEqualToZero_UC : STD_LOGIC := '0';
signal Jump_UC : STD_LOGIC := '0';
signal ALUOp_UC : STD_LOGIC_VECTOR (5 downto 0) := "000000";
signal MemWrite_UC : STD_LOGIC := '0';
signal MemtoReg_UC : STD_LOGIC := '0';
signal RegWrite_UC : STD_LOGIC := '0';

--EX
signal RD1_EX : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal ALUSrc_EX : STD_LOGIC := '0';
signal RD2_EX : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal Ext_Imm_EX : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal sa_EX : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
signal func_EX : STD_LOGIC_VECTOR (5 downto 0) := (others => '0');
signal ALUOp_EX : STD_LOGIC_VECTOR (5 downto 0) := (others => '0');
signal PC_4_EX : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal Zero_EX : STD_LOGIC := '0';
signal GreaterThanZero_EX : STD_LOGIC := '0';
signal GreaterOrEqualToZero_EX : STD_LOGIC := '0';
signal ALURes_EX : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal Branch_Address_EX : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

signal RegDst_EX : STD_LOGIC := '0';
signal Addr_Target_EX : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
signal Addr_Dest_EX : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
signal Addr_RegWrite_EX : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');

--MEM
signal MemWrite_MEM : STD_LOGIC := '0';
signal ALUResIn_MEM : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal RD2_MEM : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal MemData_MEM : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal ALUResOut_MEM : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

--REGISTRE
signal IF_ID : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');
signal ID_EX : STD_LOGIC_VECTOR (163 downto 0) := (others => '0');
signal EX_MEM : STD_LOGIC_VECTOR (110 downto 0) := (others => '0');
signal MEM_WB : STD_LOGIC_VECTOR (71 downto 0) := (others => '0');

--MUX-ul dintre ID_EX si EX_MEM
--signal MUX_EX : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');

--WB
signal WD : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

begin
    -- test
--    enable <= btn(0);
    
    -- MPG
    connectMPG: MPG port map(enable, btn(0), clk);

    -- IFetch Instruction Fetch
    reset_IF <= btn(1);
    connectIFetch: IFetch port map(enable, reset_IF, Jump_IF, PCSrc_IF, Jump_Address_IF, Branch_Address_IF, PC_4_IF, Instruction_IF);
         
    -- ID Instruction Decode
    connectID: ID port map(enable, RegWrite_ID, Instruction_ID(25 downto 0), WD_ID, ExtOp_ID, RD1_ID, RD2_ID, Ext_Imm_ID, func_ID, sa_ID, WriteAddress_ID, Addr_Target_ID, Addr_Dest_ID);
    
    -- UC Unitatea de Control
    connectUC: UC port map(Instruction_UC(31 downto 26), RegDst_UC, ExtOp_UC, ALUSrc_UC, BranchOnEqual_UC, BranchOnGreaterThanZero_UC, BranchOnGreaterThanOrEqualToZero_UC, Jump_UC, ALUOp_UC, MemWrite_UC, MemtoReg_UC, RegWrite_UC);   
    led(0) <= RegDst_UC;
    led(1) <= ExtOp_UC;
    led(2) <= ALUSrc_UC;
    led(3) <= BranchOnEqual_UC;
    led(4) <= BranchOnGreaterThanZero_UC;
    led(5) <= BranchOnGreaterThanOrEqualToZero_UC;
    led(6) <= Jump_UC;
    led(12 downto 7) <= ALUOp_UC;
    led(13) <= MemWrite_UC;
    led(14) <= MemtoReg_UC;
    led(15) <= RegWrite_UC;
        
    -- EX Instruction Execute
    connectEX: EX port map(RD1_EX, ALUSrc_EX, RD2_EX, Ext_Imm_EX, sa_EX, func_EX, ALUOp_EX, PC_4_EX, Zero_EX, GreaterThanZero_EX, GreaterOrEqualToZero_EX, ALURes_EX, Branch_Address_EX, RegDst_EX, Addr_Target_EX, Addr_Dest_EX, Addr_RegWrite_EX);
        
    --MEM Unitatea de Memorie
    connectMEM: MEM port map(enable, MemWrite_MEM, ALUResIn_MEM, RD2_MEM, MemData_MEM, ALUResOut_MEM, sw(15 downto 10), sw(0));
    
    --WB Write-Back
    WD <= MEM_WB(65 downto 34) when MEM_WB(0) = '0' else MEM_WB(33 downto 2);   
      
    --REGISTRE
    
    --Conectare iesiri
    process(enable)
    begin
        if rising_edge(enable) then 
        --IF_ID
            IF_ID(31 downto 0) <= PC_4_IF;
            IF_ID(63 downto 32) <= Instruction_IF;
            
        --ID_EX
            ID_EX(0) <= MemtoReg_UC;
            ID_EX(1) <= RegWrite_UC;
            ID_EX(2) <= MemWrite_UC;
            ID_EX(3) <= BranchOnEqual_UC;
            ID_EX(4) <= BranchOnGreaterThanZero_UC;
            ID_EX(5) <= BranchOnGreaterThanOrEqualToZero_UC;
            ID_EX(11 downto 6) <= ALUOp_UC;
            ID_EX(12) <= ALUSrc_UC;
            ID_EX(13) <= RegDst_UC;
            ID_EX(45 downto 14) <= IF_ID(31 downto 0);
            ID_EX(77 downto 46) <= RD1_ID;
            ID_EX(109 downto 78) <= RD2_ID;
            ID_EX(114 downto 110) <= sa_ID;
            ID_EX(146 downto 115) <= Ext_Imm_ID;
            ID_EX(152 downto 147) <= func_ID;
            ID_EX(157 downto 153) <= Addr_Target_ID;
            ID_EX(162 downto 158) <= Addr_Dest_ID;
            
        --EX_MEM
            EX_MEM(5 downto 0) <= ID_EX(5 downto 0);
            EX_MEM(37 downto 6) <= Branch_Address_EX;
            EX_MEM(38) <= Zero_EX;
            EX_MEM(39) <= GreaterThanZero_EX;
            EX_MEM(40) <= GreaterOrEqualToZero_EX;
            EX_MEM(72 downto 41) <= ALURes_EX;
            EX_MEM(104 downto 73) <= ID_EX(109 downto 78);
            EX_MEM(109 downto 105) <= Addr_RegWrite_EX;
        
        --MEM_WB
            MEM_WB(1 downto 0) <= EX_MEM(1 downto 0);
            MEM_WB(33 downto 2) <= MemData_MEM;
            MEM_WB(65 downto 34) <= ALUResOut_MEM;
            MEM_WB(70 downto 66) <= EX_MEM(109 downto 105);
        end if;
    end process;
    
    --Conectare Intrari
    --IF
        --Calculul adresei de salt necondi?ionat Jump Address de la IFetch: 
        Jump_Address_IF <= IF_ID(31 downto 26) & IF_ID(57 downto 32);
    
        Branch_Address_IF <= EX_MEM(37 downto 6);
        Jump_IF <= Jump_UC;
    
        --Validarea saltului condi?ionat prin activarea PCSrc
        PCSrc_IF <= (EX_MEM(3) and EX_MEM(38)) or (EX_MEM(4) and EX_MEM(39)) or (EX_MEM(5) and EX_MEM(40));
    
    --UC
        Instruction_UC <= IF_ID(63 downto 32);
    
    --ID
        Instruction_ID <= IF_ID(63 downto 32);
        RegWrite_ID <= MEM_WB(1);
        ExtOp_ID <= ExtOp_UC;
        WriteAddress_ID <= MEM_WB(70 downto 66);
        WD_ID <= WD;
        
    --EX
        --MUX_EX <= ID_EX(157 downto 153) when ID_EX(13) = '0' else ID_EX(162 downto 158);
        RD1_EX <= ID_EX(77 downto 46);
        ALUSrc_EX <= ID_EX(12);
        RD2_EX <= ID_EX(109 downto 78);
        Ext_Imm_EX <= ID_EX(146 downto 115);
        sa_EX <= ID_EX(114 downto 110);
        func_EX <= ID_EX(152 downto 147);
        ALUOp_EX <= ID_EX(11 downto 6);
        PC_4_EX <= ID_EX(45 downto 14);
        
        RegDst_EX <= ID_EX(13);
        Addr_Target_EX <= ID_EX(157 downto 153);
        Addr_Dest_EX <= ID_EX(162 downto 158);
                
    --MEM
        MemWrite_MEM <= EX_MEM(2);
        ALUResIn_MEM <= EX_MEM(72 downto 41);
        RD2_MEM <= EX_MEM(104 downto 73);
        
    --Afisare
    process(sw(7 downto 5), clk)
    begin
        case sw(7 downto 5) is 
            when "000" => digits <= IF_ID(63 downto 32); -- instruction
            when "001" => digits <= PC_4_IF; --IF_ID(31 downto 0); --pc + 4
            when "010" => digits <= ID_EX(77 downto 46); -- RD1
            when "011" => digits <= ID_EX(109 downto 78); --RD2
            when "100" => digits <= ID_EX(146 downto 115); --Ext_Imm
            when "101" => digits <= ALURes_EX; --EX_MEM(72 downto 41); --ALURes
            when "110" => digits <= MemData_MEM; --MEM_WB(33 downto 2); --MemData
            when "111" => digits <= WD_ID;
            when others => digits <= x"ffffffff";
        end case;
    end process;
--    outt <= digits;
    connectSSD: SSD port map(clk, digits, an, cat);
    
end Behavioral;
