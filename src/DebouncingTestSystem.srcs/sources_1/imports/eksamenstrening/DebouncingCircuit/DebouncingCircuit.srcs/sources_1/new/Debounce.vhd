----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/05/2020 04:49:12 PM
-- Design Name: 
-- Module Name: Debounce - Behavioral
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

entity Debounce is
    Port ( sw : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           db : out STD_LOGIC);
end Debounce;

architecture Behavioral of Debounce is

    --Finite state machine
    type FSM is (zero, wait1_1, wait1_2, wait1_3, wait0_3, wait0_2, wait0_1, one);
    signal state_reg, state_next : FSM := zero;

    --Internal signals
    signal m_tick : STD_LOGIC;

    -- ModMCounter declaration
    Component ModMCounter 
        Generic(N : integer := 4;
                M : Integer := 16);
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               q : out STD_LOGIC_VECTOR(N-1 downto 0);
               max_tick : out STD_LOGIC);
    end Component;

begin
    --ModMCounter instantiation
    timer : ModMCounter
    port map(clk => clk, rst => rst, q => open, max_tick => m_tick);

    --State register
    process(clk)
    begin
        if rst = '1' then
            state_reg <= zero;
        elsif rising_edge(clk) then
            state_reg <= state_next;
        end if;
    end process;

    --Next state logic
    process(state_reg, sw, m_tick)
    begin
        case state_reg is
            when zero =>
                if sw = '1' then
                    state_next <= wait1_1;
                else
                    state_next <= zero;
                end if;
            when wait1_1 =>
                if sw = '0' then
                    state_next <= zero;
                elsif sw = '1' and m_tick = '1' then
                    state_next <= wait1_2;
                else
                    state_next <= wait1_1;
                end if;
            when wait1_2 =>
                if sw = '0' then
                    state_next <= zero;
                elsif sw = '1' and m_tick = '1' then
                    state_next <= wait1_3;
                else
                    state_next <= wait1_2;
                end if;
            when wait1_3 =>
                if sw = '0' then
                    state_next <= zero;
                elsif sw = '1' and m_tick = '1' then
                    state_next <= one;
                else
                    state_next <= wait1_3;
                end if;
            when wait0_3 =>
                if sw = '1' then
                    state_next <= one;
                elsif sw = '0' and m_tick = '1' then
                    state_next <= zero;
                else
                    state_next <= wait0_3;
                end if;
            when wait0_2 =>
                if sw = '1' then
                    state_next <= one;
                elsif sw = '0' and m_tick = '1' then
                    state_next <= wait0_3;
                else
                    state_next <= wait0_2;
                end if;
            when wait0_1 =>
                if sw = '1' then
                    state_next <= one;
                elsif sw = '0' and m_tick = '1' then
                    state_next <= wait0_2;
                else
                    state_next <= wait0_1;
                end if;
            when one =>
                if sw = '1' then
                    state_next <= one;
                else
                    state_next <= wait0_1;
                end if;
        end case;

    end process;

    --Output Logic
    db <= '1' when state_reg = wait0_3 or state_reg = wait0_2 or state_reg = wait0_1 or state_reg = one else
          '0';

end Behavioral;
