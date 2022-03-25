library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity fifo_tb is
end;

architecture bench of fifo_tb is

  component fifo
    generic (
      depth : natural := 8;
      DATA_WIDTH : natural := 8);
    port (
      clk   : in  std_logic;
      rst   : in std_logic;
      wr    : in  std_logic;
      di    : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      rd    : in  std_logic;
      do    : out std_logic_vector(DATA_WIDTH-1 downto 0);
      empty : out std_logic;
      full  : out std_logic);
  end component;
  
  constant depth : NATURAL  := 8;
  constant DATA_WIDTH : NATURAL  := 8;
  signal clk: std_logic;
  signal rst: std_logic;
  signal wr: std_logic;
  signal di: std_logic_vector(DATA_WIDTH-1 downto 0);
  signal rd: std_logic;
  signal do: std_logic_vector(DATA_WIDTH-1 downto 0);
  signal empty: std_logic;
  signal full: std_logic;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: fifo generic map ( depth => depth,
                          DATA_WIDTH => DATA_WIDTH )
               port map ( clk        => clk,
                          rst        => rst,
                          wr         => wr,
                          di         => di,
                          rd         => rd,
                          do         => do,
                          empty      => empty,
                          full       => full );
  

  -- process to generate the reset signal
  reset_process: process
  begin
    rst <= '1';
    wait for 10ns;
    rst <= '0';
    wait;
  end process;
  
  -- process to generate the clock
  clocking: process
  begin
    clk <= '1' ;
    wait for 5ns;
    clk <= '0';
    wait for 5ns;
  end process;
  

  -- process to generate the data
  data_stimulus:process
  begin 
    di <= x"F0";
    wait for 10ns;
    di <= x"F1";
    wait for 10ns;
    di <= x"F2";
    wait for 10ns;
    di <= x"F3";
    wait for 10ns;
    di <= x"F4";
    wait for 10ns;
    di <= x"F5";
    wait for 10ns;
    di <= x"F6";
    wait for 10ns;
    di <= x"F7";
    wait for 10ns;
     di <= x"F9";
    wait for 10ns;
     di <= x"FA";
    wait for 10ns;
 end process;
 

 -- process to generate the control signals
 control_signals:process
 begin
    wr <= '0';
    rd <= '0';
    wait for 5ns;
    wr <= '1';
    rd <= '0';
    wait for 50ns;
    wr <= '0';
    rd <= '1';
    wait for 50ns;
    wr <= '1';
    rd <= '1';
    wait for 50ns;
end process;

end architecture;
  