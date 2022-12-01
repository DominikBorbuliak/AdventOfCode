import Data.List

main = do
    content <- readFile "01_input.txt"
    let linesOfFile = lines content
    let listOfSums = getSums (head linesOfFile) (tail linesOfFile) 0
    print(getTop3Sum listOfSums)

getSums :: String -> [String] -> Integer -> [Integer]
getSums _ [] currentSum = [currentSum]
getSums "" arr currentSum = currentSum : getSums (head arr) (tail arr) 0
getSums str arr currentSum = getSums (head arr) (tail arr) (currentSum + read(str))

getTop3Sum :: [Integer] -> Integer
getTop3Sum arr = sum $ take 3 $ reverse $ sort arr

-- ! Solution: 205805