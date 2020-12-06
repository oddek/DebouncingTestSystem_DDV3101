----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/06/2020 11:54:42 AM
-- Design Name: 
-- Module Name: TopBlock - Behavioral
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

entity TopBlock is
    Port ( x : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           sseg : out STD_LOGIC_VECTOR (7 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end TopBlock;

architecture Behavioral of TopBlock is

    --Component Declarations
    Component Debounce
        Port ( sw : in STD_LOGIC;
               rst : in STD_LOGIC;
               clk : in STD_LOGIC;
               db : out STD_LOGIC);
    end Component;

    Component EdgeDetector 
        Port ( x : in STD_LOGIC;
               clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               y : out STD_LOGIC);
    end Component;

    Component ModMCounter 
        Generic(N : integer := 4;
                M : Integer := 10);
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               q : out STD_LOGIC_VECTOR(N-1 downto 0);
               max_tick : out STD_LOGIC);
    end Component;

    Component HexToSseg 
        Port ( hex : in STD_LOGIC_VECTOR (3 downto 0);
               seg : out STD_LOGIC_VECTOR (7 downto 0);
               an : out STD_LOGIC_VECTOR(3 downto 0));
    end Component;

    --Internal signals
    signal db : STD_LOGIC;
    signal edgeTick : STD_LOGIC;
    signal hexVal : STD_LOGIC_VECTOR(3 downto 0); 
begin

    --Component Instantiation
    DebounceComp : Debounce
    port map(sw => x, rst => rst, clk => clk, db => db);

    EdgeDetectorComp : EdgeDetector
    port map(x => db, clk => clk, rst => rst, y => edgeTick);

    Mod10Counter : ModMCounter
    port map(clk => edgeTick, rst => rst, q => hexVal, max_tick => open);

    HexToSsegComp : HexToSseg
    port map(hex => hexVal, seg => sseg, an => an);
    
end Behavioral;
