----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Top is
    Port ( CLK100MHZ : in STD_LOGIC; -- Main clock
           SW : in STD_LOGIC; -- Counter direction
           CA : out STD_LOGIC; -- Cathod A
           CB : out STD_LOGIC; -- Cathod B
           CC : out STD_LOGIC; -- Cathod C
           CD : out STD_LOGIC; -- Cathod D
           CE : out STD_LOGIC; -- Cathod E
           CF : out STD_LOGIC; -- Cathod F
           CG : out STD_LOGIC; -- Cathod G
           DP : out STD_LOGIC; -- Decimal point
           AN : out STD_LOGIC_VECTOR (7 downto 0); -- Common anode signals to individual displays
           BTNC : in STD_LOGIC; -- Synchronous reset
           BTNU : in STD_LOGIC;
           BTNL : in STD_LOGIC;
           BTNR : in STD_LOGIC;
           BTND : in STD_LOGIC;
           LED16_R : out std_logic;
           LED16_G : out std_logic;
           LED16_B : out std_logic;
           LED    :  out std_logic_vector (15 downto 0)

          );
end Top;


architecture Behavioral of top is

-- Internal clock enable
  signal s_en  : std_logic;
-- Internal counter
  signal s_cnt : std_logic_vector(3 - 1 downto 0);
  
  signal s_cnt5  : std_logic_vector(3 downto 0);
  signal s_cnt4  : std_logic_vector(3 downto 0);
  signal s_cnt3  : std_logic_vector(3 downto 0);
  signal s_cnt2  : std_logic_vector(3 downto 0);
  signal s_cnt1  : std_logic_vector(3 downto 0);
  signal s_cnt0  : std_logic_vector(3 downto 0);    
  
begin

  --------------------------------------------------------------------
  
  --Instance of Clock
  Clock_i : entity work.Clock
    port map(
        clk  => CLK100MHZ,
        rst  => BTNC,
        H2   => s_cnt5,
        H1   => s_cnt4,
        M2   => s_cnt3,
        M1   => s_cnt2,
        S2   => s_cnt1,
        S1   => s_cnt0,
        switch => SW
    );
  --------------------------------------------------------------------
--     setClock_i : entity work.setClock
--     port map(
--        clk  => CLK100MHZ,
--        rst  => BTNC,
--        UP   => BTNU,
--        DOWN => BTND,
--        LEFT => BTNL,
--        RIGHT => BTNR,
--        switch => SW,
--        H1   => s_cnt4,
--        H2   => s_cnt5,
--        M1   => s_cnt2,
--        M2   => s_cnt0
--     );

  -- Instance (copy) of clock_enable entity
  clk_en0 : entity work.clock_enable
      generic map(
          g_MAX => 100000000
      )
      port map(
          clk   => CLK100MHZ,
          reset => BTNC,
          ce_o  => s_en
      );
      
  -- Instance (copy) of cnt_up_down entity
  bin_cnt0 : entity work.cnt_up_down
     generic map(
            g_CNT_WIDTH  => 3
      )
      port map(
            clk      => CLK100MHZ,
            reset    => BTNC,
            en_i     => s_en,
            cnt_up_i => '1',
            cnt_o    => s_cnt     
       );

  --------------------------------------------------------------------
  --------------------------------------------------------------------
  -- Instance (copy) of driver_7seg_6digits entity
  driver_seg_6_i : entity work.driver_7seg_6digits
      port map(
          clk      => CLK100MHZ,
          reset    => BTNC,
          data5_i  => s_cnt5,
          data4_i  => s_cnt4,
          data3_i  => s_cnt3,
          data2_i  => s_cnt2,
          data1_i  => s_cnt1,
          data0_i  => s_cnt0,
          dp_i     => "101011",
          dp_o     => DP,
          dig_o (6-1 downto 0)    => AN (5 downto 0 ),
          seg_o(6) => CA,
          seg_o(5) => CB,
          seg_o(4) => CC,
          seg_o(3) => CD,
          seg_o(2) => CE,
          seg_o(1) => CF,
          seg_o(0) => CG
      );

  -- Disconnect the top two digits of the 7-segment display
  AN(7 downto 6)<= b"11";

    alarmcompare_i : entity work.alarmcompare
      port map(
        clk         => CLK100MHZ,
        rst         => BTNC,
        BTNU        => BTNU,       -- digit up
        BTND        => BTND, -- digit down
        BTNR        => BTNR, -- next digit
        BTNL        => BTNL,  -- previous digit
        RGBLED(0)   => LED16_R,
        RGBLED(1)   => LED16_G,
        RGBLED(2)   => LED16_B,
        LEDH2     => LED(10),
        LEDH1     => LED(9),
        LEDM2     => LED(8),
        LEDM1     => LED(7)
      );


  -- Display counter values on LEDs
  --LED(3 downto 0) <= s_cnt;

end architecture Behavioral;