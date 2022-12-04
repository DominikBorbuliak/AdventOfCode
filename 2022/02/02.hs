main = do
    content <- readFile "02_input.txt"
    print(getMaxScoreA $ lines content)
    print(getMaxScoreB $ lines content)

-- A = X = ROCK   = 1 point
-- B = Y = PAPER  = 2 points
-- C = Z  SCISORS = 3 points
-- WIN  = 6 points
-- DRAW = 3 points
-- LOST = 0 points
getMaxScoreA :: [String] -> Integer
getMaxScoreA [] = 0
getMaxScoreA ("A X":arr) = 1 + 3 + getMaxScoreA arr
getMaxScoreA ("A Y":arr) = 2 + 6 + getMaxScoreA arr
getMaxScoreA ("A Z":arr) = 3 + 0 + getMaxScoreA arr
getMaxScoreA ("B X":arr) = 1 + 0 + getMaxScoreA arr
getMaxScoreA ("B Y":arr) = 2 + 3 + getMaxScoreA arr
getMaxScoreA ("B Z":arr) = 3 + 6 + getMaxScoreA arr
getMaxScoreA ("C X":arr) = 1 + 6 + getMaxScoreA arr
getMaxScoreA ("C Y":arr) = 2 + 0 + getMaxScoreA arr
getMaxScoreA ("C Z":arr) = 3 + 3 + getMaxScoreA arr

-- A = ROCK    = 1 point
-- B = PAPER   = 2 points
-- C = SCISORS = 3 points
-- Z = WIN  = 6 points
-- Y = DRAW = 3 points
-- X = LOST = 0 points
getMaxScoreB :: [String] -> Integer
getMaxScoreB [] = 0
getMaxScoreB ("A X":arr) = 3 + 0 + getMaxScoreB arr
getMaxScoreB ("A Y":arr) = 1 + 3 + getMaxScoreB arr
getMaxScoreB ("A Z":arr) = 2 + 6 + getMaxScoreB arr
getMaxScoreB ("B X":arr) = 1 + 0 + getMaxScoreB arr
getMaxScoreB ("B Y":arr) = 2 + 3 + getMaxScoreB arr
getMaxScoreB ("B Z":arr) = 3 + 6 + getMaxScoreB arr
getMaxScoreB ("C X":arr) = 2 + 0 + getMaxScoreB arr
getMaxScoreB ("C Y":arr) = 3 + 3 + getMaxScoreB arr
getMaxScoreB ("C Z":arr) = 1 + 6 + getMaxScoreB arr

-- ! Solution A: 11666
-- ! Solution B: 12767