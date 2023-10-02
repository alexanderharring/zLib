proc getFileConents*(fileName: string): string =
    let gotFile = open(fileName)

    return gotFile.readAll