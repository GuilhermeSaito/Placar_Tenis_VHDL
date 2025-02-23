library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display_sete_seg is
    Port ( 
        number0     : in std_logic_vector(3 downto 0);
        number1     : in std_logic_vector(3 downto 0);
        number2     : in std_logic_vector(3 downto 0);
        number3     : in std_logic_vector(3 downto 0);
        number4     : in std_logic_vector(3 downto 0);
        number5     : in std_logic_vector(3 downto 0);
        HEX0        : out STD_LOGIC_VECTOR (6 downto 0);
        HEX1        : out STD_LOGIC_VECTOR (6 downto 0);
        HEX2        : out STD_LOGIC_VECTOR (6 downto 0);
        HEX3        : out STD_LOGIC_VECTOR (6 downto 0);
        HEX4        : out STD_LOGIC_VECTOR (6 downto 0);
        HEX5        : out STD_LOGIC_VECTOR (6 downto 0)
    );
end display_sete_seg;

architecture Behavioral of display_sete_seg is

    function to_7seg(num: std_logic_vector(3 downto 0)) return STD_LOGIC_VECTOR is
    begin
        case num is
            when "0000" => return "1000000"; -- 0
            when "0001" => return "1111001"; -- 1
            when "0010" => return "0100100"; -- 2
            when "0011" => return "0110000"; -- 3
            when "0100" => return "0011001"; -- 4
            when "0101" => return "0010010"; -- 5
            when "0110" => return "0000010"; -- 6
            when "0111" => return "1111000"; -- 7
            when "1000" => return "0000000"; -- 8
            when "1001" => return "0010000"; -- 9
            when others => return "0011001"; -- Tudo apagado
        end case;
    end function;

begin

    HEX0 <= to_7seg(number0);
    HEX1 <= to_7seg(number1);
    HEX2 <= to_7seg(number2);
    HEX3 <= to_7seg(number3);
    HEX4 <= to_7seg(number4);
    HEX5 <= to_7seg(number5);

end Behavioral;
