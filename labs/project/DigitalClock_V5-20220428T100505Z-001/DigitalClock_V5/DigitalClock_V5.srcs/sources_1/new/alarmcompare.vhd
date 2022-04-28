
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity alarmcompare is
  Port ( 
    clk : in std_logic;
    rst : in std_logic;
    
    BTNU  : in std_logic;     -- digit up
    BTND  : in std_logic;     -- digit down
    BTNR  : in std_logic;     -- next digit
    BTNL  : in std_logic;     -- previous digit
    
    RGBLED: out std_logic_vector (2 downto 0);
    LEDH1 : out std_logic;
    LEDH2 : out std_logic;
    LEDM1 : out std_logic;
    LEDM2 : out std_logic
);
end alarmcompare;

architecture Behavioral of alarmcompare is

constant c_BLUE        : std_logic_vector(2 downto 0) := b"001"; -- RGB LED is BLUE when the alarm rings
constant c_RED         : std_logic_vector(2 downto 0) := b"100"; -- RGB LED is BLUE when the alarm rings
constant c_GREEN       : std_logic_vector(2 downto 0) := b"010"; -- RGB LED is BLUE when the alarm rings

signal    s_aH1  : std_logic_vector (3 downto 0);
signal    s_aH2  : std_logic_vector (3 downto 0);
signal    s_aM1  : std_logic_vector (3 downto 0);
signal    s_aM2  : std_logic_vector (3 downto 0);

signal    s_cH1  : std_logic_vector (3 downto 0);
signal    s_cH2  : std_logic_vector (3 downto 0);
signal    s_cM1  : std_logic_vector (3 downto 0);
signal    s_cM2  : std_logic_vector (3 downto 0);

signal    switch : std_logic;

begin
  Clock_i : entity work.Clock
    port map(
        clk  => clk,
        rst  => rst,
        H1   => s_cH1,
        H2   => s_cH2,
        M1   => s_cM1,
        M2   => s_cM2,
        switch => switch
    );
  alarm_i : entity work.alarm
    port map(
        clk  => clk,
        rst  => rst,
        H1   => s_aH1,
        H2   => s_aH2,
        M1   => s_aM1,
        M2   => s_aM2,
        UP   => BTNU,
        DOWN => BTND,
        LEFT => BTNL,
        RIGHT => BTNR,
        LEDH2 => LEDH2,
        LEDH1 => LEDH1,
        LEDM2 => LEDM2,
        LEDM1 => LEDM1
    );

compare:process(clk)
begin

    if(rising_edge(clk)) then
       if(s_aH2 = s_cH2) and (s_aH1 = s_cH1) and (s_aM2 = s_cM2) and (s_aM1 = s_cM1) then
          RGBLED <= c_BLUE;
       else
       end if;
    else
    end if;


end process compare;



end Behavioral;
