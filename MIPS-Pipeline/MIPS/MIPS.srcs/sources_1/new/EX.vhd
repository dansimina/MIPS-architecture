----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2024 10:42:53 AM
-- Design Name: 
-- Module Name: EX - Behavioral
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
use IEEE.std_logic_arith.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EX is
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
end EX;

architecture Behavioral of EX is
SIGNAL MUX : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
SIGNAL OP: STD_LOGIC_VECTOR(5 downto 0) := (others => '0');
begin
    Addr_RegWrite <= Addr_Target when RegDst = '0' else Addr_Dest;
    MUX <= RD2 when ALUSrc = '0' else Ext_Imm;
    OP <= func when ALUOp = 0 else ALUOp;
    process(RD1, MUX, OP)
    variable result: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    begin
        case OP is
            --add
            when "100000" => result := RD1 + MUX;
            --sub
            when "100010" => result := RD1 - MUX;
            --sll
            when "000000" => result :=  to_stdlogicvector(to_bitvector(MUX) sll conv_integer(sa)); 
            --srl
            when "000010" => result :=  to_stdlogicvector(to_bitvector(MUX) srl conv_integer(sa)); 
            --and
            when "100100" => result := RD1 and MUX;
            --or
            when "100101" => result := RD1 or MUX;
            --xor
            when "100110" => result := RD1 xor MUX;
            --sra
            when "000011" => result :=  to_stdlogicvector(to_bitvector(MUX) sra conv_integer(sa)); 
               
            when others => result := x"00000000";
        end case;
        
        if result = 0 then
            Zero <= '1';
        else 
            Zero <= '0';
        end if;
        
        if signed(RD1) > 0 then
            GreaterThanZero <= '1';
        else 
            GreaterThanZero <= '0';
        end if;
        
        if signed(RD1) >= 0 then
            GreaterOrEqualToZero <= '1';
        else 
            GreaterOrEqualToZero <= '0';
        end if;
        
        ALURes <= result;
    end process;
    
    Branch_Address <= Ext_Imm + PC_4;

end Behavioral;
