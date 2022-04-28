
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity setTime is
    port(
        clk : in std_logic;
        rst : in std_logic;
        UP    : in std_logic;     -- digit up
        DOWN  : in std_logic;     -- digit down
        RIGHT : in std_logic;     -- next digit
        LEFT  : in std_logic;     -- previous digit
        switch : in std_logic  
    
    );
end setTime;


architecture Behavioral of setTime is

signal    s_H1  : std_logic_vector (3 downto 0);
signal    s_H2  : std_logic_vector (3 downto 0);
signal    s_M1  : std_logic_vector (3 downto 0);
signal    s_M2  : std_logic_vector (3 downto 0);

signal    s_cH1  : std_logic_vector (3 downto 0);
signal    s_cH2  : std_logic_vector (3 downto 0);
signal    s_cM1  : std_logic_vector (3 downto 0);
signal    s_cM2  : std_logic_vector (3 downto 0);

begin
  Clock_i : entity work.Clock
    port map(
        clk  => clk,
        rst  => rst,
        H1   => s_cH1,
        H2   => s_cH2,
        M1   => s_cM1,
        M2   => s_cM2
     );
   setClock_i : entity work.setClock
     port map(
        clk  => clk,
        rst  => rst,
        UP   => UP,
        DOWN => DOWN,
        LEFT => LEFT,
        RIGHT => RIGHT,
        switch => switch,
        H1   => s_H1,
        H2   => s_H2,
        M1   => s_M1,
        M2   => s_M2
     );


end Behavioral;
