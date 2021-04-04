-- Random Access Memory (RAM) with
-- 1 read/write port

LIBRARY IEEE;
    USE IEEE.STD_LOGIC_1164.ALL;
    USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- RAM entity
ENTITY RAM IS
  PORT(
       DATAIN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
       ADDRESS : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
       -- Write when 0, Read when 1
       W_R : IN STD_LOGIC;
       DATAOUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
       );
END ENTITY;
