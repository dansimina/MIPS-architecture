----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2024 09:24:47 PM
-- Design Name: 
-- Module Name: UC - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UC is
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
end UC;

architecture Behavioral of UC is

begin

process(Instr)
begin
    case Instr is
        --tip R
        when "000000" => RegDst <= '1';
                         ExtOp <= '0';
                         ALUSrc <= '0';
                         BranchOnEqual <= '0';
                         BranchOnGreaterThanZero <= '0';
                         BranchOnGreaterThanOrEqualToZero <= '0';
                         Jump <= '0';
                         ALUOp <= "000000";
                         MemWrite <= '0';
                         MemtoReg <= '0';
                         RegWrite <= '1';
        --addi
        when "001000" => RegDst <= '0';
                         ExtOp <= '1';
                         ALUSrc <= '1';
                         BranchOnEqual <= '0';
                         BranchOnGreaterThanZero <= '0';
                         BranchOnGreaterThanOrEqualToZero <= '0';
                         Jump <= '0';
                         ALUOp <= "100000";
                         MemWrite <= '0';
                         MemtoReg <= '0';
                         RegWrite <= '1';
        --lw
        when "100011" => RegDst <= '0';
                         ExtOp <= '1';
                         ALUSrc <= '1';
                         BranchOnEqual <= '0';
                         BranchOnGreaterThanZero <= '0';
                         BranchOnGreaterThanOrEqualToZero <= '0';
                         Jump <= '0';
                         ALUOp <= "100000";
                         MemWrite <= '0';
                         MemtoReg <= '1';
                         RegWrite <= '1';
        --sw
        when "101011" => RegDst <= '0';
                         ExtOp <= '1';
                         ALUSrc <= '1';
                         BranchOnEqual <= '0';
                         BranchOnGreaterThanZero <= '0';
                         BranchOnGreaterThanOrEqualToZero <= '0';
                         Jump <= '0';
                         ALUOp <= "100000";
                         MemWrite <= '1';
                         MemtoReg <= '0';
                         RegWrite <= '0';
        --beq
        when "000100" => RegDst <= '0';
                         ExtOp <= '1';
                         ALUSrc <= '0';
                         BranchOnEqual <= '1';
                         BranchOnGreaterThanZero <= '0';
                         BranchOnGreaterThanOrEqualToZero <= '0';
                         Jump <= '0';
                         ALUOp <= "100010";
                         MemWrite <= '0';
                         MemtoReg <= '0';
                         RegWrite <= '0';
        --bgtz
        when "000111" => RegDst <= '0';
                         ExtOp <= '1';
                         ALUSrc <= '0';
                         BranchOnEqual <= '0';
                         BranchOnGreaterThanZero <= '1';
                         BranchOnGreaterThanOrEqualToZero <= '0';
                         Jump <= '0';
                         ALUOp <= "100010";
                         MemWrite <= '0';
                         MemtoReg <= '0';
                         RegWrite <= '0';
        --bgez
        when "000001" => RegDst <= '0';
                         ExtOp <= '1';
                         ALUSrc <= '0';
                         BranchOnEqual <= '0';
                         BranchOnGreaterThanZero <= '0';
                         BranchOnGreaterThanOrEqualToZero <= '1';
                         Jump <= '0';
                         ALUOp <= "100010";
                         MemWrite <= '0';
                         MemtoReg <= '0';
                         RegWrite <= '0';
        --j
        when "000010" => RegDst <= '0';
                         ExtOp <= '0';
                         ALUSrc <= '0';
                         BranchOnEqual <= '0';
                         BranchOnGreaterThanZero <= '0';
                         BranchOnGreaterThanOrEqualToZero <= '0';
                         Jump <= '1';
                         ALUOp <= "000000";
                         MemWrite <= '0';
                         MemtoReg <= '0';
                         RegWrite <= '0';
            when others => RegDst <= '0';
                         ExtOp <= '0';
                         ALUSrc <= '0';
                         BranchOnEqual <= '0';
                         BranchOnGreaterThanZero <= '0';
                         BranchOnGreaterThanOrEqualToZero <= '0';
                         Jump <= '0';
                         ALUOp <= "111111";
                         MemWrite <= '0';
                         MemtoReg <= '0';
                         RegWrite <= '0';
    end case;
end process;

end Behavioral;
