--------------------------------------------------------------------------------
--
--   FileName:         debounce.vhd
--   Dependencies:     none
--   Design Software:  Quartus II 32-bit Version 11.1 Build 173 SJ Full Version
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 3/26/2012 Scott Larson
--     Initial Public Release
--
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY debounce_v1 IS
  GENERIC(
    counter_size  :  INTEGER := 1); -- generaliza capacidade do contador
  PORT(
    clk     : IN  STD_LOGIC;  --entrada relógio
    button  : IN  STD_LOGIC;  --input signal to be debounced
    result  : OUT STD_LOGIC);
END debounce_v1;

ARCHITECTURE logic OF debounce_v1 IS
  SIGNAL flipflops   : STD_LOGIC_VECTOR(1 DOWNTO 0); -- flip-flops FF0 e FF1
  SIGNAL counter_set : STD_LOGIC;                    -- condição xor para reset síncrono
  SIGNAL counter_out : STD_LOGIC_VECTOR(counter_size DOWNTO 0) := (OTHERS => '0');
BEGIN

  counter_set <= flipflops(0) xor flipflops(1);   -- reseta cnt se amostras diferem
  
  PROCESS(clk)
  BEGIN
    IF(clk'EVENT and clk = '1') THEN
      flipflops(0) <= button;
      flipflops(1) <= flipflops(0);
      If(counter_set = '1') THEN                  -- reseta contador se amostras diferem
        counter_out <= (OTHERS => '0');
	  ELSIF counter_out /= "11" THEN
        counter_out <= counter_out + 1;
      ELSE                                        -- contagem estabilizada foi atingida
        result <= flipflops(1);
      END IF;    
    END IF;
  END PROCESS;
END logic;
