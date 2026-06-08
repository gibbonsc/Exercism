module TwoFer

let twoFer (input: string option): string =
    let recipient =
        match input with
        | Some s -> s
        | None -> "you"
    $"One for {recipient}, one for me."
