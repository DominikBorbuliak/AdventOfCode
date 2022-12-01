main = do
    content <- readFile "01_input.txt"
    let linesOfFile = lines content
    print(findMax (head linesOfFile) (tail linesOfFile) 0 0)

findMax :: String -> [String] -> Integer -> Integer -> Integer
findMax _ [] currentMax currentSum = (max currentMax currentSum)
findMax "" arr currentMax currentSum = findMax (head arr) (tail arr) (max currentMax currentSum) 0
findMax str arr currentMax currentSum = findMax (head arr) (tail arr) currentMax (currentSum + read(str))

-- ! Solution: 70613