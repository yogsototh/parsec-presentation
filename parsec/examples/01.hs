import Data.Typeable
import Text.Parsec
type Parser a = Parsec String () a

whitespaces :: Parser String
whitespaces = many (oneOf "\t ")

number :: Parser String
number = many1 digit

number' :: Parser Int
number' = do
    string_of_number <- many1 digit
    return (read string_of_number)

isolatedNumber = do
    _ <- whitespaces
    n <- number
    _ <- whitespaces
    return n

-- remove spaces at the begining and the end of a parser
lexeme :: Parser a -> Parser a
lexeme parser = do
    _ <- whitespaces
    res <- parser
    _ <- whitespaces
    return res

main :: IO ()
main = do
    test whitespaces "whitespaces" "  "
    test whitespaces "whitespaces" "32"
    test number "number" "32"
    test number "number" "  32  "
    test number' "number'" "32"
    test number' "number'" "  32  "
    test isolatedNumber "isolatedNumber" "  32  "
    test isolatedNumber "isolatedNumber" " foo  "
    test (lexeme number) "lexeme number" "  32  "

test :: (Typeable a, Show a) => Parser a -> String -> String -> IO ()
test parser description string = do
    putStrLn $ "-- " ++ description ++ " on '" ++ string ++ "'"
    let res = parse parser description string
    case res of
        Left  err   -> print err
        Right value -> putStr $ (show value) ++ " :: " ++ show (typeOf value)
    putStrLn "\n"
