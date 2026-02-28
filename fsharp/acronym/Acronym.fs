module Acronym

open System

let separate (phrase:string) : string array = 
    phrase.Split(
        [| ' '; '-' |],
        StringSplitOptions.RemoveEmptyEntries
    )

let initial (word:string) : string =
    let i = word.ToUpper().Chars(0)
    match i with
    | '_' -> string (word.ToUpper().Chars(1))
    | _ -> string i

let abbreviate (phrase:string) : string =
    separate phrase 
    |> Array.toList
    |> List.map initial
    |> String.concat ""
