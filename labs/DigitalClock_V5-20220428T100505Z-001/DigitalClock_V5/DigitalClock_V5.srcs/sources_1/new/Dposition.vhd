library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Dposition is
  Port (
    clk : in std_logic;
    rst : in std_logic;
    RIGHT : in std_logic;     -- next digit
    LEFT  : in std_logic;      -- previous digit
    pst   : out std_logic_vector (2 downto 0)
 );

end Dposition;

architecture Behavioral of Dposition is

signal    s_en  : std_logic;
signal    s_pst  : unsigned (2 downto 0) :=(others => '0'); -- position of the digit which we are changing

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
position:process(clk)
begin
    if(rising_edge(clk)) then   -- setting the position of the digit which will be altered
       if (rst = '1') then  
           s_pst <= "000";
       elsif(s_en = '1') then
           if(RIGHT = '1') then
              if(s_pst = "011") then
                 s_pst <= "000";
              elsif(s_pst < "0100") then
                 s_pst <= s_pst + 1;
              elsif(s_pst = "011") then
                 s_pst <= "000";
              else
                 s_pst <= (others => '0');
              end if;
           elsif(LEFT = '1') then
              if(s_pst = "000") then
                 s_pst <= "011";
              else
                 s_pst <= s_pst - 1;       
              end if;
           else
           end if;
        end if;
     else
     end if;
end process position;  
pst <= std_logic_vector(s_pst); 

end Behavioral;
