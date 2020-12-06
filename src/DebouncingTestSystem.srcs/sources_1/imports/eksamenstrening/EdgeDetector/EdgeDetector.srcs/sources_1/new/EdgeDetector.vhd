----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/06/2020 10:53:11 AM
-- Design Name: 
-- Module Name: EdgeDetector - Behavioral
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

entity EdgeDetector is
    Port ( x : in STD_LOGIC;
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           y : out STD_LOGIC);
end EdgeDetector;

architecture Behavioral of EdgeDetector is

    type FSM is (zero, edge, one);
    signal state_reg, state_next : FSM := zero;

begin

    process(x, clk)
    begin
        --Change state
        if rst = '1' then
            state_reg <= zero;
        elsif rising_edge(clk) then
            state_reg <= state_next;
        end if;
    end process;

        --Next state logic:
    process(x, state_reg)
    begin
        state_next <= state_reg;
        y <= '0';
        case state_reg is
            when zero =>
                if(x = '1') then
                    state_next <= edge;
                end if;
            when edge =>
                y <= '1';
                if(x = '0') then
                    state_next <= zero;
                else
                    state_next <= one;
                end if;
            when one =>
                if(x = '1') then
                    state_next <= one;
                end if;
        end case;
    end process;
end Behavioral;
