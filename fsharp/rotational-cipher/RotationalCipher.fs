module RotationalCipher

let rotate shiftKey text =
    let rotchar (s : int) (c : char) : char = 
        match c with
        | c when ('a' <= c && c <= 'z') ->
            char (((int (c - 'a') + s) % 26) + int 'a')
        | c when ('A' <= c && c <= 'Z') ->
            char (((int (c - 'A') + s) % 26) + int 'A')
        | _ -> c
    Seq.map (rotchar shiftKey) text
    |> Seq.toArray
    |> System.String
