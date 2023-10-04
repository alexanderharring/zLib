# zLib

zLib is a package for Nim that has useful methods and function

## API


### Getting the file as a string

Returns the whole file as a string.

```nim
getFileContentsAsString(fileName: string): string
```


### Getting the file as a sequence of strings

Returns the file by each line, in a string

```nim
getFileLines(fileName: string): seq[string]
```

### Parsing a string of nested lists

Returns a custom list type

```nim
parseSeq*(toBeParsed: string, delim: string = ","): list =
```


