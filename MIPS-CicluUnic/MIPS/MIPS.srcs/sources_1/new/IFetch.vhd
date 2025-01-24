----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2024 11:26:56 AM
-- Design Name: 
-- Module Name: IFetch - Behavioral
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

entity IFetch is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           Jump : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           Jump_Address : in STD_LOGIC_VECTOR(31 downto 0);
           Branch_Address : in STD_LOGIC_VECTOR(31 downto 0);
           PC_4 : out STD_LOGIC_VECTOR(31 downto 0);
           Instruction : out STD_LOGIC_VECTOR(31 downto 0)
           );
end IFetch;

architecture Behavioral of IFetch is

component ROM is
    Port ( address : in STD_LOGIC_VECTOR (5 downto 0);
           data_out : out STD_LOGIC_VECTOR (31 downto 0));
end component;

signal sum: STD_LOGIC_VECTOR(31 downto 0) := x"00000000";
signal MUX1: STD_LOGIC_VECTOR(31 downto 0) := x"00000000";
signal MUX2: STD_LOGIC_VECTOR(31 downto 0) := x"00000000";
signal PC: STD_LOGIC_VECTOR(31 downto 0) := x"00000000";

begin

    process(clk, reset) 
    begin
        if reset = '1' then 
            PC <= x"00000000";
        elsif rising_edge (clk) then 
            PC <= MUX2;
        end if;
    end process;
    
    connectROM: ROM port map(PC(5 downto 0), Instruction);

    sum <= PC + 1;
    PC_4 <= sum;
    
    MUX1 <= sum when PCSrc = '0' else Branch_Address;
    MUX2 <= MUX1 when Jump = '0' else Jump_Address;
    
end Behavioral;
