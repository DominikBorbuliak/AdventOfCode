import Data.List

main = do
    content <- readFile "01_input.txt"
    let linesOfFile = lines content
    print(getTop3Sum $ getSums linesOfFile 0)

getSums :: [String] -> Integer -> [Integer]
getSums [] currentSum = [currentSum]
getSums ("":arr) currentSum = currentSum : getSums arr 0
getSums (line:arr) currentSum = getSums arr (currentSum + read(line))

getTop3Sum :: [Integer] -> Integer
getTop3Sum arr = sum $ take 3 $ reverse $ sort arr

-- ! Solution: 205805