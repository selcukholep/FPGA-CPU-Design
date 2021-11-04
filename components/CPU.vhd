LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY CPU IS
    PORT( RESET : IN    STD_LOGIC;
          CLOCK : IN    STD_LOGIC;
          RAM   : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          RAM_R : OUT   STD_LOGIC;
          RAM_W : OUT   STD_LOGIC;
          IO    : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          ADR   : OUT   STD_LOGIC_VECTOR(15 DOWNTO 0));
END CPU;

ARCHITECTURE STRUCTURAL OF CPU IS

    COMPONENT CU IS
        PORT( RESET  : IN  STD_LOGIC;
              CLOCK  : IN  STD_LOGIC;
              IR     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
              FR     : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
              PC_R   : OUT STD_LOGIC;
              PC_U   : OUT STD_LOGIC;
              PC_W   : OUT STD_LOGIC;
              MAR_W  : OUT STD_LOGIC;
              IR_W   : OUT STD_LOGIC;
              ALU_E  : OUT STD_LOGIC;
              ATR_W  : OUT STD_LOGIC;
              ACC_R  : OUT STD_LOGIC;
              FR_CLK : OUT STD_LOGIC;
              TR_W   : OUT STD_LOGIC;
              TR_R   : OUT STD_LOGIC;
              RX_R   : OUT STD_LOGIC_VECTOR(13 DOWNTO 0);
              RX_W   : OUT STD_LOGIC_VECTOR(13 DOWNTO 0);
              SP_R   : OUT STD_LOGIC;
              SP_U   : OUT STD_LOGIC;
              SP_D   : OUT STD_LOGIC;
              RAM_R  : OUT STD_LOGIC;
              RAM_W  : OUT STD_LOGIC;
              RIO_R  : OUT STD_LOGIC;
              RIO_W  : OUT STD_LOGIC;
              FR_R   : OUT STD_LOGIC;
              FR_W   : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT GPREG_FILE IS
        PORT( RX_W : IN    STD_LOGIC_VECTOR(13 DOWNTO 0);
              RX_R : IN    STD_LOGIC_VECTOR(13 DOWNTO 0);
              CLK  : IN    STD_LOGIC;
              RST  : IN    STD_LOGIC;
              DATA : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0));
    END COMPONENT;
    
    COMPONENT FR IS
        PORT( RST : IN  STD_LOGIC;
              CLK : IN  STD_LOGIC;
              DI  : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
              DO  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
    END COMPONENT;
    
    COMPONENT W_REG IS
        PORT( RST : IN  STD_LOGIC;
              CLK : IN  STD_LOGIC;
              DI  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
              DO  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
              WE  : IN  STD_LOGIC);
    END COMPONENT;
    
    COMPONENT R_REG IS
        PORT( RST : IN  STD_LOGIC;
              CLK : IN  STD_LOGIC;
              DI  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
              DO  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
              RE  : IN  STD_LOGIC);
    END COMPONENT;
    
    COMPONENT RW_REGISTER IS
        PORT( RST  : IN    STD_LOGIC;
              CLK  : IN    STD_LOGIC;
              DATA : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
              RE   : IN    STD_LOGIC;
              WE   : IN    STD_LOGIC);
    END COMPONENT;

    COMPONENT IR IS
        PORT( RST : IN  STD_LOGIC;
              CLK : IN  STD_LOGIC;
              DI  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
              DO  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
              WE  : IN  STD_LOGIC);
    END COMPONENT;
    
    COMPONENT PC IS
        GENERIC( ADR_HI : STD_LOGIC_VECTOR(15 DOWNTO 0) := X"FEFF";
                 ADR_LO : STD_LOGIC_VECTOR(15 DOWNTO 0) := X"0000");
         PORT( RST  : IN    STD_LOGIC;
               CLK  : IN    STD_LOGIC;
               WE   : IN    STD_LOGIC;
               RE   : IN    STD_LOGIC;
               UP   : IN    STD_LOGIC;
               DATA : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0));
    END COMPONENT;
    
    COMPONENT SP IS
         GENERIC( ADR_HI : STD_LOGIC_VECTOR(15 DOWNTO 0) := X"FFFF";
                  ADR_LO : STD_LOGIC_VECTOR(15 DOWNTO 0) := X"FF00");
        PORT( RST  : IN  STD_LOGIC;
              CLK  : IN  STD_LOGIC;
              DO   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
              RE   : IN  STD_LOGIC;
              UP   : IN  STD_LOGIC;
              DOWN : IN  STD_LOGIC);
    END COMPONENT;

    COMPONENT ALU IS
        GENERIC( DATA_WIDTH      : INTEGER := 15 ;  -- DEFINING THE DATA WIDTH
                 FLAG_DATA_WIDTH : INTEGER := 3 );  -- DEFINING THE DATA WIDTH
        PORT( OPCODE_IN  : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
              ALU_ENABLE : IN  STD_LOGIC;
              AIN        : IN  STD_LOGIC_VECTOR(DATA_WIDTH DOWNTO 0);
              BIN        : IN  STD_LOGIC_VECTOR(DATA_WIDTH DOWNTO 0);
              OUTP       : OUT STD_LOGIC_VECTOR(DATA_WIDTH DOWNTO 0);
              FLAG_IN    : IN  STD_LOGIC_VECTOR(FLAG_DATA_WIDTH DOWNTO 0);
              FLAG_OUT   : OUT STD_LOGIC_VECTOR(FLAG_DATA_WIDTH DOWNTO 0)); -- 3-V, 2-C, 1-Z, 0-S
    END COMPONENT;
    
    COMPONENT BUFF IS
        PORT( PORT1 : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0); -- CPU_OUT
              PORT2 : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0); -- CPU_IN
              RE    : IN    STD_LOGIC;
              WE    : IN    STD_LOGIC);
    END COMPONENT;
    
    COMPONENT FLAG_BUFFER IS
        GENERIC( FLAG_WIDTH : INTEGER := 4 );
        PORT( PORT1 : INOUT STD_LOGIC_VECTOR(FLAG_WIDTH - 1 DOWNTO 0);
              PORT2 : INOUT STD_LOGIC_VECTOR(FLAG_WIDTH - 1 DOWNTO 0);
              RE    : IN    STD_LOGIC;
              WE    : IN    STD_LOGIC);
    END COMPONENT;

    SIGNAL  PC_OUT, IR_OUT, D_BUS, ATR_OUT, ACC_IN, FR_FOR_BUS   : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL  RX_R, RX_W                                           : STD_LOGIC_VECTOR (13 DOWNTO 0);
    SIGNAL  OP                                                   : STD_LOGIC_VECTOR (4 DOWNTO 0);
    SIGNAL  RD, RS, CU_FR, FR_IN, ALU_FR                         : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL  NOT_CLOCK                                            : STD_LOGIC;
    SIGNAL  PC_U, PC_R, PC_W, MAR_W, IR_W,
            ALU_E, ATR_W, ACC_R, FR_CLK, FR_R, FR_W, TR_W, TR_R,
            SP_R, SP_U, SP_D, RIO_R, RIO_W, CU_RAM_R, CU_RAM_W   : STD_LOGIC;

BEGIN

    NOT_CLOCK <= NOT CLOCK;
    
    MAR_0 : W_REG       PORT MAP(RESET, NOT_CLOCK, D_BUS, ADR, MAR_W);
    TR_0  : RW_REGISTER PORT MAP(RESET, NOT_CLOCK, D_BUS, TR_R, TR_W);
    PC_0  : PC          PORT MAP(RESET, NOT_CLOCK, PC_W, PC_R, PC_U, D_BUS);
    SP_0  : SP          PORT MAP(RESET, NOT_CLOCK, D_BUS, SP_R, SP_U, SP_D);
    IR_0  : IR          PORT MAP(RESET, NOT_CLOCK, RAM, IR_OUT, IR_W);
    FR_0  : FR          PORT MAP(RESET, FR_CLK, FR_IN, CU_FR);
    CU_0  : CU          PORT MAP(RESET, CLOCK, IR_OUT, CU_FR, PC_R, PC_U, PC_W, MAR_W, IR_W, ALU_E, ATR_W, ACC_R, FR_CLK, TR_W, TR_R, RX_R, RX_W, SP_R, SP_U, SP_D, CU_RAM_R, CU_RAM_W, RIO_R, RIO_W, FR_R, FR_W);
    GPREG : GPREG_FILE  PORT MAP(RX_W, RX_R, NOT_CLOCK, RESET, D_BUS);
    ATR_0 : W_REG       PORT MAP(RESET, NOT_CLOCK, D_BUS, ATR_OUT, ATR_W);
    ALU_0 : ALU         PORT MAP(IR_OUT(14 DOWNTO 11), ALU_E, D_BUS, ATR_OUT, ACC_IN, CU_FR, ALU_FR);
    ACC_0 : R_REG       PORT MAP(RESET, NOT_CLOCK, ACC_IN, D_BUS, ACC_R);
    
    RAM_R <= CU_RAM_R;
    RAM_W <= CU_RAM_W;
    FR_FOR_BUS <= X"000" & CU_FR;
    
    B        :  BUFF        PORT MAP(RAM, D_BUS, CU_RAM_R, CU_RAM_W);
    FR_OUT_B :  BUFF         PORT MAP(D_BUS, FR_FOR_BUS, '0', FR_R);
    FR_IN_B0 :  FLAG_BUFFER  PORT MAP(FR_IN, D_BUS(3 DOWNTO 0), '0', FR_W);
    FR_IN_B1 :  FLAG_BUFFER  PORT MAP(FR_IN, ALU_FR, '0', ALU_E);

END STRUCTURAL;