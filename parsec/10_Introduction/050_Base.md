## [Write Yourself a Scheme in 48 Hours](https://en.wikibooks.org/wiki/Write_Yourself_a_Scheme_in_48_Hours/First_Steps)


~~~ {.haskell}
import Text.Parsec
type Parser a = Parsec String () a
~~~

~~~ {.haskell}
symbol :: Parser Char
symbol = oneOf "!#$%&|*+-/:<=>?@^_~"
~~~

~~~ {.haskell}
readExpr :: String -> String
readExpr input = case parse symbol "lisp" input of
    Left err  -> "No match: " ++ show err
    Right val -> "Found: " ++ show val
~~~
