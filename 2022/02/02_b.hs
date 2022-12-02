main = do
    content <- readFile "02_input.txt"
    print(getMaxScore $ lines content)

-- A = ROCK    = 1 point
-- B = PAPER   = 2 points
-- C = SCISORS = 3 points
-- Z = WIN  = 6 points
-- Y = DRAW = 3 points
-- X = LOST = 0 points
getMaxScore :: [String] -> Integer
getMaxScore [] = 0
getMaxScore ("A X":arr) = 3 + 0 + getMaxScore arr
getMaxScore ("A Y":arr) = 1 + 3 + getMaxScore arr
getMaxScore ("A Z":arr) = 2 + 6 + getMaxScore arr
getMaxScore ("B X":arr) = 1 + 0 + getMaxScore arr
getMaxScore ("B Y":arr) = 2 + 3 + getMaxScore arr
getMaxScore ("B Z":arr) = 3 + 6 + getMaxScore arr
getMaxScore ("C X":arr) = 2 + 0 + getMaxScore arr
getMaxScore ("C Y":arr) = 3 + 3 + getMaxScore arr
getMaxScore ("C Z":arr) = 1 + 6 + getMaxScore arr

-- ! Solution: 12767