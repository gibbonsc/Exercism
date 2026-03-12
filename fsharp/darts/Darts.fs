module Darts

let score (x: double) (y: double): int =
    let hypotSq = x * x + y * y
    match hypotSq with
    | hypotSq when hypotSq <= 1.0 -> 10
    | hypotSq when hypotSq <= 25.0 -> 5
    | hypotSq when hypotSq <= 100.0 -> 1
    | _ -> 0
