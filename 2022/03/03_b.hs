import Data.List
import Data.Maybe

main = do
    content <- readFile "03_input.txt"
    print $ (getBadgesValue) $ (lines content)

alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

getBadgesValue :: [String] -> Int
getBadgesValue (x:y:z:arr) = ((1+) $ fromJust $ elemIndex ((x `intersect` y `intersect` z) !! 0) alphabet)
    + if length arr == 0 then 0 else getBadgesValue arr

-- ! Solution: 2342