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
signal ROM: memory := ( B"000000_01010_01010_01010_00000_100110", --0 014A5026 00 xor $10, $10, $10         pun in registru valoarea 0
                        B"000000_00000_00000_00000_00000_100110", --1 00000026 01 xor $0, $0, $0            pun in registru valoarea 0
                        B"000000_11110_11110_11110_00000_100110", --2 03DEF026 02 xor $30, $30, $30         pun in registru valoarea 0
                        B"100011_01010_00001_0000000000000000", --3 8D410000 03 lw $1, offset($10) --a      iau primul numar din memorie de la adresa 0
                        B"001000_01010_01010_0000000000000100", --4 214A0004 04 addi $10, $10, 4            incrementez registrul care indica adresa din memorie
                        B"11111111111111111111111111111111", --5 FFFFFFFF 05 NOOP
                        B"11111111111111111111111111111111", --6 FFFFFFFF 06 NOOP
                        B"100011_01010_00010_0000000000000000", --7 8D420000 07 lw $2, offset($10) --b      iau al doilea numar din memorie de la adresa 1
                        B"001000_00000_00000_0000000000001000", --8 20000008 08 addi $0, $0, 8 --adr mem    pun in registrul 8 valoarea 8 (a treaia adresa din memorie)
                        B"000100_00001_11110_0000000000011101", --9 103E001D 09 beq $1, $30, offset 29 (39) compar valoarea din registrul 1 cu valoarea din registrul 30(adica 0), iar daca sunt egale sar 29 instructiuni
                        B"11111111111111111111111111111111", --10 FFFFFFFF 0A NOOP
                        B"11111111111111111111111111111111", --11 FFFFFFFF 0B NOOP
                        B"11111111111111111111111111111111", --12 FFFFFFFF 0C NOOP
                        B"000100_00010_11110_0000000000010110", --13 105E0016 0D beq $2, $30, offset 22 (36)compar valoarea din registrul 2 cu valoarea din registrul 30(adica 0), iar daca sunt egale sar 22 instructiuni
                        B"11111111111111111111111111111111", --14 FFFFFFFF 0E NOOP
                        B"11111111111111111111111111111111", --15 FFFFFFFF 0F NOOP
                        B"11111111111111111111111111111111", --16 FFFFFFFF 10 NOOP
                        B"101011_00000_00001_0000000000000000", --17 AC010000 11 sw $1 offset($0)           scriu in memorie la adresa indicata de registrul 0 valoarea din primul registru
                        B"001000_00000_00000_0000000000000100", --18 20000004 12 sw $1 offset($0)           trec la urmatoarea adresa din memorie
                        B"11111111111111111111111111111111", --19 FFFFFFFF 13 NOOP
                        B"11111111111111111111111111111111", --20 FFFFFFFF 14 NOOP
                        B"101011_00000_00010_0000000000000000", --21 AC020000 15 sw $2 offset($0)           scriu in memorie la adresa indicata de registrul 0 valoarea din al doilea registru
                        B"001000_00000_00000_0000000000000100", --22 20000004 16 addi $0, $0, 4             trec la urmatoarea adresa din memorie
                        B"000000_00001_00010_00011_00000_100010", --23 00221822 17 sub $3, $1, $2           fac diferenta intre valoarea din primul registru si valoarea din al doilea registru, iar rezultatul il pun in registrul 3
                        B"11111111111111111111111111111111", --24 FFFFFFFF 18 NOOP
                        B"11111111111111111111111111111111", --25 FFFFFFFF 19 NOOP
                        B"000111_00011_00000_0000000000000110", --26 1C600006 1A bgtz $3, offset 6 (33)     daca diferenta e mai mare ca 0 sar 3 instructiuni
                        B"11111111111111111111111111111111", --27 FFFFFFFF 1B NOOP
                        B"11111111111111111111111111111111", --28 FFFFFFFF 1C NOOP
                        B"11111111111111111111111111111111", -- 29 FFFFFFFF 1D NOOP
                        B"000000_00010_00001_00010_00000_100010", --30 00411022 1E sub $2, $2, $1           decrementez valoarea din registrul 2 cu valoarea registrului 1
                        B"000010_00000000000000000000001101", --31 800000D 1F j addr 13                     sar la instructiunea 13
                        B"11111111111111111111111111111111", --32 FFFFFFFF 20 NOOP
                        B"000000_00001_00010_00001_00000_100010", --33 00220822 21 sub $1, $1, $2           decrementez valoarea din registrul 1 cu valoarea registrului 2
                        B"000010_00000000000000000000001101", --34 800000D 22 j addr 13                     sar la instructiunea 13
                        B"11111111111111111111111111111111", --35 FFFFFFFF 23 NOOP
                        B"101011_00000_00001_0000000000000000", --36 AC010000 24 sw $1 offset($0)           pun in memorie la adresa data de valoarea din registrul 0 valoarea din registrul 1
                        B"000010_00000000000000000000101000", --37 8000028 25 j addr 40                     sar la instructiunea 40
                        B"11111111111111111111111111111111", --38 FFFFFFFF 26 NOOP
                        B"101011_00000_00010_0000000000000000", --39 AC020000 27 sw $2 offset($0)           pun in memorie la adresa data de valoarea din registrul 0 valoarea din registrul 2
                        others => x"FFFFFFFF");  --40+ 29 NOOP

begin
    data_out <= ROM(conv_integer (address));
end Behavioral;
