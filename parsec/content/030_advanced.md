## So

- combination of simple parsers
- error messages with `(<?>)`
- embed result in data type using Applicative style
- Not shown, use another monad with the parser

Time to do something cool

## A Simple DSL

Let's write a minimal DSL

## Useful definitions

`try` tries to parse and backtracks if it fails.

``` haskell
(<||>) parser1 parser2 = try parser1 <|> parser2
```

`lexeme`, just skip spaces.

``` haskell
lexeme parser = whitespaces *> parser <* whitespaces
```

## Data Structure

Remember from text to data structure

``` haskell
data Tree = Node Element [Tree]
```
