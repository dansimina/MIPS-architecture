----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2024 12:27:52 AM
-- Design Name: 
-- Module Name: ROM - Behavioral
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

entity ROM is
    Port ( address : in STD_LOGIC_VECTOR (5 downto 0);
           data_out : out STD_LOGIC_VECTOR (31 downto 0));
end ROM;

architecture Behavioral of ROM is

type memory is array (0 to 63) of std_logic_vector (31 downto 0);
signal ROM: memory := ( B"000000_01010_01010_01010_00000_100110", -- 014A5026 00 xor $10, $10, $10      pun in registru valoarea 0
                        B"000000_00000_00000_00000_00000_100110", -- 00000026 01 xor $0, $0, $0         pun in registru valoarea 0
                        B"000000_11110_11110_11110_00000_100110", -- 03DEF026 02 xor $30, $30, $30      pun in registru valoarea 0

                        B"100011_01010_00001_0000000000000000", -- 8D410000 03 lw $1, offset($10)       iau primul numar din memorie de la adresa 0
                        B"001000_01010_01010_0000000000000100", -- 214A0004 04 addi $10, $10, 4         incrementez registrul care indica adresa din memorie
                        B"100011_01010_00010_0000000000000000", -- 8D420000 05 lw $2, offset($10)       iau al doilea numar din memorie de la adresa 1
                        
                        B"001000_00000_00000_0000000000001000", -- 20000008 06 addi $0, $0, 8           pun in registrul 8 valoarea 8 (a treaia adresa din memorie)
                        
                        B"000100_00001_11110_0000000000001101", -- 103E000D 07 beq $1, $30, offset 13   compar valoarea din registrul 1 cu valoarea din registrul 30(adica 0), iar daca sunt egale sar 14 instructiuni
                        
                        B"000100_00010_11110_0000000000001010", -- 105E000A 08 beq $2, $30, offset 10   compar valoarea din registrul 2 cu valoarea din registrul 30(adica 0), iar daca sunt egale sar 11 instructiuni
                        
                        B"101011_00000_00001_0000000000000000", -- AC010000 09 sw $1 offset($0)         scriu in memorie la adresa indicata de registrul 0 valoarea din primul registru
                        B"001000_00000_00000_0000000000000100", -- 20000004 0A addi $0, $0, 4           trec la urmatoarea adresa din memorie
                        B"101011_00000_00010_0000000000000000", -- AC020000 0B sw $2 offset($0)         scriu in memorie la adresa indicata de registrul 0 valoarea din al doilea registru
                        B"001000_00000_00000_0000000000000100", -- 20000004 0C addi $0, $0, 4           trec la urmatoarea adresa din memorie
                        
                        B"000000_00001_00010_00011_00000_100010", -- 00221822 0D sub $3, $1, $2         fac diferenta intre valoarea din primul registru si valoarea din al doilea registru, iar rezultatul il pun in registrul 3
                        B"000111_00011_00000_0000000000000010", -- 1C600002 0E bgtz $3, offset 2        daca diferenta e mai mare ca 0 sar 3 instructiuni
                        B"000000_00010_00001_00010_00000_100010", -- 00411022 0F sub $2, $2, $1         decrementez valoarea din registrul 2 cu valoarea registrului 1
                        B"000010_00000000000000000000001000", -- 08000008 10 j addr 8                   sar la instructiunea 8
                        B"000000_00001_00010_00001_00000_100010", -- 00220822 11 sub $1, $1, $2         decrementez valoarea din registrul 1 cu valoarea registrului 2
                        B"000010_00000000000000000000001000", -- 08000008 12 j addr 8                   sar la instructiunea 8
                        
                        B"101011_00000_00001_0000000000000000", -- AC010000 13 sw $1 offset($0)         pun in memorie la adresa data de valoarea din registrul 0 valoarea din registrul 1
                        B"000010_00000000000000000000010110", -- 08000016 14 j addr 22                  sar la instructiunea 22
                        B"101011_00000_00010_0000000000000000", -- AC020000 15 sw $2 offset($0)         pun in memorie la adresa data de valoarea din registrul 0 valoarea din registrul 2
                        others => x"FFFFFFFF");

begin
    data_out <= ROM(conv_integer (address));
end Behavioral;
