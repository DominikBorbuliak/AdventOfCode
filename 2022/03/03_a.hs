import Data.List
import Data.Maybe

main = do
    content <- readFile "03_input.txt"
    print $ sum $ map (getIntersectionCharValue) (lines content)

alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

getIntersectionCharValue :: [Char] -> Int
getIntersectionCharValue str =  let cmpTpl = (getComparements "" str) in
    (1+) $ fromJust $ elemIndex ((intersect (fst cmpTpl) (snd cmpTpl)) !! 0) alphabet

getComparements :: [Char] -> [Char] -> ([Char], [Char])
getComparements [] (x2:cmp2) = getComparements [x2] cmp2
getComparements (x1:cmp1) (x2:cmp2) = if length cmp1 == length cmp2
    then ((x1:cmp1), (x2:cmp2))
    else getComparements (x1:cmp1 ++ [x2]) (cmp2)

-- ! Solution: 8153