module ReverseString

open System

let reverse (input: string): string = // failwith "You need to implement this function."
    input
    |> Seq.toArray
    |> Array.rev
    |> String
