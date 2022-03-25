library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity fifo is
  generic (
    DEPTH : natural := 8;
    DATA_WIDTH : natural := 8);

  port (
    -- clock and reset
    clk   : in  std_logic;
    rst   : in  std_logic;

    -- write interface
    wr    : in  std_logic;
    di    : in  std_logic_vector(DATA_WIDTH-1 downto 0);

    -- read interface
    rd    : in  std_logic;
    do    : out std_logic_vector(DATA_WIDTH-1 downto 0);

    -- status signals
    empty : out std_logic;
    full  : out std_logic);

end entity fifo;

architecture rtl of fifo is

  type T_data is array(0 to (DEPTH-1)) of std_logic_vector(di'range);
  signal RAM: T_data := (others =>(others=>'0'));

  signal wr_ptr : integer range 0 to (DEPTH-1);
  signal rd_ptr : integer range 0 to (DEPTH-1);
  signal buff_full : std_logic := '0';
  signal buff_empty : std_logic := '0';
  signal fifo_count : integer range 0 to (DEPTH-1) := 0;
begin  -- architecture rtl

process(clk)
  begin 
    

      if(clk'event and clk = '1') then 

        if(rst = '1') then  -- sync reset
          fifo_count <= 0;
          wr_ptr <= 0;
          rd_ptr <= 0;
          do <= x"00";

        else

            -- keep track on number of words in FIFO
          if(wr = '1' and rd = '0') then 
            fifo_count <= fifo_count + 1;
          elsif(wr = '0' and rd = '1') then 
            fifo_count <= fifo_count - 1;
          end if;
        
           -- write to the fifo. Before writing, first check if the fifo is full
          if(wr = '1' and buff_full = '0') then 
            if(wr_ptr = DEPTH -1 )then    
              wr_ptr <= 0;
            else
              wr_ptr <= wr_ptr + 1;
            end if;
            RAM(wr_ptr) <= di;
          end if; 

          -- read from fifo. Before reading, check if it is empty or not 
          if(rd = '1' and buff_empty = '0') then 
            if(rd_ptr = DEPTH-1) then 
              rd_ptr <= 0;
            else
              rd_ptr <= rd_ptr + 1;
            end if;
            do <= RAM(rd_ptr);
          end if;
        
        end if;
      end if;
  end process;
  
      -- when number of words in fifo is equal to its depth, then it is fifo full condition.
      buff_full <= '1' when fifo_count = (depth-1) else '0';
      -- when number of words is 0, then fifo is empty
      buff_empty <= '1' when fifo_count = 0 else '0';
      
      empty <= buff_empty;
      full <= buff_full;

end architecture rtl;
