library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vending_machine is
    Generic (
        CYCLES_5_SEC : integer := 500_000_000
    );
    Port (
        clk            : in  STD_LOGIC;
        rst            : in  STD_LOGIC;
        coins          : in  STD_LOGIC_VECTOR (3 downto 0);
        product        : in  STD_LOGIC_VECTOR (4 downto 0);
        change_request : in  STD_LOGIC;
        money_amount   : out integer;
        change         : out integer;
        error          : out STD_LOGIC_VECTOR (3 downto 0) 
    );
end vending_machine;

architecture Behavioral of vending_machine is

    type state_type is (IDLE, DISPATCH);
    signal current_state : state_type := IDLE;

    signal balance : integer := 0; 
    signal timer   : integer := 0;

    signal prev_coins          : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal prev_product        : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal prev_change_request : STD_LOGIC := '0';

begin
    money_amount <= balance;

    process(clk, rst)
        variable coin_value : integer := 0;
        variable prod_idx   : integer := 0;
        variable prod_price : integer := 0;
    begin
        if rst = '1' then
            current_state <= IDLE;
            balance <= 0;
            timer <= 0;
            change <= 0;
            error <= "0000";
            
        elsif rising_edge(clk) then
            -- Resetiramo defaultne izlaze na poèetku svakog takta
            error <= "0000";
            change <= 0;

            case current_state is
                when IDLE =>
                    -- elsif da sprijeèimo više stvari od jednom istovremeno
                    if coins /= prev_coins and coins /= "0000" then
                        if    coins = "0001" then coin_value := 1;
                        elsif coins = "0010" then coin_value := 2;
                        elsif coins = "0011" then coin_value := 5;
                        elsif coins = "0100" then coin_value := 10;
                        elsif coins = "0101" then coin_value := 20;
                        elsif coins = "0110" then coin_value := 50;
                        elsif coins = "0111" then coin_value := 100;
                        elsif coins = "1000" then coin_value := 200;
                        else  coin_value := -1; 
                        end if;

                        if coin_value = -1 then
                            error <= "0001"; -- Error: Nevažeæa kovanica
                        elsif (balance + coin_value) > 5000 then
                            error <= "0010"; -- Error: Prijelaz preko 50 EUR limita
                        else
                            balance <= balance + coin_value;
                        end if;

                    --Povrat kusura
                    elsif change_request = '1' and prev_change_request = '0' then
                        change <= balance; -- Izbaci novac
                        balance <= 0;      -- Instanto resetiraj balance na nulu kako traži PDF

                    --Obrada narudžbe
                    elsif product /= prev_product and product /= "00000" then
                        prod_idx := to_integer(unsigned(product));
                        
                        if prod_idx < 1 or prod_idx > 20 then
                            error <= "0011";
                        else
                            -- Raèunanje cijene gdje je prvih 5 1.25 EUR, a ostali +37 centi
                            if prod_idx <= 5 then
                                prod_price := 125; 
                            else
                                prod_price := 125 + ((prod_idx - 5) * 37); 
                            end if;

                            if balance >= prod_price then
                                balance <= balance - prod_price; 
                                -- Zbog FSMa jedan takt ide više radi prijelaza
                                timer <= CYCLES_5_SEC - 1;       
                                current_state <= DISPATCH;       
                            end if;
                        end if;
                    end if;

                when DISPATCH =>
                    if timer > 0 then
                        timer <= timer - 1;
                    else
                        current_state <= IDLE; 
                    end if;

                    --Ilegalne radnje u isporuci, ignoriramo i dižemo zastavice
                    if coins /= prev_coins and coins /= "0000" then
                        error <= "0100"; -- Ubacivanje kovanice tijekom isporuke
                    end if;
                    if product /= prev_product and product /= "00000" then
                        error <= "0101"; --Traženje proizvoda tijekom isporuke
                    end if;
                    if change_request = '1' and prev_change_request = '0' then
                        error <= "0110"; --Traženje povrata tijekom isporuke
                    end if;

            end case;

            -- Spremanje trenutnog stanja za edge detection u iduæem ciklusu
            prev_coins <= coins;
            prev_product <= product;
            prev_change_request <= change_request;

        end if;
    end process;

end Behavioral;
