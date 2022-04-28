------------------------------------------------------------
--
-- Driver for 6-digit 7-segment display.
-- Nexys A7-50T, Vivado v2020.1.1, EDA Playground
--
-- Copyright (c) 2020-Present Tomas Fryza
-- Dept. of Radio Electronics, Brno Univ. of Technology, Czechia
-- This work is licensed under the terms of the MIT license.
--
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------------------------------------------------------
-- Entity declaration for display driver
------------------------------------------------------------
entity driver_7seg_6digits is
    port(
        clk     : in  std_logic;
        reset   : in  std_logic;
        -- 6-bit input values for individual digits
        data5_i : in  std_logic_vector(3 downto 0);
        data4_i : in  std_logic_vector(3 downto 0);
        data3_i : in  std_logic_vector(3 downto 0);
        data2_i : in  std_logic_vector(3 downto 0);
        data1_i : in  std_logic_vector(3 downto 0);
        data0_i : in  std_logic_vector(3 downto 0);        
        -- 6-bit input value for decimal points
        dp_i    : in  std_logic_vector(6 - 1 downto 0);
        -- Decimal point for specific digit, which mean choose the location of decimal point
        dp_o    : out std_logic;
        -- Cathode values for individual segments
        seg_o   : out std_logic_vector(7 - 1 downto 0);
        -- Common anode signals to individual displays, which mean choose which digit we want to control
        dig_o   : out std_logic_vector(6 - 1 downto 0)
    );
end entity driver_7seg_6digits;

------------------------------------------------------------
-- Architecture declaration for display driver
------------------------------------------------------------
architecture Behavioral of driver_7seg_6digits is

    -- Internal clock enable
    signal s_en  : std_logic;
    -- Internal 2-bit counter for multiplexing 4 digits
    signal s_cnt : std_logic_vector(3 - 1 downto 0);
    -- Internal 4-bit value for 7-segment decoder
    signal s_hex : std_logic_vector(4 - 1 downto 0);

begin
    --------------------------------------------------------
    -- Instance (copy) of clock_enable entity generates 
    -- an enable pulse every 4 ms
    clk_en0 : entity work.clock_enable
        generic map(
            g_MAX => 10000
        )
        port map(
            clk   => clk,
            reset => reset,
            ce_o  => s_en
        );

    --------------------------------------------------------
    -- Instance (copy) of cnt_up_down entity performs a 2-bit
    -- down counter
    bin_cnt0 : entity work.cnt_up_down
        generic map(
            g_CNT_WIDTH => 3
        )
        port map(
            clk       => clk,    
            reset     => reset,  
            en_i      => s_en,
            cnt_up_i  => '1',
            cnt_o     => s_cnt
        );

    --------------------------------------------------------
    -- Instance (copy) of hex_7seg entity performs a 7-segment
    -- display decoder
    hex2seg : entity work.hex_7seg
        port map(
            hex_i => s_hex,
            seg_o => seg_o
        );

    --------------------------------------------------------
    -- p_mux:
    -- A sequential process that implements a multiplexer for
    -- selecting data for a single digit, a decimal point 
    -- signal, and switches the common anodes of each display.
    --------------------------------------------------------
    p_mux : process(clk)
    begin
        if rising_edge(clk) then
            if (reset = '1') then
                s_hex <= data0_i;
                dp_o  <= dp_i(0);
                dig_o <= "111110";
            else 
                case s_cnt is -- selection lines of multiplexer
                    when "000" =>
                        s_hex <= data5_i;
                        dp_o  <= dp_i(5);
                        dig_o <= "011111"; -- Common anode signals to individual displays, when "0111", which mean the leftmost will be controled.
                    when "001" =>
                        s_hex <= data4_i;
                        dp_o  <= dp_i(4);
                        dig_o <= "101111";
                    when "010" =>
                        s_hex <= data3_i;
                        dp_o  <= dp_i(3);
                        dig_o <= "110111";
                    when "011" =>
                        s_hex <= data2_i;
                        dp_o  <= dp_i(2);
                        dig_o <= "111011";                       
                    when "100" =>
                        s_hex <= data1_i;
                        dp_o  <= dp_i(1);
                        dig_o <= "111101";                                                                                          
                    when others =>
                        s_hex <= data0_i;
                        dp_o  <= dp_i(0);
                        dig_o <= "111110";
                end case;
            end if;
        end if;
    end process p_mux;

end architecture Behavioral;
