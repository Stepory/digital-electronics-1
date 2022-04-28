library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Clock is
port(
    clk : in std_logic;
    rst : in std_logic;
    H1  : out std_logic_vector (3 downto 0);
    H2  : out std_logic_vector (3 downto 0);
    M1  : out std_logic_vector (3 downto 0);
    M2  : out std_logic_vector (3 downto 0);
    S1  : out std_logic_vector (3 downto 0);
    S2  : out std_logic_vector (3 downto 0);
    switch : in std_logic
);

end Clock;

architecture Behavioral of Clock is

-- Internal clock enable
signal s_en  : std_logic;      

signal s_H2  : unsigned (3 downto 0) :=(others => '0'); -- Tens of hours
signal s_H1  : unsigned (3 downto 0) :=(others => '0'); -- Hours
signal s_M2  : unsigned (3 downto 0) :=(others => '0'); -- Tens of minutes
signal s_M1  : unsigned (3 downto 0) :=(others => '0'); -- Minutes
signal s_S2  : unsigned (3 downto 0) :=(others => '0'); -- Tens of seconds
signal s_S1  : unsigned (3 downto 0) :=(others => '0'); -- Seconds

signal s_sH2  : std_logic_vector (3 downto 0) ; -- Tens of hours
signal s_sH1  : std_logic_vector (3 downto 0); -- Hours
signal s_sM2  : std_logic_vector (3 downto 0); -- Tens of minutes
signal s_sM1  : std_logic_vector (3 downto 0); -- Minutes

signal BTNU  : std_logic;
signal BTND  : std_logic;
signal BTNL  : std_logic;
signal BTNR  : std_logic;


begin
--------------------------------------------------------------------
-- Instance (copy) of clock_enable entity generates an enable pulse
-- every 10 ms (100 Hz).

     clk_en_i : entity work.clock_enable
        generic map(
            g_MAX => 100000000      -- 1s / (1/100 MHz) = g_MAX
        )
        port map(
            clk   => clk, -- Main clock               
            reset => rst, -- Synchronous reset        
            ce_o  => s_en -- Clock enable pulse signal
        );
--------------------------------------------------------------------
     setClock_i : entity work.setClock
     port map(
        clk  => clk,
        rst  => rst,
        UP   => BTNU,
        DOWN => BTND,
        LEFT => BTNL,
        RIGHT => BTNR,
        switch => switch,
        H1   => s_sH1,
        H2   => s_sH2,
        M1   => s_sM1,
        M2   => s_sM2
     );

roll_over:process(clk)
begin

    if rising_edge(clk) then
        if (rst = '1') then              -- Synchronous reset
                s_H1 <= (others => '0');  
                s_H2 <= (others => '0');
                s_M1 <= (others => '0');
                s_M2 <= (others => '0');
                s_S1 <= (others => '0');
                s_S2 <= (others => '0'); -- Clear all bits
        else if(s_en = '1') then         
                if(s_S1 < "1001") 
                    then s_S1 <= s_S1 + 1;
                else 
                    s_S2 <= s_S2 + 1;
                    s_S1 <= (others => '0');
                if(s_S2 > "0100") then
                    s_M1 <= s_M1 + 1;
                    s_S2 <= (others => '0');
                if(s_M1 > "1000") then
                    s_M2 <= s_M2 + 1;
                    s_M1 <= (others => '0');
                if(s_M2 > "0100") then 
                    s_H1 <= s_H1 + 1;
                    s_M2 <= (others => '0');  
                if(s_H1 > "1000") then 
                    s_H2 <= s_H2 + 1;
                    s_H1 <= (others => '0');
                        else if (s_H1 = "0011") and (s_H2 = "0010") then
                            s_H1 <= (others => '0');
                            s_H2 <= (others => '0');
                        end if;
                end if;
                end if;
                end if;
                end if;
                end if;
        end if;
        end if;
    end if;

end process roll_over;

set : process(clk)
begin
if(rising_edge(clk)) then
if(switch = '0') then
    H1 <= std_logic_vector(s_H1);
    H2 <= std_logic_vector(s_H2);
    M1 <= std_logic_vector(s_M1);
    M2 <= std_logic_vector(s_M2);
    S1 <= std_logic_vector(s_S1);
    S2 <= std_logic_vector(s_S2);
elsif(switch = '1') then
    H1 <= s_sH1;
    H2 <= s_sH2;
    M1 <= s_sM1;
    M2 <= s_sM2;
    S1 <= "0000";
    S2 <= "0000";
else
end if;
else
end if;
end process set;
 
end Behavioral;
