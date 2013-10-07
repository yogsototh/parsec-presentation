## Useful definitions

`try` tries to parse and backtracks if it fails.

``` haskell
(<||>) parser1 parser2 = try parser1 <|> parser2
```

`lexeme`, just skip spaces.

``` haskell
lexeme parser = whitespaces *> parser <* whitespaces
```

