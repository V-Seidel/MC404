int read(int __fd, const void *__buf, int __n)
{
    int bytes;
    __asm__ __volatile__(
        "mv a0, %1           # file descriptor\n"
        "mv a1, %2           # buffer \n"
        "mv a2, %3           # size \n"
        "li a7, 63           # syscall read (63) \n"
        "ecall \n"
        "mv %0, a0"
        : "=r"(bytes)                     // Output list
        : "r"(__fd), "r"(__buf), "r"(__n) // Input list
        : "a0", "a1", "a2", "a7");
    return bytes;
}

void write(int __fd, const void *__buf, int __n)
{
    __asm__ __volatile__(
        "mv a0, %0           # file descriptor\n"
        "mv a1, %1           # buffer \n"
        "mv a2, %2           # size \n"
        "li a7, 64           # syscall write (64) \n"
        "ecall"
        :                                 // Output list
        : "r"(__fd), "r"(__buf), "r"(__n) // Input list
        : "a0", "a1", "a2", "a7");
}

#define N_BITS_ARRAY 40

int isNegativeFunction(char *str)
{
    if (str[0] == '-')
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

int charArrayToInt(char *str, int isNegative)
{
    int i = 0;
    int result = 0;

    if (isNegative)
        i++;

    while (str[i] != '\0')
    {
        if (str[i] != '\n')
            result = result * 10 + (str[i] - '0');
        i++;
    }

    return result;
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

void reverseEndianess(char *hex, int isCompleteHex)
{
    int n = findLength(hex);
    if (isCompleteHex)
        hex[n - 1] = '\0';

    reverseArray(hex);

    char aux[n];
    for (int i = 0; i < n - 2; i = i + 2)
    {
        aux[i] = hex[i + 1];
        hex[i + 1] = hex[i];
        hex[i] = aux[i];
    }
}

char *completeWithZeros(char *str, int base, int comeFromHex)
{
    if (base == 8)
        reverseArray(str);

    // 24x0\n\0

    int len = findLength(str);
    for (int i = len - 2; i < base + 1; i++)
        str[i] = '0';

    if (comeFromHex)
        str[findLength(str)] = '\n';
    // write(1, str, findLength(str));

    if (base == 8)
    {
        str[base + 2] = 'x';
        str[base + 3] = '0';
        str[base + 4] = '\0';
    }
    else
    {
        str[base] = 'b';
        str[base + 1] = '0';
        str[base + 2] = '\0';
    }

    reverseArray(str);
    return str;
}

void intToChar(unsigned int number, char result[], int isNegative)
{
    int i = 0;

    while (number > 0)
    {
        result[i] = number % 10 + '0';
        number /= 10;
        i++;
    }
    if (isNegative)
    {
        result[i] = '-';
        i++;
    }
    reverseArray(result);
}

char returnCharVal(int num)
{
    if (num >= 0 && num <= 9)
        return (char)(num + '0');
    else
        return (char)(num - 10 + 'a');
}

// Funcao para aplicar complemento de 1
void binaryOneComplement(char *binary, int step)
{
    for (int i = step - 1; i >= 2; i--)
    {
        if (binary[i] == '1')
            binary[i] = '0';

        else
            binary[i] = '1';
    }
}

// Funcao para aplicar complemento de 2
void binaryTwoComplement(char *binary)
{
    int n = findLength(binary);

    for (int i = n; i > 1; i--)
    {
        if (binary[i] == '1')
        {
            binaryOneComplement(binary, i);
            break;
        }
    }
}

void DecimalToGenericBase(unsigned int inputNum, int base, char result[], int isNegative)
{
    int index = 0;
    while (inputNum > 0)
    {
        result[index++] = returnCharVal(inputNum % base);
        inputNum /= base;
    }
    if (base == 2)
    {
        result[index] = 'b';
        index++;
        result[index] = '0';
    }
    else if (base == 16)
    {
        result[index] = 'x';
        index++;
        result[index] = '0';
    }
    index++;
    result[index] = '\0';

    if (isNegative)
    {
        completeWithZeros(result, 32, 0);
        binaryTwoComplement(result);
    }
    else
        reverseArray(result);
}

unsigned int power(int base, int exp)
{
    if (exp < 0)
        return -1;

    unsigned int result = 1;
    while (exp)
    {
        if (exp & 1)
            result *= base;
        exp >>= 1;
        base *= base;
    }

    return result;
}

// Funcao para converter um numero binario para hexadecimal
void binaryToHex(char *binary, char *hex)
{
    int i = 2;
    int j = 2;
    hex[0] = '0';
    hex[1] = 'x';
    int n = findLength(binary);
    binary[n - 1] = '\0';

    while (binary[i] != '\0')
    {
        int sum = 0;

        for (int k = 0; k < 4; k++)
        {
            sum += (binary[i] - '0') * (1 << (3 - k));
            i++;
        }
        if (sum < 10)
            hex[j] = sum + '0';
        else
            hex[j] = sum - 10 + 'a';

        j++;
    }
    hex[j] = '\n';
    hex[j + 1] = '\0';
}

unsigned int hexToDecimal(char *hex, int stopStep, int startStep)
{
    unsigned int decimal = 0;
    int place = 0;
    int n = findLength(hex);
    int val;

    // 90acf7ff0x\n\0

    for (int i = n - startStep; i > stopStep; i--)
    {
        if (hex[i] >= '0' && hex[i] <= '9')
        {
            val = hex[i] - 48;
        }
        else if (hex[i] >= 'a' && hex[i] <= 'f')
        {
            val = hex[i] - 97 + 10;
        }

        decimal += val * power(16, place);
        n--;
        place++;
    }

    return decimal;
}

int main()
{
    unsigned int inputNum = 0;
    int isNegative = 0;
    unsigned int decimalIntNumber = 0;
    char binaryResult[N_BITS_ARRAY];
    char inputResult[N_BITS_ARRAY];
    char hexResult[N_BITS_ARRAY];
    char endianessResult[N_BITS_ARRAY];
    char finalResults[N_BITS_ARRAY];

    int n = read(0, inputResult, N_BITS_ARRAY);
    inputResult[n] = '\n';

    if (inputResult[1] == 'x')
    {
        decimalIntNumber = hexToDecimal(inputResult, 1, 3);
        intToChar(decimalIntNumber, finalResults, 0);

        // Printar o valor em binario
        DecimalToGenericBase(decimalIntNumber, 2, binaryResult, 0);
        // printArray(binaryResult);
        binaryResult[findLength(binaryResult)] = '\n';
        write(1, binaryResult, findLength(binaryResult));

        // Verifica o bit mais significativo para saber se o numero é negativo
        if (decimalIntNumber > 2147483647)
        {
            isNegative = 1;
            decimalIntNumber = 4294967295 - decimalIntNumber + 1;
        }

        intToChar(decimalIntNumber, finalResults, isNegative);

        // Printar o valor em decimal
        finalResults[findLength(finalResults)] = '\n';
        write(1, finalResults, findLength(finalResults));

        // Printar o valor em hexadecimal
        // printArray(inputResult);
        write(1, inputResult, findLength(inputResult));

        completeWithZeros(inputResult, 8, 1);

        reverseEndianess(inputResult, 0);

        decimalIntNumber = hexToDecimal(inputResult, -1, 3);
        intToChar(decimalIntNumber, endianessResult, 0);
        // printArray(endianessResult);
        endianessResult[findLength(endianessResult)] = '\n';
        write(1, endianessResult, findLength(endianessResult));
    }

    else
    {
        isNegative = isNegativeFunction(inputResult);
        decimalIntNumber = charArrayToInt(inputResult, isNegative);

        // Printar o valor em binario
        DecimalToGenericBase(decimalIntNumber, 2, binaryResult, isNegative);
        // printArray(binaryResult);
        binaryResult[findLength(binaryResult)] = '\n';
        write(1, binaryResult, findLength(binaryResult));

        // Printar o valor em decimal
        intToChar(decimalIntNumber, inputResult, isNegative);
        // printArray(inputResult);
        inputResult[findLength(inputResult)] = '\n';
        write(1, inputResult, findLength(inputResult));

        // Printar o valor em hexadecimal
        if (isNegative)
            binaryToHex(binaryResult, hexResult);

        else
        {
            DecimalToGenericBase(decimalIntNumber, 16, hexResult, isNegative);
            hexResult[findLength(hexResult)] = '\n';
        }
        // printArray(hexResult);
        write(1, hexResult, findLength(hexResult));

        // Printar o valor em hexadecimal com endianess trocado
        if (!isNegative)
            completeWithZeros(hexResult, 8, 0);

        reverseEndianess(hexResult, 1);

        if (!isNegative)
            decimalIntNumber = hexToDecimal(hexResult, -1, 1);
        else
            decimalIntNumber = hexToDecimal(hexResult, -1, 3);

        isNegative = 0;

        intToChar(decimalIntNumber, endianessResult, isNegative);

        // printArray(endianessResult);
        endianessResult[findLength(endianessResult)] = '\n';
        write(1, endianessResult, findLength(endianessResult));
    }
    return 0;
}

void _start()
{
    main();
}
