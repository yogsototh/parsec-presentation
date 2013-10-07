{-# LANGUAGE DeriveDataTypeable #-}
import Control.Applicative hiding (many, (<|>))
import Text.Parsec
import Data.Typeable
import Control.Monad (guard)

type Parser a = Parsec String () a

data LispVal =    Atom String
                | List [LispVal]
                | DottedList [LispVal] LispVal
                | Number Integer
                | String String
                | Bool Bool
                deriving (Show, Typeable)

parseString :: Parser LispVal
parseString = do
    char '"'
    x <- many (noneOf "\"")
    char '"'
    return (String x)

symbol :: Parser Char
symbol = oneOf "!#$%&|*+-/:<=>?@^_~"

parseAtom :: Parser LispVal
parseAtom = do
    first <- letter <|> symbol
    rest <- many (letter <|> digit <|> symbol)
    let atom = first:rest
    return $ case atom of
                "#t" -> Bool True
                "#f" -> Bool False
                _    -> Atom atom

parseNumber :: Parser LispVal
parseNumber = Number . read <$> many1 digit

parseExpr :: Parser LispVal
parseExpr = parseAtom
            <||> parseString
            <||> parseNumber

(<||>) parser1 parser2 = try parser1 <|> parser2


parseList :: Parser LispVal
parseList = List <$>
    (char '(' *> sepBy parseExpr' spaces <* char ')' )

parseExpr' :: Parser LispVal
parseExpr' = parseAtom
             <||> parseString
             <||> parseNumber
             <||> parseList
main :: IO ()
main = do
    -- test parseString "parseString" "\"toto\""
    -- test parseString "parseString" "\" hello\""
    -- test parseAtom "parseAtom" "#t"
    -- test parseAtom "parseAtom" "#f"
    -- test parseAtom "parseAtom" "some-atom"
    -- test parseNumber "parseNumber" "18"
    -- test parseNumber "parseNumber" "188930992344321234"
    -- test parseExpr "parseExpr" "188930992344321234"
    -- test parseExpr "parseExpr" "#t"
    -- test parseExpr "parseExpr" "just-some-word"
    -- test parseExpr "parseExpr" "%-symbol-start"
    -- test parseExpr "parseExpr" "\"a String\""
    test parseExpr' "parseExpr'" "(foo (bar baz))"
    test parseExpr' "parseExpr'" "(foo (bar)"
    test parseExpr' "parseExpr'" "(((foo)) bar)"

test :: (Typeable a, Show a) => Parser a -> String -> String -> IO ()
test parser description string = do
    putStrLn $ "-- " ++ description ++ " on '" ++ string ++ "'"
    let res = parse parser description string
    case res of
        Left  err   -> print err
        Right value -> putStr $ show value ++ " :: " ++ show (typeOf value)
    putStrLn ""

