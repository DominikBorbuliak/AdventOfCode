proc arePrevNCharactersDistinct(str: string, endIdx: int, n: int): bool =
    var characters: array[0..25, int]

    if endIdx - n + 1 < 0:
        return false

    for i in (endIdx - n + 1)..endIdx:
        let currentChar = str[i]
        let currentCharPos = ord(currentChar) - 97
        
        if characters[currentCharPos] > 0:
            return false
        else:
            characters[currentCharPos] = 1

    return true


proc firstNDistinctCharacterSequence(str: string, n: int): int =
    var idx = n - 1

    while idx < len(str) and not arePrevNCharactersDistinct(str, idx, n):
        idx += 1

    if idx >= len(str):
        return -1

    return idx + 1


let entireFile = readFile("input.txt")
echo firstNDistinctCharacterSequence(entireFile, 4)
echo firstNDistinctCharacterSequence(entireFile, 14)

# ! Solution A: 1920
# ! Solution B: 2334
