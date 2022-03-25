library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use ieee.std_logic_unsigned.all;

entity single_port_ram_tb is
end;

architecture bench of single_port_ram_tb is

  component single_port_ram
    generic (
     
      ADDR_WIDTH : natural := 10;
      DATA_WIDTH : natural := 8);
    port (
      clk  : in  std_logic;
      ce   : in  std_logic;
      wr   : in  std_logic;
      rd   : in  std_logic;
      addr : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
      di   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      do   : out std_logic_vector(DATA_WIDTH-1 downto 0));
  end component;
  
  constant ADDR_WIDTH : NATURAL  := 10;
  constant DATA_WIDTH : NATURAL  := 8;
  signal clk: std_logic;
  signal ce: std_logic;
  signal wr: std_logic;
  signal rd: std_logic;
  signal addr: std_logic_vector(ADDR_WIDTH-1 downto 0);
  signal di: std_logic_vector(DATA_WIDTH-1 downto 0);
  signal do: std_logic_vector(DATA_WIDTH-1 downto 0);

  

begin

  -- Insert values for generic parameters !!
  uut: single_port_ram generic map ( 
                                     ADDR_WIDTH => ADDR_WIDTH ,
                                     DATA_WIDTH => DATA_WIDTH )
                          port map ( clk        => clk,
                                     ce         => ce,
                                     wr         => wr,
                                     rd         => rd,
                                     addr       => addr,
                                     di         => di,
                                     do         => do );
  

  -- Chip enable process
  stimulus: process
  begin
    ce <= '0';
    wait for 10ns;
    ce <= '1';
    wait;
  end process;
  
  -- clock generation
  clocking: process
  begin
     clk <= '1' ;
     wait for 5ns;
     clk <= '0';
     wait for 5ns;
  end process;
  
  -- generate control signals (Read and write)
  STIM2:PROCESS
  BEGIN
    wr <= '1';
    RD <= '0';
    
    WAIT FOR 120NS;
    
    wr <= '0';
    RD <= '1';
    
    WAIT FOR 120NS;
 END PROCESS;
 

 -- generate addresses for the RAM
process
begin   
  addr <= "0000000001";
  wait for 15ns;
   addr <= "0000000010";
  wait for 15ns;
   addr <= "0000000011";
  wait for 15ns;
   addr <= "0000000100";
  wait for 15ns;
   addr <= "0000000101";
  wait for 15ns;
   addr <= "0000000110";
  wait for 15ns;
end process;  
 

 -- generate the data to be written
 STIM3:PROCESS
 BEGIN 
   di <= x"00"; wait for 20ns;
   di <= x"01"; wait for 20ns;
   di <= x"02"; wait for 20ns;
   di <= x"03"; wait for 20ns;
   di <= x"04"; wait for 20ns;
   di <= x"05"; wait for 20ns;
  
 END PROCESS;

end;