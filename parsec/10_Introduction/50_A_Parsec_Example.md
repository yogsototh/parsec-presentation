## A Parsec Example

``` haskell
whitespaces = many (oneOf "\t ")
number = many1 digit
```

``` haskell
Right "   \t "  -- whitespaces on "   \t "
Right ""        -- whitespaces on "32"
Right "32"      -- number on "32"

-- number on "   \t 32  "
Left "number" (line 1, column 1):
unexpected " "
expecting digit
```
