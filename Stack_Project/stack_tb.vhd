library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity stack_tb is
end;

architecture bench of stack_tb is

  component stack
    generic (
      ADDR_WIDTH : natural := 8;
      DATA_WIDTH : natural := 8);
    port (
      clk   : in  std_logic;
      push  : in  std_logic;
      empty : out std_logic;
      di    : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      pop   : in  std_logic;
      full  : out std_logic;
      do    : out std_logic_vector(DATA_WIDTH-1 downto 0));
   end component;
  
  signal DATA_WIDTH : natural:= 8;
  signal ADDR_WIDTH : natural:= 8;
  signal clk: std_logic;
  signal push: std_logic;
  signal empty: std_logic;
  signal di: std_logic_vector(DATA_WIDTH-1 downto 0);
  signal pop: std_logic;
  signal full: std_logic;
  signal do: std_logic_vector(DATA_WIDTH-1 downto 0);

  constant clock_period: time := 10 ns;
  
begin

  -- Insert values for generic parameters !!
  uut: stack generic map ( ADDR_WIDTH => ADDR_WIDTH,
                           DATA_WIDTH => DATA_WIDTH)
                port map ( clk        => clk,
                           push       => push,
                           empty      => empty,
                           di         => di,
                           pop        => pop,
                           full       => full,
                           do         => do );

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
  

  -- controls PUSH and POP opertation
  push_pop:process
  begin 
    push <= '1';
    pop  <= '0';
    wait for 50ns;
    push <= '0';
    pop  <= '1';
    wait for 50ns;
  end process;
  

  -- generation of the clock signal. 
  clocking: process
  begin
    clk <= '0', '1' after clock_period / 2;
  end process;

end;
  