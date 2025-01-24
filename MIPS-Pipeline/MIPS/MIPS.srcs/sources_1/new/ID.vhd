----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2024 11:00:26 AM
-- Design Name: 
-- Module Name: ID - Behavioral
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

entity ID is
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
end ID;

architecture Behavioral of ID is

component RegisterFile is 
port ( clk : in std_logic; 
       ra1 : in std_logic_vector(4 downto 0); 
       ra2 : in std_logic_vector(4 downto 0); 
       wa : in std_logic_vector(4 downto 0); 
       wd : in std_logic_vector(31 downto 0); 
       regwr : in std_logic; 
       rd1 : out std_logic_vector(31 downto 0); 
       rd2 : out std_logic_vector(31 downto 0)); 
end component;

--signal MUX: STD_LOGIC_VECTOR(4 downto 0) := "00000";

begin

    --MUX <= Instr(20 downto 16) when RegDst = '0' else Instr(15 downto 11);
    
    Addr_Target <= Instr(20 downto 16);
    Addr_Dest <= Instr(15 downto 11);

    connectRegisterFile: RegisterFile port map(clk, Instr(25 downto 21), Instr(20 downto 16), WriteAddress, WD, RegWrite, RD1, RD2);
    
    Ext_Imm(15 downto 0) <= Instr(15 downto 0);  
    Ext_Imm(31 downto 16) <= (others => Instr(15)) when ExtOp = '1' else (others => '0'); 
    func <= Instr(5 downto 0);
    sa <= Instr(10 downto 6);
    
end Behavioral;
