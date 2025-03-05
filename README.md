# MIPS-PipeLine
Acest proiect implementează un procesor MIPS multi-ciclu, testat și validat pe placă în cadrul laboratorului. Procesorul suportă mai multe tipuri de instrucțiuni, atât de tip **Register (R)**, cât și **Immediate (I)**.

Procesorul este format din următoarele module principale:
- **Instruction Fetch (IF)** - Extragerea instrucțiunii
- **Instruction Decode (ID)** - Decodificarea instrucțiunii
- **Execution (EX)** - Execuția instrucțiunii
- **Memory (MEM)** - Accesarea memoriei
- **Control Unit (UC)** - Unitatea de control
- **Register File (RegFile)** - Registru de fișiere
- **Seven Segment Display (SSD)** - Afișare rezultate
- **Monoimpuls Generator (MPG)** - Sincronizare

**Toate componentele au fost testate și funcționează corect.**

## Instrucțiuni Implementate

### Instrucțiuni de tip Register (R)
1. **SRA (Shift-Right Arithmetic)** - Deplasare aritmetică la dreapta
   - Format: `$d = $t >> h`
   - Cod mașină: `000000 00000 ttttt ddddd hhhhh 000011`
   
2. **XOR (bitwise Exclusive-OR)** - XOR logic între două registre
   - Format: `$d = $s ^ $t`
   - Cod mașină: `000000 sssss ttttt ddddd 00000 100110`

### Instrucțiuni de tip Immediate (I)
1. **BGTZ (Branch on Greater than Zero)** - Salt condiționat dacă un registru este mai mare ca 0
   - Format: `If $s > 0 then PC = (PC + 4) + (SE(offset) << 2) else PC = PC + 4`
   - Cod mașină: `000111 sssss 00000 oooooooooooooooo`
   
2. **ANDI (AND Immediate)** - SI logic între un registru și o valoare imediată
   - Format: `$t = $s & ZE(imm)`
   - Cod mașină: `001100 sssss ttttt iiiiiiiiiiiiiiii`


