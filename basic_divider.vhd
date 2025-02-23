--------------------------------------------------------------------------------
-- UTFPR - Universidade Tecnol�gica Federal do Paraná - Curitiba - PR
-- Projeto : Divisor de frequência
-- Arquivo : basic_divider.vhd
-- Autor   : prof. Gortan
-- Data    : Abril 2020
--
----------------------------------------------------------------------------
-- Descrição :
-- divisor de frequência genérico
----------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;

entity divider is
  generic(divisor: integer := 5);
  port(
    clk_in		: in  std_logic;	-- clock in.
    clk_out		: out std_logic		-- clock in dividido 2 x divisor
    );
end divider;
----------------------------------------------------------------------------
architecture divisor of divider is
signal temp: std_logic :='0';
begin

	P_div:process (clk_in)                                              
	variable count:integer range 0 to divisor;
	begin                                                                
		if clk_in'event and clk_in = '1' then
			count := count + 1;
			if (count = divisor) then
				temp <= not temp;
				count := 0;
			end if;
		 end if; 
	end process P_div;
	clk_out <= temp;                                    

end divisor;
