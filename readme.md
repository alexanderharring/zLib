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
parseSeq(toBeParsed: string, delim: string = ","): list =
```


### Creating a new node

Creates a new node with value type int

```nim
newNode(val: int): node =
```

### Showing the node connections

Prints out all the other nodes that the node is connected to (weight and unweighted)

```nim
showConnections(n: node) =
```

### Adding a node

Adds a node with no weighting to the parent node

```nim
connect(parent: node, child: node) =
```


### Adding a weighted node

Adds a weighted node to the parent node
```nim
connectWeighted(parent: node, child: node, weight: int) =
```

