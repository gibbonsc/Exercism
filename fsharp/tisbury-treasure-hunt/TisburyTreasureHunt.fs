module TisburyTreasureHunt

let getCoordinate (line: string * string): string =
    snd line

let convertCoordinate (coordinate: string): int * char = 
    let coordinateChars: char array =
        coordinate
        |> Seq.toArray
    let (digitChar, letter) = coordinateChars.[0], coordinateChars.[1]
    let digit = int (digitChar - '0')
    digit,letter

let compareRecords (azarasData: string * string) (ruisData: string * (int * char) * string) : bool = 
    let azarasCoord = snd azarasData
    let (azarasDigit,azarasLetter) = convertCoordinate azarasCoord
    let (_, ruisCoord, _) = ruisData
    (azarasDigit = fst ruisCoord) && (azarasLetter = snd ruisCoord)

let createRecord (azarasData: string * string) (ruisData: string * (int * char) * string) : (string * string * string * string) =
    if compareRecords azarasData ruisData then
        let azarasTreasure = fst azarasData
        let (ruisLocation, _, ruisQuadrant) = ruisData
        (snd azarasData), ruisLocation, ruisQuadrant, azarasTreasure
    else
        "", "" ,"" ,""
