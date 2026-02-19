module Pangram
// another attempt: solve it without calling any .NET String class methods...

let isPangram (input: string): bool =
    // normalize 'A' through 'Z' in inputs to lowercase
    let lower (ch : char) : char =
        match ch with
        | ch when (ch >= 'A') && (ch <= 'Z') ->
            char (int ch + 32)
        | _ -> ch
    let lowerInput : string =
        String.map lower input

    let present (ch : char) : bool =
        // check whether ch is present in input
        let compareChars (c : char) : bool =
            c=ch
        String.exists compareChars lowerInput
        // here's a confusing solution that does the same thing in one line:
        // String.exists ((fun (c : char) -> c = ch) : char -> bool) lowerInput

    seq { 'a' .. 'z' }
    // check whether every letter is present
    |> Seq.forall present
