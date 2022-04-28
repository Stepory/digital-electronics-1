library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alarm is
port(
    clk : in std_logic;
    rst : in std_logic;
    H1  : out std_logic_vector (3 downto 0); -- time digits from Clock.vhd
    H2  : out std_logic_vector (3 downto 0); -- time digits from Clock.vhd
    M1  : out std_logic_vector (3 downto 0); -- time digits from Clock.vhd
    M2  : out std_logic_vector (3 downto 0); -- time digits from Clock.vhd
   
    UP    : in std_logic;     -- digit up
    DOWN  : in std_logic;     -- digit down
    RIGHT : in std_logic;     -- next digit
    LEFT  : in std_logic;     -- previous digit
    
    LEDH1 : out std_logic;
    LEDH2 : out std_logic;
    LEDM1 : out std_logic;
    LEDM2 : out std_logic
);

end alarm;

architecture Behavioral of alarm is

signal    s_en  : std_logic;

signal    s_H1  : unsigned (3 downto 0) :=(others => '0');
signal    s_H2  : unsigned (3 downto 0) :=(others => '0');
signal    s_M1  : unsigned (3 downto 0) :=(others => '0');
signal    s_M2  : unsigned (3 downto 0) :=(others => '0');
signal    s_pst  : std_logic_vector (2 downto 0); -- position of the digit which we are changing (was changed from unasigned)

begin
     clk_en_i : entity work.clock_enable
        generic map(
            g_MAX => 10000000      
        )
        port map(
            clk   => clk, -- Main clock               
            reset => rst, -- Synchronous reset        
            ce_o  => s_en -- Clock enable pulse signal
        );
     
     Dposition_i : entity work.Dposition
        port map(
            clk => clk,
            rst => rst,
            pst => s_pst,
            RIGHT => RIGHT,
            LEFT => LEFT
        );
        
setalarm:process(clk)
begin
  LEDH2 <= '0';
  LEDH1 <= '0';
  LEDM2 <= '0';
  LEDM1 <= '0';

if(rising_edge(clk))then
    if(rst = '1') then
       s_H2 <= "0000";
       s_H1 <= "0000";
       s_M1 <= "0000";
       s_M2 <= "0000";
    elsif(s_en = '1') then 
       if (s_pst = "000") then    -- setting the H2 digit for the alarm
          LEDH2 <= '1';
          if(UP = '1') then
             if(s_H2 < "0011") then
                s_H2 <= s_H2 + 1;
             else
                s_H2 <= (others => '0');
             end if;
          elsif(DOWN = '1') then   
             if (s_H2 < "0000") then
                 s_H2 <= s_H2 - 1;
             else
                 s_H2 <= (others => '0');
             end if;
          else   
          end if;
       elsif(s_pst = "001") then  -- setting the H1 digit for the alarm
          LEDH1 <= '1';
          if(UP = '1') then
             if(s_H1 < "1001") then
                s_H1 <= s_H1 + 1;            
             else
                s_H1 <= (others => '0');
             end if;
          elsif(DOWN = '1') then   
             if (s_H1 < "0000") then
                 s_H1 <= s_H1 - 1;
             else
                 s_H1 <= (others => '0');
             end if;
          else   
          end if;
       elsif(s_pst = "010") then  -- setting the M2 digit for the alarm
          LEDM2 <= '1';
          if(UP = '1') then
             if(s_M2 < "0101") then
                s_M2 <= s_M2 + 1;            
             else
                s_M2 <= (others => '0');
             end if;
          elsif(DOWN = '1') then   
             if (s_M2 < "0000") then
                 s_M2 <= s_M2 - 1;
             else
                 s_M2 <= (others => '0');
             end if;
          else   
          end if;
       elsif(s_pst = "011") then    -- setting the M1 digit for the alarm
          LEDM1 <= '1';
          if(UP = '1') then
             if(s_M1 < "0101") then
                s_M1 <= s_M1 + 1;            
             else
                s_M1 <= (others => '0');
             end if;
          elsif(DOWN = '1') then   
             if (s_M1 < "0000") then
                 s_M1 <= s_M1 - 1;
             else
                 s_M1 <= (others => '0');
             end if;
          else   
          end if;
       else
       end if;
    else
    end if;
else
end if;

end process setalarm;
 
    H1 <= std_logic_vector(s_H1);
    H2 <= std_logic_vector(s_H2);
    M1 <= std_logic_vector(s_M1);
    M2 <= std_logic_vector(s_M2);
    
end Behavioral;
