import std/strutils

type
    list = ref object
        sublist: seq[list]
        value: int
        isvalue: bool
        iscomma: bool
        parent: list

proc getFileContentsAsString*(fileName: string): string =
    let gotFile = open(fileName)

    return gotFile.readAll

proc getFileLines*(filename: string): seq[string] =
    let gotFile = open(fileName)

    var mainSeq: seq[string] = @[]

    for line in gotFile.lines:
        mainSeq.add(line)

    return mainSeq

proc output*(val: string) =
    stdout.write val
    stdout.flushFile()


proc parseSeq*(toBeParsed: string, delim: string = ","): list =
    proc newValue(val: int): list =
        return list(value: val, isvalue: true)

    proc newList(): list =
        return list(isvalue: false)

    proc add(l: list, val: list) =
        l.sublist.add(val)
        val.parent = l

    proc newComma(): list =
        return list(isvalue: true, iscomma: true)

    proc get(l: list, ind: int): list =
        return l.sublist[ind]

    proc high(l: list): int =
        if l.sublist.len == 0:
            return 0
        else:
            l.sublist.len - 1

    proc recursiveLastIndex(scope: int, ls: list): list =

        let lastIndex = ls.high

        if ls.sublist.len == 0:
            return ls

        if ls.isvalue:
            return ls.parent
        
        if scope > 0:

            let lastVal = ls.get(lastIndex)
            return recursiveLastIndex(scope - 1, lastVal)
        else:
            return ls

    var totalList = newList()
    # totalList.value = 123

    var currentNumber = ""
    var currentScope = 0

    for ind, charact in toBeParsed:
        if charact == '[':
            
            let placement = recursiveLastIndex(currentScope, totalList)
            
            var newListVal = newList()

            placement.add(newListVal)
            currentScope += 1   
            # echo ""

        elif charact == ']':

            currentScope -= 1
            # echo ""

        elif charact == ',':
            let placement = recursiveLastIndex(currentScope, totalList)

            placement.add(newComma())

        else:
            let placement = recursiveLastIndex(currentScope, totalList)

            let returnedInteger = parseInt($charact)

            placement.add(newValue(returnedInteger))
            # currentNumber &= $charact

    # echo currentScope
    return totalList

proc visualiseList*(ls: list) =

    proc recursiveShow(partialList: list) =

        output("[")
        for tinyList in partialList.sublist:
            # echo "len", tinyList.sublist.len
            # echo tinyList.isvalue
            if tinyList.isvalue:

                if tinyList.iscomma:
                    output(",")
                else:
                    output($tinyList.value)
                
            else:
                # echo ""
                # echo "here"
                recursiveShow(tinyList)

        output("]")

    recursiveShow(ls.sublist[0])


type
    node = ref object
        value: int
        connections: seq[node]
        weightedConnections: seq[(node, int)]

proc connect*(parent: node, child: node) =
    parent.connections.add(child)

proc newNode*(val: int): node =
    return node(value: val)

proc showConnections*(n: node) =
    # for nd in n.connections

    var mainS = "("

    for ind, subNode in n.connections:
        if ind == n.connections.high:
            mainS &= $ind & ": " & $subNode.value
        else:
            mainS &= $ind & ": " & $subNode.value & ", "

    if (n.connections.len > 0):
        mainS &= ")"
        echo "Unweighted Connections: "
        echo mainS

    var subS = "("

    for ind, subnode in n.weightedConnections:
        if ind == n.weightedConnections.high:
            subS &= $ind & ": {" & $subnode[0].value & " -> " & $subnode[1] & "}"
        else:
            subS &= $ind & ": {" & $subnode[0].value & " -> " & $subnode[1] & "}" & ", "

    if (n.weightedConnections.len > 0):
        subS &= ")"
        echo "Weighted Connections: "
        echo subS


proc connectWeighted*(parent: node, child: node, weight: int) =
    parent.weightedConnections.add((child, weight))





