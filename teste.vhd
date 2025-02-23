LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY teste IS
    PORT (
        coluna : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        linha  : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        a      : OUT STD_LOGIC
    );
END teste;

ARCHITECTURE behavior OF teste IS

    -- Tabela de caracteres para "Hello Another World" (21 caracteres)
    CONSTANT text : STRING := "HELLO ANOTHER WORLD ";
    
    -- Função que desenha caracteres 8x8 na tela
    FUNCTION draw_char (
        x, y     : INTEGER; -- Posição do pixel atual
        char     : CHARACTER; -- Letra a ser desenhada
        pos_x, pos_y : INTEGER -- Posição do caractere
    ) RETURN STD_LOGIC IS
    BEGIN
        -- Cada caractere ocupa um espaço de 8x8 pixels
        IF (x >= pos_x AND x < pos_x + 8 AND y >= pos_y AND y < pos_y + 8) THEN
            RETURN '1'; -- Ativa pixel
        ELSE
            RETURN '0'; -- Não desenha
        END IF;
    END FUNCTION;

    SIGNAL pixel_active : STD_LOGIC;

BEGIN
    PROCESS (coluna, linha)
        VARIABLE pixel_tmp : STD_LOGIC := '0';
    BEGIN
        pixel_tmp := '0'; -- Inicializa desativado
        
        -- Percorre a tela imprimindo "HELLO ANOTHER WORLD" repetidamente
        FOR row IN 0 TO 29 LOOP  -- Aproximadamente 30 linhas de texto (480/16)
            FOR col IN 0 TO 39 LOOP  -- Aproximadamente 40 colunas de texto (640/16)
                pixel_tmp := pixel_tmp OR 
                    draw_char(CONV_INTEGER(coluna), CONV_INTEGER(linha), 
                              text((col MOD text'length) + 1),  -- Pega a letra correspondente
                              col * 16, row * 16);  -- Posição na grade
            END LOOP;
        END LOOP;

        pixel_active <= pixel_tmp;
    END PROCESS;

    a <= pixel_active;

END behavior;
