proc getFileContentsAsString*(fileName: string): string =
    let gotFile = open(fileName)

    return gotFile.readAll

proc getFileLines*(filename: string): seq[string] =
    let gotFile = open(fileName)

    var mainSeq: seq[string] = @[]

    for line in gotFile.lines:
        mainSeq.add(line)

    return mainSeq

