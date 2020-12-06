----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/06/2020 11:59:11 AM
-- Design Name: 
-- Module Name: TopBlock_tb - Behavioral
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

entity TopBlock_tb is
--  Port ( );
end TopBlock_tb;

architecture Behavioral of TopBlock_tb is

  --Internal signals
  signal x, rst, clk : STD_LOGIC;
  signal sseg : STD_LOGIC_VECTOR(7 downto 0);
  signal an : STD_LOGIC_VECTOR(3 downto 0);
  constant clk_period : time := 1 ns;

  --Comp declaration
  Component TopBlock 
    Port ( x : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           sseg : out STD_LOGIC_VECTOR (7 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
  end Component;

begin
  --Comp inst.
  UUT: TopBlock
  port map(x => x, rst => rst, clk => clk, sseg => sseg, an => an);

  process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;

  process
  begin
    rst <= '1';
    wait for clk_period;
    rst <= '0';
    wait for clk_period;
    x <= '1';
    wait for clk_period*10;
    x<= '0';
    wait for clk_period*10;

    x <= '1';
    wait for clk_period*10;
    x<= '0';
    wait for clk_period*40;

    x <= '1';
    wait for clk_period*60;
    x<= '0';
    wait for clk_period*10;

    x <= '1';
    wait for clk_period*30;
    x<= '0';
    wait for clk_period*20;
  end process;

end Behavioral;
