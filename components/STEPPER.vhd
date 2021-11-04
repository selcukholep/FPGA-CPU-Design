LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY STEPPER IS
    PORT( CLOCK : IN  STD_LOGIC;
          RESET : IN  STD_LOGIC := '0';
          X     : IN  STD_LOGIC := '0';
          Y     : IN  STD_LOGIC := '0';
          Z     : IN  STD_LOGIC := '0';
          W     : IN  STD_LOGIC := '0';
          Q     : IN  STD_LOGIC := '0';
          S     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END STEPPER;

ARCHITECTURE BEHAVIOR OF STEPPER IS

    TYPE TYPE_FSTATE IS (STEP0,STEP1,STEP2,STEP3,STEP4,STEP5,STEP6,STEP7);
    SIGNAL FSTATE     : TYPE_FSTATE;
    SIGNAL REG_FSTATE : TYPE_FSTATE;

BEGIN

    PROCESS (CLOCK,REG_FSTATE)
    BEGIN
        IF (CLOCK='1' AND CLOCK'EVENT) THEN
            FSTATE <= REG_FSTATE;
        END IF;
    END PROCESS;

    PROCESS (FSTATE,RESET,X,Y,Z,W,Q)
    BEGIN
        IF (RESET='1') THEN
            REG_FSTATE <= STEP0;
            S <= (OTHERS => '0');
        ELSE
            S <= (OTHERS => '0');
                
            CASE FSTATE IS
                WHEN STEP0 =>
                    REG_FSTATE <= STEP1;

                    S(0) <= '1';
                WHEN STEP1 =>
                    IF ((X = '1')) THEN
                        REG_FSTATE <= STEP2;
                    ELSIF ((X = '0')) THEN
                        REG_FSTATE <= STEP5;
                    -- INSERTING 'ELSE' BLOCK TO PREVENT LATCH INFERENCE
                    ELSE
                        REG_FSTATE <= STEP1;
                    END IF;

                    S(1) <= '1';
                WHEN STEP2 =>
                    IF ((Q = '1')) THEN
                        REG_FSTATE <= STEP4;
                    ELSE
                        REG_FSTATE <= STEP3;
                    END IF;

                    S(2) <= '1';
                WHEN STEP3 =>
                    IF ((Y = '1')) THEN
                        REG_FSTATE <= STEP4;
                    ELSIF ((Y = '0')) THEN
                        REG_FSTATE <= STEP5;
                    -- INSERTING 'ELSE' BLOCK TO PREVENT LATCH INFERENCE
                    ELSE
                        REG_FSTATE <= STEP3;
                    END IF;

                    S(3) <= '1';
                WHEN STEP4 =>
                    REG_FSTATE <= STEP5;

                    S(4) <= '1';
                WHEN STEP5 =>
                    IF ((Z = '1')) THEN
                        REG_FSTATE <= STEP6;
                    ELSIF ((Z = '0')) THEN
                        REG_FSTATE <= STEP0;
                    -- INSERTING 'ELSE' BLOCK TO PREVENT LATCH INFERENCE
                    ELSE
                        REG_FSTATE <= STEP5;
                    END IF;

                    S(5) <= '1';
                WHEN STEP6 =>
                    IF ((W = '0')) THEN
                        REG_FSTATE <= STEP7;
                    ELSIF ((W = '1')) THEN
                        REG_FSTATE <= STEP0;
                    -- INSERTING 'ELSE' BLOCK TO PREVENT LATCH INFERENCE
                    ELSE
                        REG_FSTATE <= STEP6;
                    END IF;

                    S(6) <= '1';
                WHEN STEP7 =>
                    REG_FSTATE <= STEP0;

                    S(7) <= '1';
                WHEN OTHERS => 
                    S <= (OTHERS => '0');
                    REPORT "REACH UNDEFINED STATE";
            END CASE;
        END IF;
    END PROCESS;
    
END BEHAVIOR;
