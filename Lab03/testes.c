#include <stdio.h>

#define N_BITS_ARRAY 40

int isNegativeFunction(char *str)
{
    if (str[0] == '-')
        return 1;
    return 0;
}

void printArray(char *arr)
{
    int i = 0;
    while (i != 32)
    {
        printf("%c", arr[i]);
        i++;
    }
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

void reverseEndianess(char *hex)
{
    int n = findLength(hex);
    reverseArray(hex);
    char aux[n];
    for (int i = 0; i < n; i = i + 2)
    {
        aux[i] = hex[i + 1];
        hex[i + 1] = hex[i];
        hex[i] = aux[i];
    }
}

char *completeWithZeros(char *str, int base)
{
    if (base == 8)
        reverseArray(str);

    int len = findLength(str);
    for (int i = len - 2; i < base; i++)
        str[i] = '0';

    if (base == 8)
    {
        str[base] = 'x';
        str[base + 1] = '0';
    }
    else
    {
        str[base] = 'b';
        str[base + 1] = '0';
    }
    str[base + 2] = '\0';

    reverseArray(str);
    return str;
}

void intToChar(unsigned long int number, char result[], int isNegative)
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
    result[i] = '\0';
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

void DecimalToGenericBase(unsigned long int inputNum, int base, char result[], int isNegative)
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
        completeWithZeros(result, 32);
        binaryTwoComplement(result);
    }
    else
        reverseArray(result);
}

unsigned long int power(int base, int exp)
{
    if (exp < 0)
        return -1;

    unsigned long int result = 1;
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
    hex[j] = '\0';
}

unsigned long int hexToDecimal(char *hex, int stopStep, int startStep)
{
    unsigned long int decimal = 0;
    int place = 0;
    int n = findLength(hex);
    int val;

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

void main()
{
    unsigned long int inputNum = 0;
    int isNegative = 0;
    unsigned long int decimalIntNumber = 0;
    char binaryResult[N_BITS_ARRAY];
    char inputResult[N_BITS_ARRAY];
    char hexResult[N_BITS_ARRAY];
    char endianessResult[N_BITS_ARRAY];
    char finalResults[N_BITS_ARRAY];

    scanf("%s", inputResult);

    if (inputResult[1] == 'x')
    {
        decimalIntNumber = hexToDecimal(inputResult, 1, 1);
        intToChar(decimalIntNumber, finalResults, 0);

        // Printar o valor em binario
        DecimalToGenericBase(decimalIntNumber, 2, binaryResult, 0);
        printArray(binaryResult);

        // Verifica o bit mais significativo para saber se o numero é negativo
        if (findLength(binaryResult) >= 32 && binaryResult[2] == '1')
            intToChar(decimalIntNumber, finalResults, 1);

        // Printar o valor em decimal
        printArray(finalResults);

        // Printar o valor em hexadecimal
        printArray(inputResult);

        completeWithZeros(inputResult, 8);
        reverseEndianess(inputResult);
        decimalIntNumber = hexToDecimal(inputResult, -1, 3);
        intToChar(decimalIntNumber, endianessResult, 0);
        printArray(endianessResult);
    }

    else
    {
        isNegative = isNegativeFunction(inputResult);
        decimalIntNumber = charArrayToInt(inputResult, isNegative);

        // Printar o valor em binario
        DecimalToGenericBase(decimalIntNumber, 2, binaryResult, isNegative);
        binaryResult[findLength(binaryResult)] = '\n';
        printArray(binaryResult);

        // Printar o valor em decimal
        intToChar(decimalIntNumber, inputResult, isNegative);
        printArray(inputResult);

        // Printar o valor em hexadecimal
        if (isNegative)
            binaryToHex(binaryResult, hexResult);
        else
            DecimalToGenericBase(decimalIntNumber, 16, hexResult, isNegative);
        printArray(hexResult);

        // Printar o valor em hexadecimal com endianess trocado
        if (!isNegative)
            completeWithZeros(hexResult, 8);

        isNegative = 0;
        reverseEndianess(hexResult);
        decimalIntNumber = hexToDecimal(hexResult, -1, 3);
        intToChar(decimalIntNumber, endianessResult, isNegative);
        printArray(endianessResult);
    }
}
