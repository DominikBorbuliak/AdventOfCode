main = do
    content <- readFile "02_input.txt"
    print(getMaxScore $ lines content)

-- A = X = ROCK   = 1 point
-- B = Y = PAPER  = 2 points
-- C = Z  SCISORS = 3 points
-- WIN  = 6 points
-- DRAW = 3 points
-- LOST = 0 points
getMaxScore :: [String] -> Integer
getMaxScore [] = 0
getMaxScore ("A X":arr) = 1 + 3 + getMaxScore arr
getMaxScore ("A Y":arr) = 2 + 6 + getMaxScore arr
getMaxScore ("A Z":arr) = 3 + 0 + getMaxScore arr
getMaxScore ("B X":arr) = 1 + 0 + getMaxScore arr
getMaxScore ("B Y":arr) = 2 + 3 + getMaxScore arr
getMaxScore ("B Z":arr) = 3 + 6 + getMaxScore arr
getMaxScore ("C X":arr) = 1 + 6 + getMaxScore arr
getMaxScore ("C Y":arr) = 2 + 0 + getMaxScore arr
getMaxScore ("C Z":arr) = 3 + 3 + getMaxScore arr

-- ! Solution: 11666