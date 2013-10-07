import Control.Applicative hiding (many, (<|>))
import Text.Parsec
import Data.Typeable

type Parser a = Parsec String () a

sa :: Parser String
sa = concat3 <$> string "a" <*> sa <*> string "b" <|> string ""
    where
        concat3 x y z = x ++ y ++ z

s :: Parser String
s = s' <|> epsilon

epsilon = string ""

s' :: Parser String
s' = do
    a <- string "a"
    mid <- s
    b <- string "b"
    return (a ++ mid ++ b)

main :: IO ()
main = do
    test s "S" "aaabbb"
    test s "S" "aabbb"
    test s "S" "aab"
    test s "S" ""
    test sa "S'" "aaabbb"
    test sa "S'" "aabbb"
    test sa "S'" "aab"
    test sa "S'" ""
    test parseIP "parseIP" "123.32.80.113"
    test parseIP "parseIP" "823.32.80.113"

test :: (Typeable a, Show a) => Parser a -> String -> String -> IO ()
test parser description string = do
    putStrLn $ "-- " ++ description ++ " on '" ++ string ++ "'"
    let res = parse parser description string
    putStr $ show res
    case res of
        Left  err   -> return ()
        Right value -> putStr $ " :: " ++ show (typeOf value)
    putStrLn ""

