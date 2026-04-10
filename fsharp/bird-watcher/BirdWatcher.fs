module BirdWatcher

let lastWeek: int[] =
    [| 0; 2; 5; 3; 7; 8; 4 |]

let yesterday(counts: int[]): int =
    let dayCount = Array.length lastWeek
    counts[dayCount - 2]

let total(counts: int[]): int =
    counts
    |> Array.sum

let dayWithoutBirds(counts: int[]): bool =
    let orNoBirds (b : bool) (count : int) : bool =
        b || (count = 0)
    counts
    |> Array.fold orNoBirds false

let incrementTodaysCount(counts: int[]): int[] =
    let dayCount = Array.length counts
    let todayCount = counts.[dayCount - 1]
    counts.[dayCount - 1] <- todayCount + 1
    counts

let unusualWeek(counts: int[]): bool =
    match counts with
    // zeroes on even days
    | [| _; 0; _; 0; _; 0; _ |] -> true
    // tens on even days
    | [| _; 10; _; 10; _; 10; _ |] -> true
    // fives on odd days
    | [| 5; _; 5; _; 5; _; 5 |] -> true
    | _ -> false
