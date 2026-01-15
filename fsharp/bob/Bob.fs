module Bob

let response (input: string): string = // failwith "You need to implement this function."
    let trimmedInput = input.Trim()
    if trimmedInput.Length = 0 then
        "Fine. Be that way!"
    else
        let lastChar =
            trimmedInput
            |> Seq.toArray
            |> Array.last
        let trimmedHasUpper =
            -1 <> trimmedInput.IndexOfAny( [| 'A' .. 'Z' |] )
        let trimmedUpper =
            trimmedInput.ToUpper()
        let shouting =
            trimmedHasUpper && (trimmedUpper = trimmedInput)
        if lastChar = '?' && not shouting then
            "Sure."
        elif lastChar <> '?' && shouting then
            "Whoa, chill out!"
        elif lastChar = '?' && shouting then
            "Calm down, I know what I'm doing!"
        else
            "Whatever."
