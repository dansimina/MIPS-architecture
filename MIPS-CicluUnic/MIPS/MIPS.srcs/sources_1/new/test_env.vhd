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
           RegDst : in STD_LOGIC;
           WD : in STD_LOGIC_VECTOR (31 downto 0);
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (31 downto 0);
           RD2 : out STD_LOGIC_VECTOR (31 downto 0);
           Ext_Imm : out STD_LOGIC_VECTOR (31 downto 0);
           func : out STD_LOGIC_VECTOR (5 downto 0);
           sa : out STD_LOGIC_VECTOR (4 downto 0));
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
           Branch_Address : out STD_LOGIC_VECTOR (31 downto 0));
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
signal pc: std_logic_vector (31 downto 0) := (others => '0');
signal reset : STD_LOGIC :='0';
signal Jump : STD_LOGIC :='0';
signal PCSrc : STD_LOGIC :='0';
signal Jump_Address : STD_LOGIC_VECTOR(31 downto 0) := x"0000000F";
signal Branch_Address : STD_LOGIC_VECTOR(31 downto 0) := x"00000014";
signal PC_4 : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal Instruction : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

--ID
signal RegWrite : STD_LOGIC :='0';
signal RegDst : STD_LOGIC :='0';
signal WD : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
signal ExtOp : STD_LOGIC :='0';
signal RD1 : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
signal RD2 : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
signal Ext_Imm : STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
signal func : STD_LOGIC_VECTOR (5 downto 0):= (others => '0');
signal sa : STD_LOGIC_VECTOR (4 downto 0):= (others => '0');

--UC
signal ALUSrc : STD_LOGIC := '0';
signal BranchOnEqual : STD_LOGIC := '0';
signal BranchOnGreaterThanZero : STD_LOGIC := '0';
signal BranchOnGreaterThanOrEqualToZero : STD_LOGIC := '0';
signal ALUOp : STD_LOGIC_VECTOR (5 downto 0) := "000000";
signal MemWrite : STD_LOGIC := '0';
signal MemtoReg : STD_LOGIC := '0';

--EX
signal Zero : STD_LOGIC := '0';
signal GreaterThanZero : STD_LOGIC := '0';
signal GreaterOrEqualToZero : STD_LOGIC := '0';
signal ALURes : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

--MEM
signal MemData : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal ALUResOut : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

begin
    -- test
--    enable <= btn(0);
    
    -- MPG
    connectMPG: MPG port map(enable, btn(0), clk);

    -- IFetch Instruction Fetch
    reset <= btn(1);
    connectIFetch: IFetch port map(enable, reset, Jump, PCSrc, Jump_Address, Branch_Address, PC_4, Instruction);
    
    -- ID Instruction Decode
    connectID: ID port map(enable, RegWrite, Instruction(25 downto 0), RegDst, WD, ExtOp, RD1, RD2, Ext_Imm, func, sa);
    
    -- UC Unitatea de Control
    connectUC: UC port map(Instruction(31 downto 26), RegDst, ExtOp, ALUSrc, BranchOnEqual, BranchOnGreaterThanZero, BranchOnGreaterThanOrEqualToZero, Jump, ALUOp, MemWrite, MemtoReg, RegWrite);   
    led(0) <= RegDst;
    led(1) <= ExtOp;
    led(2) <= ALUSrc;
    led(3) <= BranchOnEqual;
    led(4) <= BranchOnGreaterThanZero;
    led(5) <= BranchOnGreaterThanOrEqualToZero;
    led(6) <= Jump;
    led(12 downto 7) <= ALUOp;
    led(13) <= MemWrite;
    led(14) <= MemtoReg;
    led(15) <= RegWrite;
    
    -- EX Instruction Execute
    connectEX: EX port map(RD1, ALUSrc, RD2, Ext_Imm, sa, func, ALUOp, PC_4, Zero, GreaterThanZero, GreaterOrEqualToZero, ALURes, Branch_Address);
    
    --MEM Unitatea de Memorie
    connectMEM: MEM port map(enable, MemWrite, ALURes, RD2, MemData, ALUResOut, sw(15 downto 10), sw(0));
    
    --WB Write-Back
    WD <= ALUResOut when MemtoReg = '0' else MemData;   
    
    --Calculul adresei de salt necondi?ionat Jump Address de la IFetch: 
    Jump_Address <= PC_4(31 downto 26) & Instruction(25 downto 0);
    
    --Validarea saltului condi?ionat prin activarea PCSrc
    PCSrc <= (BranchOnEqual and Zero) or (BranchOnGreaterThanZero and GreaterThanZero) or (BranchOnGreaterThanOrEqualToZero and GreaterOrEqualToZero);
        
    process(sw(7 downto 5), clk)
    begin
        case sw(7 downto 5) is 
            when "000" => digits <= Instruction;
            when "001" => digits <= PC_4;
            when "010" => digits <= RD1;
            when "011" => digits <= RD2;
            when "100" => digits <= Ext_Imm;
            when "101" => digits <= ALURes;
            when "110" => digits <= MemData;
            when "111" => digits <= WD;
            when others => digits <= x"ffffffff";
        end case;
    end process;
--    outt <= digits;
    connectSSD: SSD port map(clk, digits, an, cat);
    
end Behavioral;
