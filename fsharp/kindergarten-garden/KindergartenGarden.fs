module KindergartenGarden

type Plant =
| NoPlant
| Violets
| Radishes
| Grass
| Clover

let encodingToPlant (encoding : char) : Plant =
    match encoding with
    | 'V' -> Plant.Violets
    | 'R' -> Plant.Radishes
    | 'G' -> Plant.Grass
    | 'C' -> Plant.Clover
    | _ -> Plant.NoPlant

let plants (diagram : string) (student : string) =
    let initial : char =
        student.[0]
    let rows : string array =
        diagram.Split("\n")
    let index : int =
        int (initial - 'A')
    [
        encodingToPlant rows.[0].[ 2 * index ]
        encodingToPlant rows.[0].[ 2 * index + 1 ]
        encodingToPlant rows.[1].[ 2 * index ]
        encodingToPlant rows.[1].[ 2 * index + 1 ]
    ]
