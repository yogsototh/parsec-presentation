## Parsing

Latin pars (ōrātiōnis), meaning part (of speech).

- **analysing a string of symbols**
- **formal grammar**.

## Parsing Example (1)

From String:

``` haskell
(1+3)*(1+5+9)
```

To data structure:

![AST](parsec/img/mp/AST.png)\

## Parsec

> Parsec lets you construct parsers by combining high-order Combinators
> to create larger expressions.
>
> Combinator parsers are written and used within the same programming language
> as the rest of the program.
>
> The parsers are first-class citizens of the languages [...]"

## Parsec(s)

In reality there is many choices:

    - attoparsec: fast
    - Bytestring-lexing: fast
    - Parsec 3: powerful, nice error reporting

## A Parsec Example

``` haskell
whitespaces = many (oneOf "\t ")
number = many1 digit
symbol = oneOf "!#$%&|*+-/:<=>?@^_~"
```

``` haskell
"   \t "  -- whitespaces on "   \t "
""        -- whitespaces on "32"
"32"      -- number on "32"

-- number on "   \t 32  "
"number" (line 1, column 1):
unexpected " "
expecting digit
```

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

## Combining Monadic style

$$ S = aSb | ε $$

``` haskell
s = (do
        a <- char 'a'
        mid <- S
        b <- char 'b'
        return (a:mid) ++ b:[]) 
    <|> string ""

```

``` haskell
""          -- s on ""
"aaabbb"    -- s on "aaabbb"
"aabb"      -- s on "aabbb"
-- s on "aaabb"
S (line1 1, column 4):
unexpected end of input
expecting "b"
```

## Applicative style

$$ S = aSb | ε $$

``` haskell
s = concat3 <$> string "a" <*> s <*> char "b"
    <|> string ""
    where
        concat3 x y z = x ++ y ++ z
```

## Applicative Style usefull with Data types

``` haskell
data IP = IP Int Int Int Int

parseIP = IP <$>
            number <*  char '.' <*>
            number <*  char '.' <*>
            number <*  char '.' <*>
            number

monadicParseIP = do
    d1 <- number
    char '.'
    d2 <- number
    char '.'
    d3 <- number
    char '.'
    d4 <- number
    return (IP d1 d2 d3 d4)
```

## Write number correctly

``` haskell
number :: Parser Int
number = do
    x <- read <$> many1 digit
    guard (0 <= x && x < 256) <?>
        "Number between 0 and 255 (here " ++ show x ++ ")"
    return (fromIntegral x)
```

``` haskell
>>> test parseIP "parseIP" "823.32.80.113"
"parseIP" (line 1, column 4):
unexpected "."
expecting digit or Number between 0 and 255 (here 823)
```
