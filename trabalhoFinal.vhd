library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity trabalhoFinal is
    Port (
        MAX10_CLK1_50 : in  STD_LOGIC;  -- Clock principal da placa (50MHz)
        VGA_HS        : out STD_LOGIC;  -- Sinal de sincronização horizontal
        VGA_VS        : out STD_LOGIC;  -- Sinal de sincronização vertical
        VGA_R         : out STD_LOGIC_VECTOR(3 downto 0); -- Vermelho (4 bits)
        VGA_G         : out STD_LOGIC_VECTOR(3 downto 0); -- Verde (4 bits)
        VGA_B         : out STD_LOGIC_VECTOR(3 downto 0);  -- Azul (4 bits)
        btn_placar1                     : in  STD_LOGIC;
        btn_placar2                     : in  STD_LOGIC;
        switch_reset                    : in  STD_LOGIC;
        switch_reset_vga                : in  STD_LOGIC;
        display_seg_placar1_unidade     : out STD_LOGIC_VECTOR (6 downto 0);
        display_seg_placar1_dezena      : out STD_LOGIC_VECTOR (6 downto 0);
        display_seg_placar2_unidade     : out STD_LOGIC_VECTOR (6 downto 0);
        display_seg_placar2_dezena      : out STD_LOGIC_VECTOR (6 downto 0);
        display_seg_game1               : out STD_LOGIC_VECTOR (6 downto 0);
        display_seg_game2               : out STD_LOGIC_VECTOR (6 downto 0);
        led_debug                       : out STD_LOGIC
    );
end trabalhoFinal;

architecture Behavioral of trabalhoFinal is

    ---------------------------- Logica para o VGA ----------------------------
    COMPONENT vga_drvr
    GENERIC (Color_bits : INTEGER;
                H_back_porch : INTEGER;
                H_counter_size : INTEGER;
                H_display : INTEGER;
                H_front_porch : INTEGER;
                H_retrace : INTEGER;
                H_sync_polarity : STD_LOGIC;
                V_back_porch : INTEGER;
                V_counter_size : INTEGER;
                V_display : INTEGER;
                V_front_porch : INTEGER;
                V_retrace : INTEGER;
                V_sync_polarity : STD_LOGIC
                );
        PORT(i_vid_clk : IN STD_LOGIC;
            i_rstb : IN STD_LOGIC;
            i_blue_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            i_green_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            i_red_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            o_h_sync : OUT STD_LOGIC;
            o_v_sync : OUT STD_LOGIC;
            --o_vid_display : OUT STD_LOGIC;
            o_blue_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            o_green_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            o_pixel_x : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
            o_pixel_y : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
            o_red_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT pll_25mhz
        PORT(areset : IN STD_LOGIC;
            inclk0 : IN STD_LOGIC;
            c0 : OUT STD_LOGIC;
            locked : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT placar_vga
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
    END COMPONENT;

    --COMPONENT teste
    --    PORT (
    --        coluna              : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    --        linha               : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    --        a                   : OUT STD_LOGIC
    --    );
    --END COMPONENT;

    SIGNAL	a :  STD_LOGIC;
    SIGNAL	coluna :  STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL	linha :  STD_LOGIC_VECTOR(9 DOWNTO 0);
    SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
    SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC;
    SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC;
    SIGNAL	marcou_ponto       :  STD_LOGIC;

    ---------------------------- Logica para o placar ----------------------------

    signal number0               : std_logic_vector(3 downto 0);
    signal number1               : std_logic_vector(3 downto 0);
    signal number2               : std_logic_vector(3 downto 0);
    signal number3               : std_logic_vector(3 downto 0);
    signal number4               : std_logic_vector(3 downto 0);
    signal number5               : std_logic_vector(3 downto 0);
    signal number6               : std_logic_vector(3 downto 0);
    signal number7               : std_logic_vector(3 downto 0);
    signal teste                 : std_logic;

begin
    ---------------------------- Logica para o VGA ----------------------------
    b2v_inst : vga_drvr
    GENERIC MAP(Color_bits => 4,
                H_back_porch => 48,
                H_counter_size => 10,
                H_display => 640,
                H_front_porch => 16,
                H_retrace => 96,
                H_sync_polarity => '0',
                V_back_porch => 33,
                V_counter_size => 10,
                V_display => 480,
                V_front_porch => 10,
                V_retrace => 2,
                V_sync_polarity => '0'
                )
    PORT MAP(i_vid_clk => SYNTHESIZED_WIRE_0,
            i_rstb => switch_reset_vga,
            i_blue_in => SYNTHESIZED_WIRE_6,
            i_green_in => SYNTHESIZED_WIRE_6,
            i_red_in => SYNTHESIZED_WIRE_6,
            o_h_sync => VGA_HS,
            o_v_sync => VGA_VS,
            --o_vid_display => o_vid_display,
            o_blue_out => VGA_B,
            o_green_out => VGA_G,
            o_pixel_x => coluna,
            o_pixel_y => linha,
            o_red_out => VGA_R);


    b2v_inst1 : pll_25mhz
    PORT MAP(areset => '0',
             inclk0 => MAX10_CLK1_50,
             c0 => SYNTHESIZED_WIRE_0);


    b2v_inst2 : placar_vga
    PORT MAP(
        coluna          => coluna,
        linha           => linha,
        number0         => number0,
        number1         => number1,
        number2         => number2,
        number3         => number3,
        number4         => number4,
        number5         => number5,
        number6         => number6,
        number7         => number7,
        marcou_ponto    => marcou_ponto,
        a               => SYNTHESIZED_WIRE_5
    );

    --b10v_inst2 : teste
    --PORT MAP(
    --    coluna          => coluna,
    --    linha           => linha,
    --    a               => SYNTHESIZED_WIRE_4
    --);

    SYNTHESIZED_WIRE_6 <= (a & a & a & a);



    --a <= SYNTHESIZED_WIRE_4 OR SYNTHESIZED_WIRE_5;
    a <= SYNTHESIZED_WIRE_5;
    led_debug <= a;


    ---------------------------- Logica para o placar ----------------------------
    placar_logic: entity work.incremento_reset_placar
        port map (
            clk                                 => MAX10_CLK1_50,
            botao_placar1                       => btn_placar1,
            botao_placar2                       => btn_placar2,
            switch_reset                        => switch_reset,
            number0                             => number0,
            number1                             => number1,
            number2                             => number2,
            number3                             => number3,
            number4                             => number4,
            number5                             => number5,
            number6                             => number6,
            number7                             => number7,
            marcou_ponto                        => marcou_ponto,
            led                                 => teste
        );

    display_sete_seg: entity work.display_sete_seg
        port map (
            number0     => number0,
            number1     => number1,
            number2     => number2,
            number3     => number3,
            number4     => number4,
            number5     => number5,
            HEX0        => display_seg_placar1_unidade,
            HEX1        => display_seg_placar1_dezena,
            HEX2        => display_seg_placar2_unidade,
            HEX3        => display_seg_placar2_dezena,
            HEX4        => display_seg_game1,
            HEX5        => display_seg_game2
        );

end Behavioral;
