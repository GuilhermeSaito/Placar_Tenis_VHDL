LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;


ENTITY placar_vga IS
    PORT (
        coluna              : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        linha               : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        number0             : IN STD_LOGIC_VECTOR(3 DOWNTO 0); 
        number1             : IN STD_LOGIC_VECTOR(3 DOWNTO 0); 
        number2             : IN STD_LOGIC_VECTOR(3 DOWNTO 0); 
        number3             : IN STD_LOGIC_VECTOR(3 DOWNTO 0); 
        number4             : IN STD_LOGIC_VECTOR(3 DOWNTO 0); 
        number5             : IN STD_LOGIC_VECTOR(3 DOWNTO 0); 
        number6             : IN STD_LOGIC_VECTOR(3 DOWNTO 0); 
        number7             : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        marcou_ponto        : IN STD_LOGIC;
        a                   : OUT STD_LOGIC
    );
END placar_vga;

ARCHITECTURE behavior OF placar_vga IS

    TYPE digit_array IS ARRAY (0 TO 6, 0 TO 4) OF STD_LOGIC;
    TYPE number_map_type IS ARRAY (0 TO 9) OF digit_array;

    -- Matriz contendo os números de 0 a 9
        CONSTANT number_map : number_map_type := (
        -- Número 0
        ( ('0','1','1','1','0'),
        ('1','0','0','0','1'),
        ('1','0','0','0','1'),
        ('1','0','0','0','1'),
        ('1','0','0','0','1'),
        ('1','0','0','0','1'),
        ('0','1','1','1','0') ),

        -- Número 1
        ( ('0','0','1','0','0'),
        ('0','1','1','0','0'),
        ('1','0','1','0','0'),
        ('0','0','1','0','0'),
        ('0','0','1','0','0'),
        ('0','0','1','0','0'),
        ('1','1','1','1','1') ),

        -- Número 2
        ( ('0','1','1','1','0'),
        ('1','0','0','0','1'),
        ('0','0','0','0','1'),
        ('0','0','0','1','0'),
        ('0','0','1','0','0'),
        ('0','1','0','0','0'),
        ('1','1','1','1','1') ),

        -- Número 3
        ( ('1','1','1','1','0'),
        ('0','0','0','0','1'),
        ('0','0','0','0','1'),
        ('0','0','1','1','0'),
        ('0','0','0','0','1'),
        ('1','0','0','0','1'),
        ('0','1','1','1','0') ),

        -- Número 4
        ( ('0','0','0','1','0'),
        ('0','0','1','1','0'),
        ('0','1','0','1','0'),
        ('1','0','0','1','0'),
        ('1','1','1','1','1'),
        ('0','0','0','1','0'),
        ('0','0','0','1','0') ),

        -- Número 5
        ( ('1','1','1','1','1'),
        ('1','0','0','0','0'),
        ('1','0','0','0','0'),
        ('1','1','1','1','0'),
        ('0','0','0','0','1'),
        ('1','0','0','0','1'),
        ('0','1','1','1','0') ),

        -- Número 6
        ( ('0','1','1','1','0'),
        ('1','0','0','0','0'),
        ('1','0','0','0','0'),
        ('1','1','1','1','0'),
        ('1','0','0','0','1'),
        ('1','0','0','0','1'),
        ('0','1','1','1','0') ),

        -- Número 7
        ( ('1','1','1','1','1'),
        ('0','0','0','0','1'),
        ('0','0','0','1','0'),
        ('0','0','1','0','0'),
        ('0','1','0','0','0'),
        ('0','1','0','0','0'),
        ('0','1','0','0','0') ),

        -- Número 8
        ( ('0','1','1','1','0'),
        ('1','0','0','0','1'),
        ('1','0','0','0','1'),
        ('0','1','1','1','0'),
        ('1','0','0','0','1'),
        ('1','0','0','0','1'),
        ('0','1','1','1','0') ),

        -- Número 9
        ( ('0','1','1','1','0'),
        ('1','0','0','0','1'),
        ('1','0','0','0','1'),
        ('0','1','1','1','1'),
        ('0','0','0','0','1'),
        ('1','0','0','0','1'),
        ('0','1','1','1','0') )
    );

    TYPE char_array IS ARRAY (0 TO 6, 0 TO 4) OF STD_LOGIC;
    TYPE letter_map_type IS ARRAY (CHARACTER RANGE 'A' TO 'Z') OF char_array;

    CONSTANT letter_map : letter_map_type := (
        'A' => (('0','1','1','1','0'),
                ('1','0','0','0','1'),
                ('1','1','1','1','1'),
                ('1','0','0','0','1'),
                ('1','0','0','0','1'),
                ('0','0','0','0','0'),
                ('0','0','0','0','0')),
        'B' => (others => (others => '0')),
        'C' => (('0','1','1','1','1'),
                ('1','0','0','0','0'),
                ('1','0','0','0','0'),
                ('1','0','0','0','0'),
                ('0','1','1','1','1'),
                ('0','0','0','0','0'),
                ('0','0','0','0','0')),
        'D' => (('1','1','1','0','0'),
                ('1','0','0','1','0'),
                ('1','0','0','0','1'),
                ('1','0','0','0','1'),
                ('1','0','0','1','0'),
                ('1','1','1','0','0'),
                ('0','0','0','0','0')),
        'E' => (('1','1','1','1','1'),
                ('1','0','0','0','0'),
                ('1','1','1','1','0'),
                ('1','0','0','0','0'),
                ('1','1','1','1','1'),
                ('0','0','0','0','0'),
                ('0','0','0','0','0')),
        'F' => (others => (others => '0')),
        'G' => (('0','1','1','1','0'),
                ('1','0','0','0','0'),
                ('1','0','0','0','0'),
                ('1','0','1','1','0'),
                ('1','0','0','0','1'),
                ('0','1','1','1','0'),
                ('0','0','0','0','0')),
        'H' => (('1','0','0','0','1'),
                ('1','0','0','0','1'),
                ('1','1','1','1','1'),
                ('1','0','0','0','1'),
                ('1','0','0','0','1'),
                ('0','0','0','0','0'),
                ('0','0','0','0','0')),
        'I' => (('0','1','1','1','0'),
                ('0','0','1','0','0'),
                ('0','0','1','0','0'),
                ('0','0','1','0','0'),
                ('0','0','1','0','0'),
                ('0','1','1','1','0'),
                ('0','0','0','0','0')),
        'J' => (others => (others => '0')),
        'K' => (others => (others => '0')),
        'L' => (others => (others => '0')),
        'M' => (('1','0','0','0','1'),
                ('1','1','0','1','1'),
                ('1','0','1','0','1'),
                ('1','0','0','0','1'),
                ('1','0','0','0','1'),
                ('0','0','0','0','0'),
                ('0','0','0','0','0')),
        'N' => (('1','0','0','0','1'),
                ('1','1','0','0','1'),
                ('1','0','1','0','1'),
                ('1','0','0','1','1'),
                ('1','0','0','0','1'),
                ('0','0','0','0','0'),
                ('0','0','0','0','0')),
        'O' => (('0','1','1','1','0'),
                ('1','0','0','0','1'),
                ('1','0','0','0','1'),
                ('1','0','0','0','1'),
                ('0','1','1','1','0'),
                ('0','0','0','0','0'),
                ('0','0','0','0','0')),
        'P' => (('1','1','1','1','0'),
                ('1','0','0','0','1'),
                ('1','0','0','0','1'),
                ('1','1','1','1','0'),
                ('1','0','0','0','0'),
                ('1','0','0','0','0'),
                ('1','0','0','0','0')),
        'R' => (('1','1','1','1','0'),
                ('1','0','0','0','1'),
                ('1','1','1','1','0'),
                ('1','0','1','0','0'),
                ('1','0','0','1','0'),
                ('0','0','0','0','0'),
                ('0','0','0','0','0')),

        'S' => (('0','1','1','1','0'),
                ('1','0','0','0','0'),
                ('0','1','1','1','0'),
                ('0','0','0','0','1'),
                ('1','1','1','1','0'),
                ('0','0','0','0','0'),
                ('0','0','0','0','0')),

        'T' => (('1','1','1','1','1'),
                ('0','0','1','0','0'),
                ('0','0','1','0','0'),
                ('0','0','1','0','0'),
                ('0','0','1','0','0'),
                ('0','0','0','0','0'),
                ('0','0','0','0','0')),

        'U' => (('1','0','0','0','1'),
                ('1','0','0','0','1'),
                ('1','0','0','0','1'),
                ('1','0','0','0','1'),
                ('0','1','1','1','0'),
                ('0','0','0','0','0'),
                ('0','0','0','0','0')),
        others => (others => (others => '0'))
    );



    FUNCTION draw_number (
        x, y : INTEGER;
        num : STD_LOGIC_VECTOR(3 DOWNTO 0);
        pos_x, pos_y : INTEGER
    ) RETURN STD_LOGIC IS
        VARIABLE digit : INTEGER;
        VARIABLE local_x, local_y : INTEGER;
    BEGIN
        digit := TO_INTEGER(UNSIGNED(num(3 DOWNTO 0)));
        local_x := x - pos_x;
        local_y := y - pos_y;

        IF ((digit >= 0 AND digit <= 9) AND  (local_x >= 0 AND local_x < 5 AND local_y >= 0 AND local_y < 7)) THEN
            RETURN number_map(digit)(local_y, local_x);
        ELSE
            RETURN '0';
        END IF;
    END FUNCTION;


    FUNCTION draw_char (
        x, y : INTEGER;
        char : CHARACTER;
        pos_x, pos_y : INTEGER
    ) RETURN STD_LOGIC IS
        VARIABLE local_x, local_y : INTEGER;
        VARIABLE char_index : CHARACTER;
    BEGIN
        local_x := x - pos_x;
        local_y := y - pos_y;
        
        IF (char >= 'A' AND char <= 'Z') AND (local_x >= 0 AND local_x < 5 AND local_y >= 0 AND local_y < 7) THEN
            char_index := char;
            RETURN letter_map(char_index)(local_y, local_x);
        ELSE
            RETURN '0';
        END IF;
    END FUNCTION;


    SIGNAL pixel_active : STD_LOGIC;
    SIGNAL player_char : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL all_zeros : STD_LOGIC := '0';
    SIGNAL temp_pixel_active : STD_LOGIC;
    SIGNAL temp_pixel_message_active : STD_LOGIC;
    SIGNAL temp_win_message_active : STD_LOGIC;
    SIGNAL mostrar_ganhador : STD_LOGIC;
    SIGNAL ganhador : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN

    PROCESS (coluna, linha, marcou_ponto, number0, number1, number2, number3, number4, number5, number6, number7)
    BEGIN
        IF marcou_ponto = '1' THEN
            player_char <= "0001";
        ELSE
            player_char <= "0010";
        END IF;
        
        -- Verifica se todas as variáveis "number" são iguais a "0000"
        IF number0 = "0000" AND number1 = "0000" AND number2 = "0000" AND number3 = "0000" AND 
            number4 = "0000" AND number5 = "0000" AND number6 = "0000" AND number7 = "0000" THEN
            all_zeros <= '0';
        ELSE
            all_zeros <= '1';
        END IF;

        IF number6 = "0011" OR number7 = "0011" THEN
            mostrar_ganhador <= '1';
            IF number6 = "0011" THEN
                ganhador <= "0001";
            ELSE
                ganhador <= "0010";
            END IF;
        ELSE
            mostrar_ganhador <= '0';
        END IF;
        
        temp_pixel_active <= 
            -- Placar
            draw_number(CONV_INTEGER(coluna), CONV_INTEGER(linha), number6, 370, 50) OR
            draw_number(CONV_INTEGER(coluna), CONV_INTEGER(linha), number7, 370, 100) OR
            draw_number(CONV_INTEGER(coluna), CONV_INTEGER(linha), number4, 470, 50) OR
            draw_number(CONV_INTEGER(coluna), CONV_INTEGER(linha), number5, 470, 100) OR
            draw_number(CONV_INTEGER(coluna), CONV_INTEGER(linha), number1, 570, 50) OR
            draw_number(CONV_INTEGER(coluna), CONV_INTEGER(linha), number0, 580, 50) OR
            draw_number(CONV_INTEGER(coluna), CONV_INTEGER(linha), number3, 570, 100) OR
            draw_number(CONV_INTEGER(coluna), CONV_INTEGER(linha), number2, 580, 100);
        
        -- Exibir mensagem "Pessoa X marcou 1 ponto" somente se all_zeros = '1'
        IF all_zeros = '1' THEN
            temp_pixel_message_active <= 
                draw_char(CONV_INTEGER(coluna), CONV_INTEGER(linha), 'P', 400, 200) OR
                draw_char(CONV_INTEGER(coluna), CONV_INTEGER(linha), 'E', 410, 200) OR
                draw_char(CONV_INTEGER(coluna), CONV_INTEGER(linha), 'S', 420, 200) OR
                draw_char(CONV_INTEGER(coluna), CONV_INTEGER(linha), 'S', 430, 200) OR
                draw_char(CONV_INTEGER(coluna), CONV_INTEGER(linha), 'O', 440, 200) OR
                draw_char(CONV_INTEGER(coluna), CONV_INTEGER(linha), 'A', 450, 200) OR
                draw_number(CONV_INTEGER(coluna), CONV_INTEGER(linha), player_char, 470, 200) OR
                draw_char(CONV_INTEGER(coluna), CONV_INTEGER(linha), 'M', 490, 200) OR
                draw_char(CONV_INTEGER(coluna), CONV_INTEGER(linha), 'A', 500, 200) OR
                draw_char(CONV_INTEGER(coluna), CONV_INTEGER(linha), 'R', 510, 200) OR
                draw_char(CONV_INTEGER(coluna), CONV_INTEGER(linha), 'C', 520, 200) OR
                draw_char(CONV_INTEGER(coluna), CONV_INTEGER(linha), 'O', 530, 200) OR
                draw_char(CONV_INTEGER(coluna), CONV_INTEGER(linha), 'U', 540, 200) OR
                draw_number(CONV_INTEGER(coluna), CONV_INTEGER(linha), "0001", 560, 200) OR
                draw_char(CONV_INTEGER(coluna), CONV_INTEGER(linha), 'P', 580, 200) OR
                draw_char(CONV_INTEGER(coluna), CONV_INTEGER(linha), 'O', 590, 200) OR
                draw_char(CONV_INTEGER(coluna), CONV_INTEGER(linha), 'N', 600, 200) OR
                draw_char(CONV_INTEGER(coluna), CONV_INTEGER(linha), 'T', 610, 200) OR
                draw_char(CONV_INTEGER(coluna), CONV_INTEGER(linha), 'O', 620, 200);
        END IF;

        IF mostrar_ganhador = '1' THEN
            temp_win_message_active <=
                draw_char(CONV_INTEGER(coluna), CONV_INTEGER(linha), 'P', 400, 220) OR
                draw_char(CONV_INTEGER(coluna), CONV_INTEGER(linha), 'E', 410, 220) OR
                draw_char(CONV_INTEGER(coluna), CONV_INTEGER(linha), 'S', 420, 220) OR
                draw_char(CONV_INTEGER(coluna), CONV_INTEGER(linha), 'S', 430, 220) OR
                draw_char(CONV_INTEGER(coluna), CONV_INTEGER(linha), 'O', 440, 220) OR
                draw_char(CONV_INTEGER(coluna), CONV_INTEGER(linha), 'A', 450, 220) OR
                draw_number(CONV_INTEGER(coluna), CONV_INTEGER(linha), ganhador, 470, 220) OR
                draw_char(CONV_INTEGER(coluna), CONV_INTEGER(linha), 'G', 490, 220) OR
                draw_char(CONV_INTEGER(coluna), CONV_INTEGER(linha), 'A', 500, 220) OR
                draw_char(CONV_INTEGER(coluna), CONV_INTEGER(linha), 'N', 510, 220) OR
                draw_char(CONV_INTEGER(coluna), CONV_INTEGER(linha), 'H', 520, 220) OR
                draw_char(CONV_INTEGER(coluna), CONV_INTEGER(linha), 'O', 530, 220);
        END IF;

        pixel_active <= temp_pixel_active OR temp_pixel_message_active OR temp_win_message_active;
    END PROCESS;


    a <= pixel_active;

END behavior;
