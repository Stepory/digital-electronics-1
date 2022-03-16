# Lab 5: YOUR_FIRSTNAME LASTNAME

### Flip-flops

1. Listing of VHDL architecture for T-type flip-flop. Always use syntax highlighting, meaningful comments, and follow VHDL guidelines:

```vhdl
architecture Behavioral of t_ff_rst is
    -- It must use this local signal instead of output ports
    -- because "out" ports cannot be read within the architecture
    signal s_q : std_logic;
begin
    --------------------------------------------------------
    -- p_t_ff_rst:
    -- T type flip-flop with a high-active synchro reset,
    -- rising-edge clk.
    -- q(n+1) = t./q(n) + /t.q(n)
    -- q(n+1) =  q(n) if t = 0 (no change)
    -- q(n+1) = /q(n) if t = 1 (inversion)
    --------------------------------------------------------
    p_t_ff_rst : process(clk)
    begin
        if rising_edge(clk) then

        -- WRITE YOUR CODE HERE
           if (rst = '1')then
                s_q    <= '0';
                q     <= '0';
                q_bar <= '1';
            -- USE HIGH-ACTIVE RESET HERE
           else
                s_q   <= (t and not(s_q)) or (not(t) and s_q); 
                 
                --q     <= s_q; -- longer latency
                --q_bar <= not s_q;
                
                q   <= (t and not(s_q)) or (not(t) and s_q);  -- lower latency
                q_bar <= not((t and not(s_q)) or (not(t) and s_q));
            end if;
        end if;
    end process p_t_ff_rst;

    -- Output ports are permanently connected to local signal

end architecture Behavioral;
```

2. Screenshot with simulated time waveforms. Try to simulate both flip-flops in a single testbench with a maximum duration of 200 ns, including reset. Always display all inputs and outputs (display the inputs at the top of the image, the outputs below them) at the appropriate time scale!

   ![your figure]()

### Shift register

1. Image of the shift register `top` level schematic. The image can be drawn on a computer or by hand. Always name all inputs, outputs, components and internal signals!

   ![your figure]()