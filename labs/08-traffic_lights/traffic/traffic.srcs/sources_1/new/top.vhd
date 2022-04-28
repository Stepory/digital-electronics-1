----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.03.2022 16:05:14
-- Design Name: 
-- Module Name: top - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port ( CLK100MHZ : in STD_LOGIC;
           LED16_R : out STD_LOGIC;
           LED16_G : out STD_LOGIC;
           LED16_B : out STD_LOGIC;
           LED17_R : out STD_LOGIC;
           LED17_G : out STD_LOGIC;
           LED17_B : out STD_LOGIC;
           BTNC : in STD_LOGIC);
end top;

architecture Behavioral of top is

begin
    tlc : entity work.tlc
        port map(
            clk   => CLK100MHZ,
            reset => BTNC,
            west_o(2) => LED16_R,
            west_o(1) => LED16_G,
            west_o(0) => LED16_B,
            south_o(2) => LED17_R,
            south_o(1) => LED17_G,
            south_o(0) => LED17_B
            
            -- MAP TWO RGB LEDS HERE

        );


end Behavioral;
