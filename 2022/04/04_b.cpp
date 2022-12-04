#include <iostream>
#include <fstream>
#include<string.h>
#include<vector>
using namespace std;

vector<string> split(string text, const char* delimiter);
bool arePartiallyOverleaping(int range1Min, int range1Max, int range2Min, int range2Max);

int main() {
    int result = 0;

    string line;
    ifstream file("04_input.txt");

    while (getline(file, line)) {
        vector<string> lineVect = split(line, ",");

        vector<string> range1Vect = split(lineVect[0], "-");
        vector<string> range2Vect = split(lineVect[1], "-");

        if (arePartiallyOverleaping(stoi(range1Vect[0]), stoi(range1Vect[1]), stoi(range2Vect[0]), stoi(range2Vect[1])))
            result += 1;
    }

    file.close();

    cout << result << endl;

    return 0;
}

vector<string> split(string text, const char* delimiter) {
    vector<string> result;

    int textLength = text.length();
    char textCharArr[textLength + 1];
    strcpy(textCharArr, text.c_str());

    char *token = strtok(textCharArr, delimiter);
    int index = 0;
    while (token != NULL) {
        result.push_back(token);
        token = strtok(NULL, delimiter);
    }

    return result;
}

bool arePartiallyOverleaping(int range1Min, int range1Max, int range2Min, int range2Max) {
    if (range1Min <= range2Min && range1Max >= range2Min)
        return true;

    if (range1Min <= range2Max && range1Max >= range2Max)
        return true;

    if (range2Min <= range1Min && range2Max >= range1Min)
        return true;

    if (range2Min <= range1Max && range2Max >= range1Max)
        return true;

    return false;
}

// ! Solution: 792
