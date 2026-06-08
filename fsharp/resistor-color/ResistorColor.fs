module ResistorColor

let colors: string list = [
    "black"; "brown"; "red"; "orange"; "yellow";
    "green"; "blue"; "violet"; "grey"; "white"
]

let colorCode (color: string): int =
    match List.tryFindIndex (fun x -> x = color) colors with
    | Some i -> i
    | None -> -1
