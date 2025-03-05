library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_env is
 Port (btn: in std_logic_vector(4 downto 0);
       sw: in std_logic_vector(15 downto 0);
       clk: in std_logic;
       cat: out std_logic_vector(6 downto 0);
       an: out std_logic_vector(7 downto 0);
       led: out std_logic_vector(9 downto 0));
end test_env;

architecture Behavioral of test_env is

component IFetch
Port(Jump: in std_logic;
    PcSrc: in std_logic;
    JumpAddress: in std_logic_vector(31 downto 0);
    BranchAddress: in std_logic_vector(31 downto 0);
    Instruction: out std_logic_vector(31 downto 0);
    NextAddress: out std_logic_vector(31 downto 0);
    clk: in std_logic;
    en: in std_logic;
    rst: in std_logic);
end component;

component MPG
Port (enable : out STD_LOGIC;
      btn : in STD_LOGIC;
      clk : in STD_LOGIC);
end component;

component SSD
    Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR(31 downto 0);
           an : out STD_LOGIC_VECTOR(7 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0));
end component;

component MEM 
 Port ( MemWrite: in std_logic;
        ALUResIn: in std_logic_vector(31 downto 0);
        RD2: in std_logic_vector(31 downto 0);
        clk: in std_logic;
        en: in std_logic;
        MemData: out std_logic_vector(31 downto 0);
        ALUResOut: out std_logic_vector(31 downto 0));
end component;

component ID
  Port (RegWrite: in std_logic;
        clk: in std_logic;
        Instr: in std_logic_vector(25 downto 0);
        WA: in std_logic_vector(4 downto 0);
        EN: in std_logic;
        ExtOp: in std_logic;
        WD: in std_logic_vector(31 downto 0);
        RD1: out std_logic_vector(31 downto 0); 
        RD2: out std_logic_vector(31 downto 0);
        Ext_Imm: out std_logic_vector(31 downto 0);
        func: out std_logic_vector(5 downto 0);
        sa: out std_logic_vector(4 downto 0);
        RT: OUT STD_LOGIC_VECTOR(4 downto 0);
        RD: OUT STD_LOGIC_VECTOR(4 downto 0));
end component;

component UC       
    Port ( 
    Instr : in std_logic_vector(5 downto 0);
    RegDst : out std_logic;
    ExtOp : out std_logic;
    ALUSrc : out std_logic;
    Branch : out std_logic;
    Branch_gtz : out std_logic;
    Jump : out std_logic;
    ALUOp : out std_logic_vector(1 downto 0);
    MemWrite : out std_logic;
    MemtoReg : out std_logic;
    RegWrite : out std_logic);       
end component;

component EX
  Port (   RD1 : in STD_LOGIC_VECTOR (31 downto 0);
           ALUSrc : in STD_LOGIC;
           RD2 : in STD_LOGIC_VECTOR (31 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR (31 downto 0);
           sa : in STD_LOGIC_VECTOR (4 downto 0);
           func : in STD_LOGIC_VECTOR (5 downto 0);
           ALUOp : in STD_LOGIC_VECTOR (1 downto 0);
           Pc_4 : in STD_LOGIC_VECTOR (31 downto 0);
           rt: in std_logic_vector(4 downto 0);
           rd: in std_logic_vector(4 downto 0);
           RegDest: in std_logic;
           GTZ : out STD_LOGIC;
           Zero : out STD_LOGIC;
           ALURes : out STD_LOGIC_VECTOR (31 downto 0);
           BranchAddress : out STD_LOGIC_VECTOR (31 downto 0);
           rwa: out std_logic_vector(4 downto 0));
end component;

signal en: std_logic;
signal instr: std_logic_vector(31 downto 0) :=(others=>'0');
signal PC_4: std_logic_vector(31 downto 0):=(others=>'0');
signal iesireMUX: std_logic_vector(31 downto 0):=(others=>'0');

--semnale ID
signal RegDest: std_logic;
signal ExtOp: std_logic;

--semnale EX
signal RD1: std_logic_vector(31 downto 0) :=(others=>'0');
signal RD2: std_logic_vector(31 downto 0) :=(others=>'0');
signal Ext_Imm: std_logic_vector(31 downto 0) :=(others=>'0');
signal func: std_logic_vector(5 downto 0) :=(others=>'0');
signal sa: std_logic_vector(4 downto 0) :=(others=>'0');
signal Zero: std_logic;
signal BranchAddress: std_logic_vector(31 downto 0) :=(others=>'0');
signal ALURes: std_logic_vector(31 downto 0) :=(others=>'0');

--semnale MEM
signal ALUResOut: std_logic_vector(31 downto 0) :=(others=>'0');
signal MemData: std_logic_vector(31 downto 0) :=(others=>'0');

--semnale UC
signal ALUSrc: std_logic;
signal Branch: std_logic;
signal Jump: std_logic;
signal ALUOp: std_logic_vector(1 downto 0) :=(others=>'0');
signal MemWrite: std_logic;
signal MemtoReg: std_logic;
signal RegWrite: std_logic;
signal BR_gtz: std_logic;

--iesire mux mare
signal iesireMux2: std_logic_vector(31 downto 0) :=(others=>'0');

--semnal pt pcsrc
signal pcSrcIntrare: std_logic;
signal JumpAddress: std_logic_vector(31 downto 0) :=(others=>'0');
signal gtz: std_logic;

--semnale PipeLine IF ID
signal Instr_IF_ID: std_logic_vector(31 downto 0);
signal PC4_IF_ID: std_logic_vector(31 downto 0);

--semnale PipeLine ID EX
signal RD1_ID_EX: std_logic_vector(31 downto 0);
signal RD2_ID_EX: std_logic_vector(31 downto 0);
signal Ext_Imm_ID_EX: std_logic_vector(31 downto 0);
signal func_ID_EX: std_logic_vector(5 downto 0);
signal sa_ID_EX: std_logic_vector(4 downto 0);
signal rt_ID_EX: std_logic_vector(4 downto 0);
signal rd_ID_EX: std_logic_vector(4 downto 0);
signal PC4_ID_EX: std_logic_vector(31 downto 0);
signal RegDest_ID_EX: std_logic;
signal ALUSrc_ID_EX: std_logic;
signal Branch_ID_EX: std_logic;
signal ALUOp_ID_EX: std_logic_vector(1 downto 0);
signal MemWrite_ID_EX: std_logic;
signal MemToReg_ID_EX: std_logic;
signal RegWrtie_ID_EX: std_logic;

--semnale PipeLine EX MEM
signal Branch_EX_MEM: std_logic;
signal MemWrite_EX_MEM: std_logic;
signal MemToReg_EX_MEM: std_logic;
signal RegWrite_EX_MEM: std_logic;
signal Zero_EX_MEM: std_logic;
signal BrAddress_EX_MEM: std_logic_vector(31 downto 0); 
signal ALURes_EX_MEM: std_logic_vector(31 downto 0); 
signal WA_EX_MEM: std_logic_vector(4 downto 0); 
signal RD2_EX_MEM: std_logic_vector(31 downto 0); 

--semnale PipeLine MEM WB
signal MemToReg_MEM_WB: std_logic;
signal RegWrite_MEM_WB: std_logic;
signal ALURes_MEM_WB: std_logic_vector(31 downto 0);
signal MemData_MEM_WB: std_logic_vector(31 downto 0);
signal WA_MEM_WB: std_logic_vector(4 downto 0);

--rt rd
signal rt: std_logic_vector(4 downto 0);
signal rd: std_logic_vector(4 downto 0);
signal wa: std_logic_vector(4 downto 0);

--semnal ssd 
signal output:std_logic_vector(15 downto 0);

begin

pcSrcIntrare<=Branch_EX_MEM and Zero_EX_MEM;
JumpAddress<=PC4_IF_ID(31 downto 28) & (Instr_IF_ID(25 downto 0) & "00");

mpgComponent: MPG port map(en, btn(0),clk);
iFetchComponent: IFetch port map(Jump, pcSrcIntrare, JumpAddress, BrAddress_EX_MEM, instr, PC_4, clk, en, btn(1));
output<=iesireMUX2(15 downto 0);
ssdComponent: SSD port map(clk, iesireMUX2, an, cat);

IDComponent: ID port map(RegWrite_MEM_WB, clk, Instr_IF_ID(25 downto 0), WA_MEM_WB, en, ExtOp, iesireMUX, RD1, RD2, Ext_Imm, func, sa, rt, rd);
EXCopmponent: Ex port map(RD1_ID_EX, ALUSrc_ID_EX, RD2_ID_EX, Ext_Imm_ID_EX, sa_ID_EX, func_ID_EX, ALUOp_ID_EX, PC4_ID_EX, rt_ID_EX, rd_ID_EX, RegDest_ID_EX, gtz, Zero, ALURes, BranchAddress, wa);
MEMComponent: MEM port map(MemWrite_EX_MEM, ALURes_EX_MEM, RD2_EX_MEM, clk, en, MemData, ALUResOut);
UCComponent: UC port map(instr_IF_ID(31 downto 26), RegDest, ExtOp, ALUSrc, Branch, BR_gtz, Jump, ALUOp, MemWrite, MemtoReg, RegWrite);

--mux mare
process(instr, pc_4, RD1_ID_EX, RD2_ID_EX, Ext_Imm_ID_EX, ALURes, MemData, iesireMUX, sw(7 downto 5))
begin
case sw(7 downto 5) is
when "000" => iesireMUX2<=instr;
when "001" => iesireMUX2<=pc_4;
when "010" => iesireMUX2<=RD1_ID_EX;
when "011" => iesireMUX2<=RD2_ID_EX;
when "100" => iesireMUX2<=Ext_Imm_ID_EX;
when "101" => iesireMUX2<=ALURes;
when "110" => iesireMUX2<=MemData; 
when others=> iesireMUX2<=iesireMUX;
end case;
end process;

--mux mic
process(ALURes_MEM_WB, MemData_MEM_WB, MemToReg_MEM_WB)
begin
if  MemToReg_MEM_WB='0' then 
    iesireMUX<=ALURes_MEM_WB;
else iesireMUX<=MemData_MEM_WB;
end if;
end process;

led <=RegDest & ExtOp & ALUSrc & Branch & Jump & ALUOp & MemWrite & MemtoReg & RegWrite;

--proces reg IF ID
process(clk)
begin
    if rising_edge(clk) then
        if en='1' then 
            Instr_IF_ID <= instr;
            PC4_IF_ID<=PC_4;
        end if;
    end if;
end process;

--proces reg ID EX  
process(clk)
begin
    if rising_edge(clk) then
        if en='1' then 
            RD1_ID_EX<=rd1;
            RD2_ID_EX<=rd2;
            Ext_Imm_ID_EX<=Ext_Imm;
            func_ID_EX<=func;
            sa_ID_EX<=sa;
            rt_ID_EX<=rt;
            rd_ID_EX<=rd;
            PC4_ID_EX<=PC4_IF_ID;
            RegDest_ID_EX<=RegDest;
            ALUSrc_ID_EX<=ALUSRc;
            Branch_ID_EX<=Branch;
            ALUOp_ID_EX<=ALUOp;
            MemWrite_ID_EX<=MemWrite;
            MemToReg_ID_EX<=MemtoReg;
            RegWrtie_ID_EX<=RegWrite;
        end if;
    end if;
end process;

--process reg EX MEM
process(clk)
begin
    if rising_edge(clk) then
        if en='1' then 
        Branch_EX_MEM <= Branch_ID_EX;
        MemWrite_EX_MEM <= MemWrite_ID_EX;
        MemToReg_EX_MEM <= MemToReg_ID_EX;
        RegWrite_EX_MEM <= RegWrtie_ID_EX;
        Zero_EX_MEM <= zero;
        BrAddress_EX_MEM <= BranchAddress;
        ALURes_EX_MEM <= ALURes;
        WA_EX_MEM <= wa;
        RD2_EX_MEM <= RD2_ID_EX;
        end if;
    end if;
end process;

--process MEM WB
process(clk)
begin
    if rising_edge(clk) then
      if en='1' then 
         MemToReg_MEM_WB <= MemToReg_EX_MEM;
         RegWrite_MEM_WB <= RegWrite_EX_MEM;
         ALURES_MEM_WB <= ALUResOut;
         MemData_MEM_WB <=MemData;
         WA_MEM_WB <= WA_EX_MEM;
      end if;
    end if;
end process;

end Behavioral;