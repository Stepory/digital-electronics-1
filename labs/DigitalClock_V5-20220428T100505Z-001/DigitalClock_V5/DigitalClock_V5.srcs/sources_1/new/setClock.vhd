-- Import Libraries --
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity setClock is
	port( 
	    clk : in std_logic;
        rst : in std_logic;
		H1  : out std_logic_vector (3 downto 0);
        H2  : out std_logic_vector (3 downto 0);
        M1  : out std_logic_vector (3 downto 0);
        M2  : out std_logic_vector (3 downto 0);
        UP    : in std_logic;     -- digit up
        DOWN  : in std_logic;     -- digit down
        RIGHT : in std_logic;     -- next digit
        LEFT  : in std_logic;     -- previous digit
        switch : in std_logic     -- switch which will turn the buttons into setTime mode
	);
end setClock;


architecture Behaviour of setClock is   

signal s_H1  : unsigned (3 downto 0) :=(others => '0'); -- Hours
signal s_H2  : unsigned (3 downto 0) :=(others => '0'); -- Tens of hours 
signal s_M1  : unsigned (3 downto 0) :=(others => '0'); -- Minutes
signal s_M2  : unsigned (3 downto 0) :=(others => '0'); -- Tens of minutes 
signal s_en  : std_logic;
signal s_pst : std_logic_vector (2 downto 0);

begin

     clk_en_i : entity work.clock_enable
        generic map(
            g_MAX => 100000000      -- 1s / (1/100 MHz) = g_MAX
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
        
setTime:process(clk)
begin
    if(rising_edge(clk)) then
       if(rst = '1') then
          s_H1 <= (others => '0');  
          s_H2 <= (others => '0');
          s_M1 <= (others => '0');
          s_M2 <= (others => '0');
           -- Clear all bits
       elsif(s_en = '1') then
          if(switch = '1') then
             if(s_pst = "000") then -- changing the s_H1
                if(UP = '1') then
                   if(s_H1 < "0011") then
                      s_H1 <= s_H1 + 1; 
                   else
                      s_H1 <= (others => '0');
                   end if;              
                elsif(DOWN = '1') then
                   if(s_H1 = "0000") then
                      s_H1 <= "0011";
                   else
                      s_H1 <= s_H1 - 1; 
                   end if;
                else 
                end if;        
             elsif(s_pst = "001") then -- changing the s_H2
                if(UP = '1') then
                   if(s_H2 < "1001") then
                      s_H2 <= s_H2 + 1; 
                   else
                      s_H2 <= (others => '0');
                   end if; 
                elsif(DOWN = '1') then
                   if(s_H2 = "0000") then
                      s_H2 <= "1001";
                   else 
                      s_H2 <= s_H2 - 1;
                   end if;
                else 
                end if;  
             elsif(s_pst = "010") then -- changing the s_M1
                if(UP = '1') then
                   if(s_M1 < "0110") then
                      s_M1 <= s_M1 + 1; 
                   else
                      s_M1 <= (others => '0');
                   end if;
                elsif(DOWN = '1') then
                   if(s_M1 = "0000") then
                      s_M1 <= "0101";
                   else 
                      s_M1 <= s_M1 - 1;
                   end if;
                else 
                end if;  
             elsif(s_pst = "011") then -- changing the s_M2
                if(UP = '1') then
                   if(s_M2 < "1001") then
                      s_M2 <= s_M2 + 1; 
                   else
                      s_M2 <= (others => '0');
                   end if;
                elsif(DOWN = '1') then
                   if(s_M2 = "0000") then
                      s_M2 <= "1001";
                   else 
                      s_M2 <= s_M2 - 1;
                   end if;
                else 
                end if;  
             else
             end if;
          else
          end if;
       else
       end if;   
    else
    end if;

end process setTime;
    H1 <= std_logic_vector(s_H1);
    H2 <= std_logic_vector(s_H2);
    M1 <= std_logic_vector(s_M1);
    M2 <= std_logic_vector(s_M2);
end Behaviour;