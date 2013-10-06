## Monadic style

``` haskell
isolatedNumber :: Parser String
isolatedNumber = do
    _ <- whitespaces
    n <- number
    _ <- whitespaces
    return n
```

``` haskell
Right "32"      -- isolatedNumber on "   \t 32 "
```
