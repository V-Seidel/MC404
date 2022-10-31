#include <fcntl.h>
#include <unistd.h>

typedef struct
{
    unsigned char e_ident[16];  // Magic number and other info
    unsigned short e_type;      // Object file type
    unsigned short e_machine;   // Architecture
    unsigned int e_version;     // Object file version
    unsigned int e_entry;       // Entry point virtual address
    unsigned int e_phoff;       // Program header table file offset
    unsigned int e_shoff;       // Section header table file offset
    unsigned int e_flags;       // Processor-specific flags
    unsigned short e_ehsize;    // ELF header size in bytes
    unsigned short e_phentsize; // Program header table entry size
    unsigned short e_phnum;     // Program header table entry count
    unsigned short e_shentsize; // Section header table entry size
    unsigned short e_shnum;     // Section header table entry count
    unsigned short e_shstrndx;  // Section header string table index
} Elf32_Ehdr;

typedef struct
{
    unsigned int sh_name;      // Section name (string tbl index)
    unsigned int sh_type;      // Section type
    unsigned int sh_flags;     // Section flags
    unsigned int sh_addr;      // Section virtual addr at execution
    unsigned int sh_offset;    // Section file offset
    unsigned int sh_size;      // Section size in bytes
    unsigned int sh_link;      // Link to another section
    unsigned int sh_info;      // Additional section information
    unsigned int sh_addralign; // Section alignment
    unsigned int sh_entsize;   // Entry size if section holds table
} Elf32_Shdr;

typedef struct
{
    unsigned int st_name;  // Symbol name (string tbl index)
    unsigned int st_value; // Symbol value
    unsigned int st_size;  // Symbol size
    unsigned char st_info; // Symbol type and binding
    unsigned char st_other;
    unsigned short st_shndx; // Section index
} Elf32_Sym;

int equalString(char *str1, char *str2)
{
    int i = 0;
    while (str1[i] != '\0' && str2[i] != '\0')
    {
        if (str1[i] != str2[i])
            return 0;
        i++;
    }
    if (str1[i] == '\0' && str2[i] == '\0')
        return 1;
    return 0;
}

int findLength(char *arr)
{
    int i = 0;
    while (arr[i] != '\0')
        i++;
    return i;
}

char returnCharVal(unsigned int num)
{
    if (num >= 0 && num <= 9)
        return (char)(num + '0');
    else
        return (char)(num - 10 + 'a');
}

void completeHexWithZeros(char *hex)
{
    int n = findLength(hex);
    if (n < 8)
    {
        for (int i = n; i < 8; i++)
            hex[i] = '0';
        hex[8] = '\0';
    }
}

void completeBinaryWithZeros(char *binary)
{
    int n = findLength(binary);
    if (n < 32)
    {
        for (int i = n; i < 32; i++)
            binary[i] = '0';
        binary[32] = '\0';
    }
}

void reverseArray(char *str)
{
    int len = findLength(str);
    int i;
    for (i = 0; i < len / 2; i++)
    {
        char temp = str[i];
        str[i] = str[len - i - 1];
        str[len - i - 1] = temp;
    }
}

void reverseEndianess(char *hex, char *aux)
{
    int i = 0;
    int j = 0;
    while (hex[i] != '\0')
    {
        aux[j++] = hex[i + 6];
        aux[j++] = hex[i + 7];
        aux[j++] = hex[i + 4];
        aux[j++] = hex[i + 5];
        aux[j++] = hex[i + 2];
        aux[j++] = hex[i + 3];
        aux[j++] = hex[i + 0];
        aux[j++] = hex[i + 1];
        aux[j++] = ' ';
        i += 8;
    }
    aux[j] = '\0';
}

void decimalToGenericBase(unsigned int inputNum, int base, char result[])
{
    int index = 0;
    while (inputNum > 0)
    {
        result[index++] = returnCharVal(inputNum % base);
        inputNum /= base;
    }
    result[index] = '\0';

    if (base == 16)
    {
        completeHexWithZeros(result);
        reverseArray(result);
    }
}

void intToChar(int num, char *str)
{
    int i = 0;
    if (num == 0)
    {
        str[0] = '0';
        str[1] = '\0';
        return;
    }
    while (num > 0)
    {
        str[i++] = (char)(num % 10 + '0');
        num /= 10;
    }
    str[i] = '\0';
    reverseArray(str);
}

void printSectionHeader(int sectionSize, int sectionIndex, int sectionVMA, char *sectionName)
{
    char indexStr[3];
    char sectionSizeStr[9];
    char sectionVMAStr[9];

    intToChar(sectionIndex, indexStr);
    decimalToGenericBase(sectionSize, 16, sectionSizeStr);
    decimalToGenericBase(sectionVMA, 16, sectionVMAStr);

    write(1, indexStr, findLength(indexStr));
    write(1, " ", 1);
    write(1, sectionName, findLength(sectionName));
    write(1, "\t", 1);
    write(1, sectionSizeStr, findLength(sectionSizeStr));
    write(1, "\t", 1);
    write(1, sectionVMAStr, findLength(sectionVMAStr));
    write(1, "\n", 1);
}

void printSymbolTable(char *symbolValue, char *symbolBinding, char *sectionName, char *symbolSize, char *symbolName)
{
    write(1, symbolValue, findLength(symbolValue));
    write(1, " ", 1);
    write(1, symbolBinding, findLength(symbolBinding));
    write(1, "\t", 1);
    write(1, sectionName, findLength(sectionName));
    write(1, "\t", 1);
    write(1, symbolSize, findLength(symbolSize));
    write(1, " ", 1);
    write(1, symbolName, findLength(symbolName));
    write(1, "\n", 1);
}

void getRegister(unsigned int registerValue, char *result)
{
    char *registers[32] = {"zero\0", "ra\0", "sp\0", "gp\0", "tp\0", "t0\0", "t1\0", "t2\0",
                           "s0\0", "s1\0", "a0\0", "a1\0", "a2\0", "a3\0", "a4\0", "a5\0", "a6\0", "a7\0", "s2\0", "s3\0", "s4\0", "s5\0", "s6\0", "s7\0", "s8\0", "s9\0", "s10\0", "s11\0", "t3\0", "t4\0", "t5\0", "t6\0"};
    for (int i = 0; i < 32; i++)
    {
        if (i == registerValue)
        {
            int j = 0;
            while (registers[i][j] != '\0')
            {
                result[j] = registers[i][j];
                j++;
            }
            result[j] = '\0';
            return;
        }
    }
}

void toString(unsigned int x, char *ans)
{
    int ptr = 0;
    while (x > 0)
    {
        ans[ptr++] = returnCharVal(x % 10);
        x /= 10;
    }
    for (int i = 0; i < ptr / 2; i++)
    {
        int temp = ans[ptr - i - 1];
        ans[ptr - i - 1] = ans[i];
        ans[i] = temp;
    }
    if (ptr == 0)
    {
        ans[0] = '0';
        ptr++;
    }
    ans[ptr] = '\0';
}

void printNumber(unsigned int x, int isNegative)
{
    char num[11];
    int ptr = isNegative;
    if (isNegative)
        num[0] = '-';

    toString(x, num + ptr);
    write(1, num, findLength(num));
}

void binaryToDecimal(char *bin)
{
    int n = findLength(bin), isNegative = 0;
    if (bin[n - 1] == '1')
    {
        for (int i = 0; i < n; i++)
        {
            bin[i] = (bin[i] == '0') ? '1' : '0';
        }
        isNegative = 1;
    }
    unsigned int x = 0, p2 = 1;
    for (int i = 0; i < n; i++)
    {
        x += ((unsigned int)(bin[i] - '0')) * p2;
        p2 *= 2;
    }
    if (isNegative)
        x++;

    printNumber(x, isNegative);
}

unsigned int binaryToDecimalPrint(char *bin)
{
    int n = findLength(bin);
    unsigned int x = 0, p2 = 1;
    for (int i = 0; i < n; i++)
    {
        x += ((unsigned int)(bin[i] - '0')) * p2;
        p2 *= 2;
    }
    return x;
}

int binaryToDecimalNegative(char *bin)
{
    int n = findLength(bin), flag = 0;
    if (bin[n - 1] == '1')
    {
        for (int i = 0; i < n; i++)
            bin[i] = (bin[i] == '0') ? '1' : '0';
        flag = 1;
    }
    int x = 0, p2 = 1;
    for (int i = 0; i < n; i++)
    {
        x += ((int)(bin[i] - '0')) * p2;
        p2 *= 2;
    }
    if (flag)
        x++;
    return x * 2 * (flag ? -1 : 1);
}

void noLeadingZeros(char *str, char *str2)
{
    int i = 0;
    int j = 0;
    while (str[i] == '0')
    {
        i++;
        str2[j++] = ' ';
    }
    while (str[i] != '\0')
        str2[j++] = str[i++];
    str2[j] = '\0';
}

void noLeadingZeros2(char *str, char *str2)
{
    int i = 0;
    int j = 0;
    while (str[i] == '0')
        i++;

    while (str[i] != '\0')
        str2[j++] = str[i++];
    str2[j] = '\0';
}

void writeWithSpace(char *str)
{
    int i = 0;
    while (i < 8)
    {
        write(1, &str[i], 1);
        write(1, &str[++i], 1);
        i++;
        if (str[i] != '\0')
            write(1, " ", 1);
    }
}

void getSubString(char *str, char *str2, int start, int lenght)
{
    int i = start;
    int j = 0;
    while (i < start + lenght)
        str2[j++] = str[i++];
    str2[j] = '\0';
}

void printRegister(char *binaryInstruction, int start)
{
    char registerName[6];
    getSubString(binaryInstruction, registerName, start, 5);
    unsigned int destinationValue = binaryToDecimalPrint(registerName);
    char destinationRegister[5];
    getRegister(destinationValue, destinationRegister);
    write(1, destinationRegister, findLength(destinationRegister));
}

void getWord(char *word, char *sword)
{
    int ptr = 0;
    char ch[] = {'i', 'o', 'r', 'w'};
    for (int i = 3; i >= 0; i--)
    {
        if (word[i] == '1')
            sword[ptr++] = ch[3 - i];
    }
    sword[ptr] = '\0';
}

void printInstructionInfo(char type0, char type1, char *binaryInstruction, int instructionAdress, unsigned char *elfFIle, Elf32_Shdr **sectionHeader, Elf32_Sym **symbolList, int pointerSize, int strtab_index)
{
    char immediate[20];
    // char immediate2[20];
    if (type0 == 'U')
    {
        printRegister(binaryInstruction, 7);
        getSubString(binaryInstruction, immediate, 12, 20);
        write(1, ", ", 2);
        binaryToDecimal(immediate);
        write(1, "\n", 1);
    }
    else if (type0 == 'I')
    {
        if (type1 != '5')
        {
            printRegister(binaryInstruction, 7);
            write(1, ", ", 2);
        }

        if (type1 == '0')
        {
            getSubString(binaryInstruction, immediate, 20, 12);
            binaryToDecimal(immediate);
            write(1, "(", 1);
            printRegister(binaryInstruction, 15);
            write(1, ")", 1);
            write(1, "\n", 1);
        }

        else if (type1 == '1')
        {
            printRegister(binaryInstruction, 15);
            write(1, ", ", 2);
            getSubString(binaryInstruction, immediate, 20, 12);
            binaryToDecimal(immediate);
            write(1, "\n", 1);
        }
        else if (type1 == '2')
        {
            printRegister(binaryInstruction, 15);
            write(1, ", ", 2);
            getSubString(binaryInstruction, immediate, 20, 5);
            unsigned int shamnt = binaryToDecimalPrint(immediate);
            char shamntString[11];
            intToChar(shamnt, shamntString);
            write(1, shamntString, findLength(shamntString));
            write(1, "\n", 1);
        }
        else if (type1 == '6')
        {
            getSubString(binaryInstruction, immediate, 20, 12);
            binaryToDecimal(immediate);
            write(1, ", ", 2);
            printRegister(binaryInstruction, 15);
            write(1, "\n", 1);
        }
        else if (type1 == '7')
        {
            getSubString(binaryInstruction, immediate, 20, 12);
            binaryToDecimal(immediate);
            write(1, ", ", 2);
            getSubString(binaryInstruction, immediate, 15, 5);
            binaryToDecimal(immediate);
            write(1, "\n", 1);
        }
    }
    else if (type0 == 'S')
    {
        printRegister(binaryInstruction, 20);
        write(1, ", ", 2);
        for (int i = 0; i < 5; i++)
            immediate[i] = binaryInstruction[7 + i];

        for (int i = 0; i < 7; i++)
            immediate[5 + i] = binaryInstruction[25 + i];
        immediate[12] = '\0';
        binaryToDecimal(immediate);
        write(1, "(", 1);
        printRegister(binaryInstruction, 15);
        write(1, ")", 1);
        write(1, "\n", 1);
    }
    else if (type0 == 'R')
    {
        printRegister(binaryInstruction, 7);
        write(1, ", ", 2);
        printRegister(binaryInstruction, 15);
        write(1, ", ", 2);
        printRegister(binaryInstruction, 20);
        write(1, "\n", 1);
    }
    else if (type0 == 'J')
    {
        printRegister(binaryInstruction, 7);
        write(1, ", ", 2);
        for (int i = 0; i < 10; i++)
            immediate[i] = binaryInstruction[21 + i];
        immediate[10] = binaryInstruction[20];
        for (int i = 0; i < 8; i++)
            immediate[11 + i] = binaryInstruction[12 + i];
        immediate[19] = binaryInstruction[31];
        immediate[20] = '\0';
        int value = binaryToDecimalNegative(immediate);
        int address = instructionAdress + value;
        for (int i = 0; i < pointerSize; i++)
        {
            if (address == symbolList[i]->st_value)
            {
                write(1, "0x", 2);
                char hexValue[20];
                char hexValueNoZeros[20];
                decimalToGenericBase(symbolList[i]->st_value, 16, hexValue);
                noLeadingZeros2(hexValue, hexValueNoZeros);
                write(1, hexValueNoZeros, findLength(hexValueNoZeros));
                char *name = (char *)(elfFIle + sectionHeader[strtab_index]->sh_offset + symbolList[i]->st_name);
                write(1, " <", 2);
                write(1, name, findLength(name));
                write(1, ">", 1);
            }
        }
        write(1, "\n", 1);
    }
    else if (type0 == 'B')
    {
        printRegister(binaryInstruction, 15);
        write(1, ", ", 2);
        printRegister(binaryInstruction, 20);
        write(1, ", ", 2);
        for (int i = 0; i < 4; i++)
            immediate[i] = binaryInstruction[8 + i];
        for (int i = 0; i < 6; i++)
            immediate[4 + i] = binaryInstruction[25 + i];
        immediate[10] = binaryInstruction[7];
        immediate[11] = binaryInstruction[31];
        immediate[12] = '\0';
        int value = binaryToDecimalNegative(immediate);
        int address = instructionAdress + value;
        for (int i = 0; i < pointerSize; i++)
        {
            if (address == symbolList[i]->st_value)
            {
                write(1, "0x", 2);
                char hexValue[20];
                char hexValueNoZeros[20];
                decimalToGenericBase(symbolList[i]->st_value, 16, hexValue);
                noLeadingZeros2(hexValue, hexValueNoZeros);
                write(1, hexValueNoZeros, findLength(hexValueNoZeros));
                char *name = (char *)(elfFIle + sectionHeader[strtab_index]->sh_offset + symbolList[i]->st_name);
                write(1, " <", 2);
                write(1, name, findLength(name));
                write(1, ">", 1);
            }
        }
        write(1, "\n", 1);
    }
}

int main(int argc, char *argv[])
{
    unsigned char elfFile[102405];

    int fd;
    Elf32_Ehdr *elfHeader;
    fd = open(argv[2], O_RDONLY);

    // Ler o arquivo e armazenar em um vetor de bytes (tamanho maximo total 10kB)
    read(fd, elfFile, 102405);
    elfHeader = (Elf32_Ehdr *)&elfFile;

    write(1, "\n", 1);
    write(1, argv[2], findLength(argv[2]));
    write(1, ":\tfile format elf32-littleriscv\n\n", 33);

    // Inicio e o fim de cada secao do arquivo ELF
    int inicio = elfHeader->e_shoff;

    // Cria um array de Structs do tipo Elf32_Shdr (Section Header)
    Elf32_Shdr *sectionHeader[elfHeader->e_shnum];
    Elf32_Sym *symbolTable;

    // Preenche o array de Structs com os dados do arquivo ELF
    for (int i = 0; i < elfHeader->e_shnum; i++)
    {
        sectionHeader[i] = (Elf32_Shdr *)&elfFile[inicio];
        inicio += elfHeader->e_shentsize;
    }

    inicio = elfHeader->e_shoff;

    // Salva o valor do endereco de shstrtab
    unsigned int shstrtab_adress = sectionHeader[elfHeader->e_shstrndx]->sh_offset;
    unsigned int strtab_id = 0;
    unsigned int symtab_id = 0;

    for (int i = 0; i < elfHeader->e_shnum; i++)
    {
        if (sectionHeader[i]->sh_type == 3)
            strtab_id = i;
        if (sectionHeader[i]->sh_type == 2)
        {
            symtab_id = i;
            symbolTable = (Elf32_Sym *)&elfFile[sectionHeader[i]->sh_offset];
        }
    }

    // Symbol Table
    if (argv[1][1] == 't')
    {
        write(1, "SYMBOL TABLE:\n", 14);
        char *sectionName;
        for (int i = 0; i < elfHeader->e_shnum; i++)
        {
            if (sectionHeader[i]->sh_type == 2)
            {
                int symbolTableSize = sectionHeader[i]->sh_size;
                int symbolTableEntries = symbolTableSize / sectionHeader[i]->sh_entsize;

                for (int j = 1; j < symbolTableEntries; j++)
                {
                    char *symbolName = (char *)&elfFile[sectionHeader[strtab_id]->sh_offset + symbolTable[j].st_name];
                    if (symbolTable[j].st_shndx < elfHeader->e_shnum)
                        sectionName = (char *)&elfFile[shstrtab_adress + sectionHeader[symbolTable[j].st_shndx]->sh_name];
                    else
                        sectionName = "*ABS*";
                    char symbolValue[9];
                    char *symbolBinding = (!(symbolTable[j].st_info & 0x10)) ? "l\0" : "g\0";
                    char symbolSize[9];
                    decimalToGenericBase(symbolTable->st_size, 16, symbolSize);
                    decimalToGenericBase(symbolTable[j].st_value, 16, symbolValue);
                    printSymbolTable(symbolValue, symbolBinding, sectionName, symbolSize, symbolName);
                }
            }
        }
    }

    // Section Table
    else if (argv[1][1] == 'h')
    {
        write(1, "Sections:\n", 10);
        write(1, "Idx Name\tSize\tVMA\n", 18);
        for (int i = 0; i < elfHeader->e_shnum; i++)
        {
            char *sectionName = (char *)&elfFile[shstrtab_adress + sectionHeader[i]->sh_name];
            unsigned int sectionSize = sectionHeader[i]->sh_size;
            unsigned int sectionVMA = sectionHeader[i]->sh_addr;
            printSectionHeader(sectionSize, i, sectionVMA, sectionName);
        }
        write(1, "\n", 1);
    }

    // Instruction Table
    else if (argv[1][1] == 'd')
    {
        write(1, "\nDisassembly of section .text:\n", 31);
        unsigned int sectionVMA;
        unsigned int sectionSize;
        unsigned int sectionOffset;
        char instructionBinaryStr[33];
        unsigned int intInstructionAdress = 0;

        for (int i = 0; i < elfHeader->e_shnum; i++)
        {
            if (equalString((char *)&elfFile[shstrtab_adress + sectionHeader[i]->sh_name], ".text"))
            {
                sectionVMA = sectionHeader[i]->sh_addr;
                sectionSize = sectionHeader[i]->sh_size;
                sectionOffset = sectionHeader[i]->sh_offset;
            }
        }

        unsigned int symbolTableSizeLines = sectionHeader[symtab_id]->sh_size / sectionHeader[symtab_id]->sh_entsize;
        Elf32_Sym *printSymbol[symbolTableSizeLines];
        unsigned int symbolPointer = 0;

        for (int i = sectionOffset; i < sectionOffset + sectionSize; i += 4)
        {
            unsigned int instruction = elfFile[i] | elfFile[i + 1] << 8 | elfFile[i + 2] << 16 | elfFile[i + 3] << 24;
            char instructionStr[9];
            char instructionStrEndianess[9];

            decimalToGenericBase(instruction, 16, instructionStr);
            decimalToGenericBase(instruction, 2, instructionBinaryStr);

            char instructionAddress[9];
            char instructionAdressNoZero[9];
            char binarySubstr[8];
            intInstructionAdress = sectionVMA + i - sectionOffset;

            decimalToGenericBase(intInstructionAdress, 16, instructionAddress);
            for (int j = 1; j < symbolTableSizeLines; j++)
            {
                if (symbolTable[j].st_value == sectionVMA + i - sectionOffset)
                {
                    char *symbolName = (char *)&elfFile[sectionHeader[strtab_id]->sh_offset + symbolTable[j].st_name];
                    if (findLength(symbolName))
                    {
                        char *sectionName = (char *)&elfFile[shstrtab_adress + sectionHeader[symbolTable[j].st_shndx]->sh_name];
                        if (equalString(sectionName, ".text"))
                        {
                            printSymbol[symbolPointer] = &symbolTable[j];
                            symbolPointer++;
                        }
                        write(1, "\n", 1);
                        write(1, instructionAddress, findLength(instructionAddress));
                        write(1, " <", 2);
                        write(1, symbolName, findLength(symbolName));
                        write(1, ">:\n", 3);
                    }
                }
            }

            noLeadingZeros(instructionAddress, instructionAdressNoZero);
            write(1, instructionAdressNoZero, findLength(instructionAdressNoZero));
            write(1, ": ", 2);
            reverseEndianess(instructionStr, instructionStrEndianess);
            completeBinaryWithZeros(instructionBinaryStr);
            getSubString(instructionBinaryStr, binarySubstr, 0, 7);
            writeWithSpace(instructionStrEndianess);
            char type[3] = "xx\0";

            // Instructions
            if (equalString(binarySubstr, "1110110"))
            {
                write(1, "lui\t", 4);
                type[0] = 'U';
            }

            else if (equalString(binarySubstr, "1110100"))
            {
                write(1, "auipc\t", 6);
                type[0] = 'U';
            }

            else if (equalString(binarySubstr, "1111011"))
            {
                write(1, "jal\t", 4);
                type[0] = 'J';
            }

            else if (equalString(binarySubstr, "1110011"))
            {
                write(1, "jalr\t", 5);
                type[0] = 'I';
                type[1] = '0';
            }

            else if (equalString(binarySubstr, "1100011"))
            {
                type[0] = 'B';
                getSubString(instructionBinaryStr, binarySubstr, 12, 3);
                if (equalString(binarySubstr, "000"))
                    write(1, "beq\t", 4);

                else if (equalString(binarySubstr, "100"))
                    write(1, "bne\t", 4);

                else if (equalString(binarySubstr, "001"))
                    write(1, "blt\t", 4);

                else if (equalString(binarySubstr, "101"))
                    write(1, "bge\t", 4);

                else if (equalString(binarySubstr, "011"))
                    write(1, "bltu\t", 5);

                else if (equalString(binarySubstr, "111"))
                    write(1, "bgeu\t", 5);
            }
            else if (equalString(binarySubstr, "1100000"))
            {
                type[0] = 'I';
                type[1] = '0';
                getSubString(instructionBinaryStr, binarySubstr, 12, 3);
                if (equalString(binarySubstr, "000"))
                    write(1, "lb\t", 3);

                else if (equalString(binarySubstr, "100"))
                    write(1, "lh\t", 3);

                else if (equalString(binarySubstr, "010"))
                    write(1, "lw\t", 3);

                else if (equalString(binarySubstr, "001"))
                    write(1, "lbu\t", 4);

                else if (equalString(binarySubstr, "101"))
                    write(1, "lhu\t", 4);
            }
            else if (equalString(binarySubstr, "1100010"))
            {
                type[0] = 'S';
                getSubString(instructionBinaryStr, binarySubstr, 12, 3);
                if (equalString(binarySubstr, "000"))
                    write(1, "sb\t", 3);

                else if (equalString(binarySubstr, "100"))
                    write(1, "sh\t", 3);

                else if (equalString(binarySubstr, "010"))
                    write(1, "sw\t", 3);
            }
            else if (equalString(binarySubstr, "1100100"))
            {
                type[0] = 'I';
                type[1] = '1';
                getSubString(instructionBinaryStr, binarySubstr, 12, 3);
                if (equalString(binarySubstr, "000"))
                    write(1, "addi\t", 5);

                else if (equalString(binarySubstr, "010"))
                    write(1, "slti\t", 5);

                else if (equalString(binarySubstr, "110"))
                    write(1, "sltiu\t", 6);

                else if (equalString(binarySubstr, "001"))
                    write(1, "xori\t", 5);

                else if (equalString(binarySubstr, "011"))
                    write(1, "ori\t", 4);

                else if (equalString(binarySubstr, "111"))
                    write(1, "andi\t", 5);

                else if (equalString(binarySubstr, "100"))
                {
                    type[1] = '2';
                    write(1, "slli\t", 5);
                }

                else if (equalString(binarySubstr, "101"))
                {
                    type[1] = '2';
                    getSubString(instructionBinaryStr, binarySubstr, 25, 7);
                    if (equalString(binarySubstr, "0000000"))
                        write(1, "srli\t", 5);
                    else
                        write(1, "srai\t", 5);
                }
            }
            else if (equalString(binarySubstr, "1100110"))
            {
                type[0] = 'R';
                getSubString(instructionBinaryStr, binarySubstr, 12, 3);
                if (equalString(binarySubstr, "000"))
                    write(1, "add\t", 4);

                else if (equalString(binarySubstr, "100"))
                    write(1, "sll\t", 4);

                else if (equalString(binarySubstr, "010"))
                    write(1, "slt\t", 4);

                else if (equalString(binarySubstr, "110"))
                    write(1, "sltu\t", 5);

                else if (equalString(binarySubstr, "001"))
                    write(1, "xor\t", 4);

                else if (equalString(binarySubstr, "101"))
                    write(1, "srl\t", 4);

                else if (equalString(binarySubstr, "011"))
                    write(1, "or\t", 3);

                else if (equalString(binarySubstr, "111"))
                    write(1, "and\t", 4);
            }
            else if (equalString(binarySubstr, "1111000"))
            {
                type[0] = 'I';
                getSubString(instructionBinaryStr, binarySubstr, 12, 3);
                if (equalString(binarySubstr, "000"))
                {
                    type[1] = '3';
                    write(1, "fence\t", 6);
                }

                else if (equalString(binarySubstr, "001"))
                {
                    type[1] = '4';
                    write(1, "fence.i\t", 8);
                }
            }
            else if (equalString(binarySubstr, "1100111"))
            {
                type[0] = 'I';
                getSubString(instructionBinaryStr, binarySubstr, 12, 3);
                if (equalString(binarySubstr, "000"))
                {
                    type[1] = '5';
                    getSubString(instructionBinaryStr, binarySubstr, 20, 12);
                    if (equalString(binarySubstr, "000000000000"))
                        write(1, "ecall\t", 6);
                    else
                        write(1, "ebreak\t", 7);
                }
                else if (equalString(binarySubstr, "100"))
                {
                    type[1] = '6';
                    write(1, "csrrw\t", 6);
                }

                else if (equalString(binarySubstr, "010"))
                {
                    type[1] = '6';
                    write(1, "csrrs\t", 6);
                }

                else if (equalString(binarySubstr, "110"))
                {
                    type[1] = '6';
                    write(1, "csrrc\t", 6);
                }

                else if (equalString(binarySubstr, "101"))
                {
                    type[1] = '7';
                    write(1, "csrrwi\t", 7);
                }

                else if (equalString(binarySubstr, "011"))
                {
                    type[1] = '7';
                    write(1, "csrrsi\t", 7);
                }

                else if (equalString(binarySubstr, "111"))
                {
                    type[1] = '7';
                    write(1, "csrrci\t", 7);
                }
            }
            else
                write(1, "<unknown>\n", 10);
            printInstructionInfo(type[0], type[1], instructionBinaryStr, intInstructionAdress, elfFile, (Elf32_Shdr **)sectionHeader, (Elf32_Sym **)printSymbol, symbolPointer, strtab_id);
        }
    }
}