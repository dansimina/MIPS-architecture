----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/10/2024 03:05:49 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
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

entity SSD is
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR (31 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end SSD;

architecture Behavioral of SSD is
signal cnt: std_logic_vector (16 downto 0) := "00000000000000000";
signal out_an: std_logic_vector (7 downto 0) := "00000000";
signal out_cat: std_logic_vector (3 downto 0) := "0000";
begin

--counter
    process(clk)
    begin 
        if rising_edge(clk) then
            cnt <= cnt + 1;
        end if;
    end process;
--mux 8:1
    process(cnt(16 downto 14))
    begin 
        case cnt(16 downto 14) is
            when "000" => out_an <= "11111110";
                          out_cat <= digits(3 downto 0);
            when "001" => out_an <= "11111101";
                          out_cat <= digits(7 downto 4);
            when "010" => out_an <= "11111011";
                          out_cat <= digits(11 downto 8);
            when "011" => out_an <= "11110111";
                          out_cat <= digits(15 downto 12);
            when "100" => out_an <= "11101111";
                          out_cat <= digits(19 downto 16);
            when "101" => out_an <= "11011111";
                          out_cat <= digits(23 downto 20);
            when "110" => out_an <= "10111111";
                          out_cat <= digits(27 downto 24);
            when "111" => out_an <= "01111111";
                          out_cat <= digits(31 downto 28);
            when others => out_an <= x"11";
                           out_cat <= "0000";
        end case;
    end process;
    
   an <= out_an;
        with out_cat SELect
   cat<= "1111001" when "0001",   --1
         "0100100" when "0010",   --2
         "0110000" when "0011",   --3
         "0011001" when "0100",   --4
         "0010010" when "0101",   --5
         "0000010" when "0110",   --6
         "1111000" when "0111",   --7
         "0000000" when "1000",   --8
         "0010000" when "1001",   --9
         "0001000" when "1010",   --A
         "0000011" when "1011",   --b
         "1000110" when "1100",   --C
         "0100001" when "1101",   --d
         "0000110" when "1110",   --E
         "0001110" when "1111",   --F
         "1000000" when others;

end Behavioral;
