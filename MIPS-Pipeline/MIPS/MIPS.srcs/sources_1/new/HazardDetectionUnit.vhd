----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/24/2024 11:25:29 AM
-- Design Name: 
-- Module Name: HazardDetectionUnit - Behavioral
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

entity HazardDetectionUnit is
    Port ( clk : in STD_LOGIC;
           ID_EX_MemRead : in STD_LOGIC;
           ID_EX_RT : in STD_LOGIC_VECTOR (4 downto 0);
           IF_ID_RS : in STD_LOGIC_VECTOR (4 downto 0);
           IF_ID_RT : in STD_LOGIC_VECTOR (4 downto 0);
           stall : out STD_LOGIC);
end HazardDetectionUnit;

architecture Behavioral of HazardDetectionUnit is

begin
    process(clk)
    begin 
        if (ID_EX_MemRead = '1' and ((ID_EX_RT = IF_ID_RS) or (ID_EX_RT = IF_ID_RT))) then
            stall <= '1';
        else 
            stall <= '0';
        end if;
        
    end process;

end Behavioral;
