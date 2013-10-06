import Control.Applicative hiding (many, (<|>))
import Text.Parsec
import Data.Typeable

type Parser a = Parsec String () a

whitespaces :: Parser String
whitespaces = many (oneOf "\t ")

quantityStr :: Parser String
quantityStr = many1 digit

-- Monadic style
-- quantity :: Parser Int
-- quantity = do
--     stringOfDigits <- many1 digit
--     return (read stringOfDigits)

-- Applicative style
quantity :: Parser Int
quantity = read <$> many1 digit

-- remove spaces at the begining and the end of a parser
-- Applicative FTW!
lexeme :: Parser a -> Parser a
lexeme parser = whitespaces *> parser <* whitespaces

main :: IO ()
main = do
    test (lexeme quantityStr) "lexeme quantityStr" "  \t 32  "
    test (lexeme quantity) "lexeme quantity" "  \t 32  "

test :: (Typeable a, Show a) => Parser a -> String -> String -> IO ()
test parser description string = do
    putStrLn $ "-- " ++ description ++ " on '" ++ string ++ "'"
    let res = parse parser description string
    putStr $ show res
    case res of
        Left  err   -> return ()
        Right value -> putStr $ " :: " ++ show (typeOf value)
    putStrLn ""

