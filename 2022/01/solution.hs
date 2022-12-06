import Data.List

main = do
    content <- readFile "input.txt"
    let linesOfFile = lines content
    print(getTopNSum 1 $ getSums linesOfFile 0)
    print(getTopNSum 3 $ getSums linesOfFile 0)

getSums :: [String] -> Integer -> [Integer]
getSums [] currentSum = [currentSum]
getSums ("":arr) currentSum = currentSum : getSums arr 0
getSums (line:arr) currentSum = getSums arr (currentSum + read(line))

getTopNSum :: Int -> [Integer] -> Integer
getTopNSum n arr = sum $ take n $ reverse $ sort arr

-- ! Solution A: 70613
-- ! Solution B: 205805