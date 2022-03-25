library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;

entity single_port_ram is

  generic (
    MODE       : string  := "write-first";
    ADDR_WIDTH : natural := 8;
    DATA_WIDTH : natural := 8);

  port (

    
    clk  : in  std_logic;
    -- chip enable of the RAM
    ce   : in  std_logic;

    -- write and read signals
    wr   : in  std_logic;
    rd   : in  std_logic;

    -- address 
    addr : in  std_logic_vector(ADDR_WIDTH-1 downto 0);

    -- data in and data out 
    di   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    do   : out std_logic_vector(DATA_WIDTH-1 downto 0));

end entity single_port_ram;

architecture rtl of single_port_ram is


type T_data is array(0 to ADDR_WIDTH -1) of std_logic_vector(DATA_WIDTH -1 downto 0);
signal RAM :T_data:=(others=>(others=>'0'));
begin  -- architecture rtl

     process (clk)
      begin  
            if(clk'event and clk = '1') then 
                 if( ce = '1') then 
                    
                    if(wr = '1') then 
                        RAM(conv_integer(addr)) <= di;  
                        --new content is made available immediately
                        do <= RAM(conv_integer(addr));
              
                    end if;
                    
                 end if;
           end if;
      end process;
     
end architecture rtl;
