library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity font_rom is
    Port (
        clk     : in  STD_LOGIC;
        char    : in  STD_LOGIC_VECTOR(7 downto 0);
        row     : in  INTEGER range 0 to 7;
        col     : in  INTEGER range 0 to 7;
        pixel   : out STD_LOGIC
    );
end font_rom;

architecture Behavioral of font_rom is
    -- Matriz 128x8 para armazenar os caracteres (ASCII 0x00 a 0x7F)
    type font_array is array (0 to 127, 0 to 7) of STD_LOGIC_VECTOR(7 downto 0);

    -- Constante de fonte armazenando caracteres ASCII básicos
    constant font : font_array := (
        -- Espaço ' ' (ASCII 0x20)
        16#20# => ( "00000000", "00000000", "00000000", "00000000", 
                    "00000000", "00000000", "00000000", "00000000" ),
        
        -- '!' (ASCII 0x21)
        16#21# => ( "00011000", "00011000", "00011000", "00011000", 
                    "00011000", "00000000", "00011000", "00000000" ),
        
        -- '"' (ASCII 0x22)
        16#22# => ( "00100100", "00100100", "00100100", "00000000", 
                    "00000000", "00000000", "00000000", "00000000" ),

        -- Outros caracteres não inicializados recebem 0s
        others => ( "00000000", "00000000", "00000000", "00000000",
                    "00000000", "00000000", "00000000", "00000000" )
    );

begin
    -- Leitura síncrona do pixel correspondente
    process (clk)
    begin
        if rising_edge(clk) then
            -- Corrigido: Acesso correto à matriz bidimensional
            pixel <= font(to_integer(unsigned(char)), row)(7 - col);
        end if;
    end process;
end Behavioral;
