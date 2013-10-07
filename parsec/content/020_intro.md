## Parsing

Latin pars (ōrātiōnis), meaning part (of speech).

- **analysing a string of symbols**
- **formal grammar**.

## Parsing in Programming Languages

Complexity:

Method      Typical Example         Output Data Structure
----------- ----------------------  ---------------------
Splitting   CSV                     Array, Map
Regexp      email                   + Fixed Layout Tree
Parser      Programming language    + Most Data Structure

## Parser & culture

In Haskell Parser are really easy to use.

Generally:

- In most languages: **split** then **regexp** then **parse**
- In Haskell: **split** then **parse**

## Parsing Example

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

## Parser Libraries

In reality there are many choices:

----------------- ------------------------------
attoparsec        fast
Bytestring-lexing fast
Parsec 3          powerful, nice error reporting
----------------- ------------------------------

## Haskell Remarks (1)

spaces are meaningful

``` haskell
f x   -- ⇔ f(x) in C-like languages
f x y -- ⇔ f(x,y)
```

## Haskell Remarks (2)

Don't mind strange operators (`<*>`, `<$>`).  
Consider them like separators, typically commas.  
They are just here to deal with types.

Informally:

``` haskell
toto <$> x <*> y <*> z
    -- ⇔ toto x y z
    -- ⇔ toto(x,y,z) in C-like languages
```

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

## Comparison with Regexp (Parsec)

``` haskell
data IP = IP Word8 Word8 Word8 Word8
ip = IP <$>
       number <*  char '.' <*>
       number <*  char '.' <*>
       number <*  char '.' <*>
       number
number = do
    x <- read <$> many1 digit
    guard (0 <= x && x < 256)
    return (fromIntegral x)
```

## Comparison with Regexp (Perl Regexp)

``` perl
# remark: 888.999.999.999 is accepted
\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b

# exact but difficult to read
\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}
  (?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b
```

Also, regexp are _unityped_ by nature.

## Monadic style

``` haskell
number :: Parser String
number = many1 digit

number' :: Parser Int
number' = do
    -- digitString :: String
    digitString <- many1 digit
    return (read digitString)
```

``` haskell
"32" :: [Char]  -- number on "32"
32   :: Int     -- number' on "32"
```

## Combining Monadic style (S = aSb | ε)

``` haskell
s = (do
        a <- string "a"
        mid <- s
        b <- string "b"
        return (a ++ mid ++ b)
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

## Combining Applicative style (S = aSb | ε)

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
