library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity stack is
  
  generic (
    ADDR_WIDTH : natural := 8;
    DATA_WIDTH : natural := 8);

  port (
    clk   : in  std_logic;

    -- interface 
    push  : in  std_logic;
    empty : out std_logic;
    di    : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    pop   : in  std_logic;
    full  : out std_logic;
    do    : out std_logic_vector(DATA_WIDTH-1 downto 0));

 end entity stack;


architecture rtl of stack is  -- architecture begins here. 


-- single port RAM component imported
component single_port_ram is 
generic (
  MODE       : string  := "read_first";
  ADDR_WIDTH : natural := 8;
  DATA_WIDTH : natural := 8);
  port (
    clk  : in  std_logic;
    ce   : in  std_logic;
    wr   : in  std_logic;
    rd   : in  std_logic;
    addr : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
    di   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    do   : out std_logic_vector(DATA_WIDTH-1 downto 0));
end component single_port_ram;



signal ce :std_logic;
signal rd : std_logic;
signal wr : std_logic;
signal push_and_not_full : std_logic;
signal pop_and_not_empty :std_logic;
signal push_or_pop : std_logic;
signal sp_nxt : std_logic_vector(ADDR_WIDTH downto 0) := (others => '0');
signal sp_reg : std_logic_vector(ADDR_WIDTH downto 0) := (others => '0');
signal full_s : std_logic:= '0';
signal empty_s :std_logic:= '1';
signal mem_addr :std_logic_vector(ADDR_WIDTH-1 downto 0) := (others => '0');


begin  -- architecture rtl


-- single port RAM mapping.
single_port_ram_1 : single_port_ram
  generic map(
    MODE       =>"read_first",
    ADDR_WIDTH => ADDR_WIDTH,
    DATA_WIDTH => DATA_WIDTH)

  port map 
  (
    clk  => clk,
    ce   => ce,
    wr   => wr,
    rd   => rd,
    addr => mem_addr,
    di   => di,
    do   => do
  );
	

  
	push_and_not_full <= push and not full_s;
	pop_and_not_empty <= pop and not empty_s;
  push_or_pop <= push_and_not_full or pop_and_not_empty;

  -- chip enable while performing push and pop.
	ce <= push_or_pop;
	
  -- During POP operation, decrement the stack pointer else increment
	sp_nxt <= std_logic_vector(unsigned(sp_reg)-1) when pop_and_not_empty ='1' else std_logic_vector(unsigned(sp_reg)+1);
	
  -- During POP operation, use sp_nxt directly. During PUSH operation, use sp_reg.
	mem_addr <= sp_nxt(sp_reg'left-1 downto 0) when pop_and_not_empty = '1' else 
	            sp_reg(sp_reg'left-1 downto 0);


  -- when it is POP operation and stack is not empty, read from the stack			
	rd <= pop_and_not_empty;

  -- else write into the stack. 
	wr <= not pop_and_not_empty;
	

  -- process to update the stack pointer register.
	process(clk)
	begin 
	   if(clk'event and clk = '1') then 
	      if(ce = '1') then 
		    sp_reg <= sp_nxt;
	      end if;
	   end if;
	end process;


  -- track the sp_reg's left most bit to check if the stack is full or not.     
	full_s <= sp_reg(sp_reg'left);
	full <= full_s;
	
  -- when all the bits of sp_reg are '0', then it is stack is empty. 
	empty_s <= '1' when sp_reg = (sp_reg'range => '0') else '0';
	
	empty <= empty_s;

end architecture rtl;
