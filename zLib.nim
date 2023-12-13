import std/strutils
import math

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
    node* = ref object
        value*: int
        tag*: string
        connections*: seq[node]
        weightedConnections*: seq[(node, int)]

proc connect*(parent: node, child: node) =
    parent.connections.add(child)

proc newNode*(): node =
    return node()

proc setValue*(n: node, val: int) =
    n.value = val

proc setValue*(n: node, val: string) =
    n.tag = val

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

proc max*(nums: varargs[int]): int =
    result = nums[0]

    for n in nums:
        if n > result:
            result = n

proc echobin*(x: int) =
    if x == 0:
        echo "0"
    else:
        let length = floor(log2((float64)x)) + 1

        echo x.toBin((int)length)

proc binInt*(x: int): int =
    if x == 0:
        return 0
    else:
        let length = floor(log2((float64)x)) + 1

        return parseInt(x.toBin((int)length))

proc createGrid*(x: int, y: int): seq[seq[int]] =
    var mainList: seq[seq[int]]

    for xx in 1..x:
        var cList: seq[int]
        for yy in 1..y:
            cList.add(0)
        mainList.add(cList)

    return mainList

proc getCharSubsets*(mainString: string, excludeEmpty = false): seq[string] =

    proc findSubset(mainArray: string, resultArray: var seq[string], subset: var string, index: int) =
        resultArray.add(subset)

        for i in index..(mainArray.len - 1):

            subset &= mainArray[i]

            findSubset(mainArray, resultArray, subset, i + 1)

            subset = subset[0..^2]



    var subset = ""
    var resultArray: seq[string] = @[]
    var index = 0

    findSubset(mainString, resultArray, subset, index)

    if excludeEmpty:
        for ind, st in resultArray:
            if st == "":
                resultArray.delete(ind)
                break

    return resultArray

iterator choose*[T](a: openarray[T], num_choose: int): seq[T] =
  var
    chosen = newSeqOfCap[T](num_choose)
    i = 0
    i_stack = newSeqOfCap[int](num_choose)
  
  while true:
    if chosen.len == num_choose:
      yield chosen
      discard chosen.pop()
      i = i_stack.pop() + 1
    elif i != a.len:
      chosen.add(a[i])
      i_stack.add(i)
      inc i
    elif i_stack.len > 0:
      discard chosen.pop()
      i = i_stack.pop() + 1
    else:
      break