main = do
    content <- readFile "01_input.txt"
    let linesOfFile = lines content
    print(findMax linesOfFile 0 0)

findMax :: [String] -> Integer -> Integer -> Integer
findMax [] currentMax currentSum = (max currentMax currentSum)
findMax ("":arr) currentMax currentSum = findMax arr (max currentMax currentSum) 0
findMax (line:arr) currentMax currentSum = findMax arr currentMax (currentSum + read(line))

-- ! Solution: 70613