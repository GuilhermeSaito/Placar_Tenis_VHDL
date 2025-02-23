library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity text_display is
    Port (
        clk       : in  STD_LOGIC;
        pixel_x   : in  INTEGER;
        pixel_y   : in  INTEGER;
        video_on  : in  STD_LOGIC;
        char_out  : out STD_LOGIC
    );
end text_display;

architecture Behavioral of text_display is
    signal char_code : STD_LOGIC_VECTOR(7 downto 0);
    signal row, col  : INTEGER range 0 to 7;
    signal pixel     : STD_LOGIC;
begin
    -- Processo para determinar o código do caractere
    process (pixel_x, pixel_y)
    begin
        if video_on = '1' then
            row <= pixel_y mod 8;
            col <= pixel_x mod 8;

            if pixel_x < 64 then
                char_code <= "00110000"; -- '0'
            elsif pixel_x < 128 then
                char_code <= "00110001"; -- '1'
            elsif pixel_x < 192 then
                char_code <= "00110010"; -- '2'
            elsif pixel_x < 256 then
                char_code <= "01100001"; -- 'a'
            elsif pixel_x < 320 then
                char_code <= "01100010"; -- 'b'
            elsif pixel_x < 384 then
                char_code <= "01000001"; -- 'A'
            elsif pixel_x < 448 then
                char_code <= "01000010"; -- 'B'
            else
                char_code <= "01111010"; -- 'z'
            end if;
        else
            char_code <= (others => '0');
        end if;
    end process;

    -- Instância da ROM de fonte (fora do processo)
    font_inst: entity work.font_rom
        port map (
            clk   => clk,
            char  => char_code,
            row   => row,
            col   => col,
            pixel => pixel
        );

    -- Saída do pixel correspondente ao caractere
    char_out <= pixel and video_on;

end Behavioral;
