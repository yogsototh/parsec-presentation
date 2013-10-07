{-# LANGUAGE DeriveDataTypeable #-}
import Control.Applicative hiding (many, (<|>))
import Text.Parsec
import Data.Typeable
import Control.Monad (guard)

type Parser a = Parsec String () a

data IP = IP Int Int Int Int deriving (Show,Typeable)

parseIP :: Parser IP
parseIP = IP <$>
            number <*  char '.' <*>
            number <*  char '.' <*>
            number <*  char '.' <*>
            number

number :: Parser Int
number = do
    x <- read <$> many1 digit
    guard (0 <= x && x < 256) <?> "Number between 0 and 255 (here " ++ show x ++ ")"
    return (fromIntegral x)

main :: IO ()
main = do
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

