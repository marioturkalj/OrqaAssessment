library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vending_machine_tb is
end vending_machine_tb;

architecture Behavioral of vending_machine_tb is

    component vending_machine
        Generic ( CYCLES_5_SEC : integer );
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
    end component;

    -- Signali za testbench
    signal clk            : std_logic := '0';
    signal rst            : std_logic := '0';
    signal coins          : std_logic_vector(3 downto 0) := (others => '0');
    signal product        : std_logic_vector(4 downto 0) := (others => '0');
    signal change_request : std_logic := '0';
    
    signal money_amount   : integer;
    signal change         : integer;
    signal error          : std_logic_vector(3 downto 0);

    constant clk_period : time := 10 ns;

begin

    -- Instanciranje glavnog modula. 
    -- Generic map za skraæivanje 5 sekundi na 10 taktova
    uut: vending_machine 
    generic map (
        CYCLES_5_SEC => 10 
    )
    port map (
        clk => clk,
        rst => rst,
        coins => coins,
        product => product,
        change_request => change_request,
        money_amount => money_amount,
        change => change,
        error => error
    );

    -- Generiranje takta
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    stim_proc: process
    begin        
        -- Kreæe iz IDLE stanja
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 20 ns;
        
        -- Ubacujem 2 EUR - kod 1000
        coins <= "1000"; 
        wait for clk_period;
        coins <= "0000"; 
        wait for clk_period * 2;
        
        -- Proizvod br. 1. Oèekujem da æe oduzeti 1.25 EUR od balansa.
        product <= "00001";
        wait for clk_period;
        product <= "00000";

        -- Èim je proizvod odabran, FSM ulazi u DISPATCH
        -- Pokušaj ubacivanja kovanice, kupnja proizvoda i povrat novca
        wait for clk_period; 
        
        -- Error 0100
        coins <= "0011"; 
        wait for clk_period;
        coins <= "0000";
        wait for clk_period;

        -- Error 0101
        product <= "00010"; 
        wait for clk_period;
        product <= "00000";
        wait for clk_period;

        -- Error 0110
        change_request <= '1';
        wait for clk_period;
        change_request <= '0';
        
        -- Povratak u IDLE
        wait for clk_period * 6;

        -- Povrat novca prve kupnje
        change_request <= '1';
        wait for clk_period;
        change_request <= '0';
        wait for clk_period * 5;

        -- Testiranje za limit 50 eura ubacujemo 2 eura 26 puta, a zadnji prolaz kroz petlju je error 0010 za prijelaz limita
        for i in 1 to 26 loop
            coins <= "1000"; 
            wait for clk_period;
            coins <= "0000"; 
            wait for clk_period;
        end loop;
        wait;
    end process;

end Behavioral;