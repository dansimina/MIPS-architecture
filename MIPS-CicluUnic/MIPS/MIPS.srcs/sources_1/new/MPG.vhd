----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/10/2024 03:06:38 PM
-- Design Name: 
-- Module Name: MPG - Behavioral
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

entity MPG is
    Port ( enable : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
end MPG;

architecture Behavioral of MPG is
signal cnt_int: std_logic_vector (17 downto 0) := (others => '0');
signal Q1, Q2, Q3: std_logic := '0';
begin
enable <= Q2 and (not Q3);

--Counter
process(clk)
begin
    if rising_edge(clk) then
        cnt_int <= cnt_int + 1;
    end if;
end process;

process(clk)
begin
    if rising_edge(clk) then
        if cnt_int(17 downto 0) = "111111111111111111" then
            Q1 <= btn;
        end if;
        
        Q2 <= Q1;
        Q3 <= Q2;
    end if;
end process;
end Behavioral;