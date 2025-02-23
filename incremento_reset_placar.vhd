library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity incremento_reset_placar is
    Port (
        clk                                 : in  std_logic;
        botao_placar1                       : in  std_logic;
        botao_placar2                       : in  std_logic;
        switch_reset                        : in  std_logic;
        number0                             : out std_logic_vector(3 downto 0);
        number1                             : out std_logic_vector(3 downto 0);
        number2                             : out std_logic_vector(3 downto 0);
        number3                             : out std_logic_vector(3 downto 0);
        number4                             : out std_logic_vector(3 downto 0); -- Pontos do game do time 1
        number5                             : out std_logic_vector(3 downto 0); -- Pontos do game do time 2
        number6                             : out std_logic_vector(3 downto 0); -- Pontos do set do time 1
        number7                             : out std_logic_vector(3 downto 0); -- Pontos do set do time 2
        marcou_ponto                        : out std_logic;
        led                                 : out std_logic
    );
end incremento_reset_placar;

architecture Behavioral of incremento_reset_placar is
    
    signal saida_divider, btn_placar1_sem_repique, btn_placar2_sem_repique : std_logic;

    signal n0_rep : std_logic_vector(3 downto 0) := "0000"; -- 4 bits (0 a 15)
    signal n1_rep : std_logic_vector(3 downto 0) := "0000"; -- 4 bits (0 a 15)
    signal n4_rep : std_logic_vector(3 downto 0) := "0000";
    signal n5_rep : std_logic_vector(3 downto 0) := "0000";
    signal n6_rep : std_logic_vector(3 downto 0) := "0000";
    signal n7_rep : std_logic_vector(3 downto 0) := "0000";
    signal botao1_liberado  : std_logic := '1';
    signal botao2_liberado  : std_logic := '1';
    signal marcou_ponto_rep : std_logic;

    component divider is
    port(
        clk_in		: in  std_logic;	-- clock in.
        clk_out		: out std_logic		-- clock in dividido 2 x divisor
    );
    end component;

    component debounce_v1 is
    PORT(
        clk     : IN  STD_LOGIC;  --entrada relógio
        button  : IN  STD_LOGIC;  --input signal to be debounced
        result  : OUT STD_LOGIC
    );
    end component;

begin

    di : divider port map(clk_in => clk, clk_out => saida_divider);
    de : debounce_v1 port map(clk => saida_divider, button => botao_placar1, result => btn_placar1_sem_repique);
    de2 : debounce_v1 port map(clk => saida_divider, button => botao_placar2, result => btn_placar2_sem_repique);

    process (clk)
    begin
        if rising_edge(clk) then
            ------------ Logica para os botoes
            ------- Botao 1
            if btn_placar1_sem_repique = '0'  and botao1_liberado = '0' then
                led <= '1';
                n0_rep <= n0_rep + "0001";
                botao1_liberado <= '1';
                marcou_ponto_rep <= '1';
            elsif btn_placar1_sem_repique = '1' then
                led <= '0';
                botao1_liberado <= '0';
            end if;

            ------- Botao 2
            if btn_placar2_sem_repique = '0' and botao2_liberado = '0' then
                led <= '1';
                n1_rep <= n1_rep + "0001";
                botao2_liberado <= '1';
                marcou_ponto_rep <= '0';
            elsif btn_placar2_sem_repique = '1' then
                led <= '0';
                botao2_liberado <= '0';
            end if;

            ------------ Reset
            if switch_reset = '1' then
                n0_rep <= "0000";
                n1_rep <= "0000";
                n4_rep <= "0000";
                n5_rep <= "0000";
                n6_rep <= "0000";
                n7_rep <= "0000";
            end if;

            ------------ Regra para o sobe 2 dos pontos
            -- Subiu 2 e empato denovo
            if n0_rep = "0100" and n1_rep = "0100" then
                n0_rep <= "0011";
                n1_rep <= "0011";
            end if;

            ------------ Regra para quem ganha o game
            if (n0_rep = "0100" and n1_rep < "0011") or n0_rep = "0101" then
                n0_rep <= "0000";
                n1_rep <= "0000";
                n4_rep <= n4_rep + "0001";
            elsif (n0_rep < "0011" and n1_rep = "0100") or n1_rep = "0101" then
                n0_rep <= "0000";
                n1_rep <= "0000";
                n5_rep <= n5_rep + "0001";
            end if;

            ------------ Regra para o sobe 2 do game
            -- Subiu 2 e empato denovo
            if n4_rep = "0111" and n5_rep = "0111" then
                n4_rep <= "0110";
                n5_rep <= "0110";
            end if;

            ------------ Regra para quem ganha o set
            if (n4_rep = "0111" and n5_rep < "0110") or n4_rep = "1000" then
                n0_rep <= "0000";
                n1_rep <= "0000";
                n4_rep <= "0000";
                n5_rep <= "0000";
                n6_rep <= n6_rep + "0001";
            elsif (n4_rep < "0110" and n5_rep = "0111") or n5_rep = "1000" then
                n0_rep <= "0000";
                n1_rep <= "0000";
                n4_rep <= "0000";
                n5_rep <= "0000";
                n7_rep <= n7_rep + "0001";
            end if;

        end if;
    end process;

    number1 <= "0001" when n0_rep = "0001" else  -- 1 (binário: 0001)
           "0011" when n0_rep = "0010" else  -- 3 (binário: 0011)
           "0100" when n0_rep = "0011" else  -- 4 (binário: 0100)
           "0111" when n0_rep = "0100" else
           "0000";                           -- 0 (binário: 0000)

    number0 <= "0101" when n0_rep = "0001" else  -- 5 (binário: 0101)
            "0111" when n0_rep = "0100" else
            "0000";                           -- 0 (binário: 0000)

    number3 <= "0001" when n1_rep = "0001" else  -- 1 (binário: 0001)
            "0011" when n1_rep = "0010" else  -- 3 (binário: 0011)
            "0100" when n1_rep = "0011" else  -- 4 (binário: 0100)
            "0111" when n1_rep = "0100" else
            "0000";                           -- 0 (binário: 0000)

    number2 <= "0101" when n1_rep = "0001" else  -- 5 (binário: 0101)
            "0111" when n1_rep = "0100" else
            "0000";                           -- 0 (binário: 0000)

    number4 <= "0000" when n4_rep = "0000" else
            "0001" when n4_rep = "0001" else
            "0010" when n4_rep = "0010" else
            "0011" when n4_rep = "0011" else
            "0100" when n4_rep = "0100" else
            "0101" when n4_rep = "0101" else
            "0110" when n4_rep = "0110" else
            "0111" when n4_rep = "0111" else
            "0000";
				
    number5 <= "0000" when n5_rep = "0000" else
            "0001" when n5_rep = "0001" else
            "0010" when n5_rep = "0010" else
            "0011" when n5_rep = "0011" else
            "0100" when n5_rep = "0100" else
            "0101" when n5_rep = "0101" else
            "0110" when n5_rep = "0110" else
            "0111" when n5_rep = "0111" else
            "0000";

    number6 <= "0000" when n6_rep = "0000" else
            "0001" when n6_rep = "0001" else
            "0010" when n6_rep = "0010" else
            "0011" when n6_rep = "0011" else
            "0100" when n6_rep = "0100" else
            "0101" when n6_rep = "0101" else
            "0110" when n6_rep = "0110" else
            "0111" when n6_rep = "0111" else
            "0000";
				
    number7 <= "0000" when n7_rep = "0000" else
            "0001" when n7_rep = "0001" else
            "0010" when n7_rep = "0010" else
            "0011" when n7_rep = "0011" else
            "0100" when n7_rep = "0100" else
            "0101" when n7_rep = "0101" else
            "0110" when n7_rep = "0110" else
            "0111" when n7_rep = "0111" else
            "0000";

    marcou_ponto <= marcou_ponto_rep;

end Behavioral;