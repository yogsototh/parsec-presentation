## Monadic style

``` haskell
number :: Parser String
number = many1 digit

number' :: Parser Int
number' = do
    string_of_number <- many1 digit
    return (read string_of_number)
```

``` haskell
"32" :: [Char]  -- number on "32"
32   :: Int     -- number' on "32"
```
