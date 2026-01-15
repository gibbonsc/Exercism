module DifferenceOfSquares

let squareOfSum (number: int): int = // failwith "You need to implement this function."
    let sum =
        (..) 0 number
        |> Seq.sum
    sum * sum

let sumOfSquares (number: int): int = // failwith "You need to implement this function."
    (..) 0 number
    |> Seq.map (fun n -> n * n)
    |> Seq.sum

let differenceOfSquares (number: int): int = // failwith "You need to implement this function."
    (squareOfSum number) - (sumOfSquares number)
