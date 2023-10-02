# zLib

zLib is a package for Nim that has useful methods and function

## API


### Getting the file as a string

Returns the whole file as a string.

```nim
getFileContentsAsString(fileName: string): string
```


### Getting the sequence of strings

Returns the file by each line, in a string

```nim
getFileLines(fileName: string): seq[string]
```

