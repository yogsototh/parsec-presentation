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

## Scheme

[Write Yourself a Scheme in 48 hours](https://en.wikibooks.org/wiki/Write_Yourself_a_Scheme_in_48_Hours)

Remember from text to data structure. Our data structure:

``` haskell
data LispVal =    Atom String
                | List [LispVal]
                | DottedList [LispVal] LispVal
                | Number Integer
                | String String
                | Bool Bool
```

## Parse String

``` haskell
parseString :: Parser LispVal
parseString = do
    char '"'
    x <- many (noneOf "\"")
    char '"'
    return (String x)
```

```
-- parseString on '"toto"'
(String "toto") :: LispVal
-- parseString on '" hello"'
(String " hello") :: LispVal
```

## Parse Atom

``` haskell
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
```

## Test `parseAtom`

```
-- parseAtom on '#t'
(Bool True) :: LispVal
-- parseAtom on '#f'
(Bool False) :: LispVal
-- parseAtom on 'some-atom'
(Atom "some-atom") :: LispVal
```

## Parse Number

``` haskell
parseNumber :: Parser LispVal
parseNumber = Number . read <$> many1 digit
```

```
-- parseNumber on '18'
Number 18 :: LispVal
-- parseNumber on '188930992344321234'
Number 188930992344321234 :: LispVal
```

## Compose all parsers

``` haskell
parseExpr :: Parser LispVal
parseExpr = parseAtom
            <||> parseString
            <||> parseNumber
```

## Test the parser

````
-- parseExpr on '188930992344321234'
Number 188930992344321234 :: LispVal
-- parseExpr on '#t'
Bool True :: LispVal
-- parseExpr on 'just-some-word'
Atom "just-some-word" :: LispVal
-- parseExpr on '%-symbol-start'
Atom "%-symbol-start" :: LispVal
-- parseExpr on '"a String"'
String "a String" :: LispVal
````

## Recursive Parsers

``` haskell
parseList :: Parser LispVal
parseList = List <$>
    (char '(' *> sepBy parseExpr' spaces <* char ')' )

parseExpr' :: Parser LispVal
parseExpr' = parseAtom
             <||> parseString
             <||> parseNumber
             <||> parseList
```

## Test Parse List

```
-- parseExpr' on '(foo (bar baz))'
List [Atom "foo",List [Atom "bar",Atom "baz"]] :: LispVal

-- parseExpr' on '(foo (bar)'
"parseExpr'" (line 1, column 11):
unexpected end of input
expecting white space, letter, "\"", digit, "(" or ")"

-- parseExpr' on '(((foo)) bar)'
List [List [List [Atom "foo"]],Atom "bar"] :: LispVal
```

## Conclusion

So Parser are more powerful than regular expression.  
Parsec make it very easy to use.  
Easy to read and to manipulate.  

Notice how you could use parser as any other object in Haskell.
You could `mapM` them for example.

Any question?
