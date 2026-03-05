module Anagram

let findAnagrams (sources : string list) (target : string) : string list =
    let sortedString (arg : string) : string =
        // separate into array of characters
        arg.ToCharArray()
        // sort them in-place
        |> Array.sort
        // join sorted characters back into string
        |> System.String
    let loweredTarget = target.ToLower()
    let sortedTarget = sortedString loweredTarget
    let isAnagramMatch (source : string) : bool =
        let loweredSource = source.ToLower()
        let sortedSource = sortedString loweredSource
        sortedTarget = sortedSource && loweredTarget <> loweredSource
    let results = List.filter isAnagramMatch sources
    results
