----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/14/2024 10:11:13 AM
-- Design Name: 
-- Module Name: RAM - Behavioral
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

entity RAM is
    Port ( clk : in STD_LOGIC;
           we : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR (5 downto 0);
           di : in STD_LOGIC_VECTOR (31 downto 0);
           do : out STD_LOGIC_VECTOR (31 downto 0));
end RAM;

architecture Behavioral of RAM is
type ram_type is array (0 to 63) of std_logic_vector(31 downto 0); 
signal ram : ram_type := ( 
-- X"0000000A", --10
-- X"00000019", --25
-- X"00000020", --32
-- X"00000018", --24
 X"00000014", --20
 X"00000024", --36
-- X"00000005", --5
-- X"00000007", --7
-- X"00000000", --0
-- X"00000024", --36
 others => X"00000000"); 
 
begin 

 do <= ram(conv_integer(addr));
 
 process(clk) 
 begin 
 if rising_edge(clk) then 
    if we = '1' then 
     ram(conv_integer(addr)) <= di; 
    end if;  
  end if; 
 end process; 
end Behavioral;
