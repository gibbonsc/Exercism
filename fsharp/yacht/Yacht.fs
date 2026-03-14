module Yacht

type Category = 
    | Ones
    | Twos
    | Threes
    | Fours
    | Fives
    | Sixes
    | FullHouse
    | FourOfAKind
    | LittleStraight
    | BigStraight
    | Choice
    | Yacht

type Die =
    | One = 1
    | Two = 2
    | Three = 3
    | Four = 4
    | Five = 5
    | Six = 6

let scoreYacht (dice : Die List) =
    let compareDice (pair : (Die * Die)) : bool =
        (=) (fst pair) (snd pair)
    let matchAllDice : bool =
        List.pairwise dice
        |> List.map compareDice
        |> List.fold (&&) true
    if matchAllDice then 50 else 0

let scoreFaces (face : int) (dice : Die list) =
    dice
    |> match face with
        // zero argument scores all dice
        | 0 -> id
        // nonzero argument scores only matching faces
        | _ -> List.filter (fun die -> face = (int die))
    |> List.fold (fun acc die -> acc + (int die)) 0

let profileDice (dice : Die list) : int array array =
    dice
    |> List.fold
        (fun (counts : int array array) (d : Die) ->
            // increment a counter, deliver updated counters
            let arrayIndex = (int d) - 1
            counts.[arrayIndex].[1] <-
                counts.[arrayIndex].[1] + 1
            counts
        )
        [| [| 1; 0 |]; [| 2; 0 |]; [| 3; 0 |];
           [| 4; 0 |]; [| 5; 0 |]; [| 6; 0 |]; |]
    |> Array.filter
        (fun (count : int array) ->
            count[1] > 0
        )

let scoreFullHouse (dice : Die list) : int =
    let profile = profileDice dice
    match profile.Length with
    | 2 ->
        if profile.[0].[1] = 2 && profile.[1].[1] = 3 ||
            profile.[0].[1] = 3 && profile.[1].[1] = 2 then
            scoreFaces 0 dice
        else
            0
    | _ -> 0

let scoreFourOfAKind (dice : Die list) : int =
    let profile = profileDice dice
    let faceToScore =
        match profile.Length with
        | 1 ->
            profile.[0].[0]
        | 2 ->
            if profile[0].[1] = 4 then
                profile.[0].[0]
            elif profile[1].[1] = 4 then
                profile.[1].[0]
            else
                0
        | _ -> 0
    4 * faceToScore

let scoreBigStraight (dice : Die list) : int =
    let profile = profileDice dice
    match profile.Length with
    | 5 ->
        if profile.[0].[0] = 2 && profile[4].[0] = 6 then
            30
        else
            0
    | _ -> 0

let scoreLittleStraight (dice : Die list) : int =
    let profile = profileDice dice
    match profile.Length with
    | 5 ->
        if profile.[0].[0] = 1 && profile[4].[0] = 5 then
            30
        else
            0
    | _ -> 0

let score category (dice : Die list) =
    match category with
    | Yacht -> scoreYacht dice
    | Choice -> scoreFaces 0 dice
    | Ones -> scoreFaces 1 dice
    | Twos -> scoreFaces 2 dice
    | Threes -> scoreFaces 3 dice
    | Fours -> scoreFaces 4 dice
    | Fives -> scoreFaces 5 dice
    | Sixes -> scoreFaces 6 dice
    | FullHouse -> scoreFullHouse dice
    | FourOfAKind -> scoreFourOfAKind dice
    | LittleStraight -> scoreLittleStraight dice
    | BigStraight -> scoreBigStraight dice
