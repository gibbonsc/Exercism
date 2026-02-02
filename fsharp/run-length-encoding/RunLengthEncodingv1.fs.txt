module RunLengthEncoding
(* NOT functional-style! The tests pass,
   but I want to try again with immutables
   and without imperative structures.*)

let encode (input : string) =
    if input.Length < 2 then
        input
    else
        let charArray = input.ToCharArray()
        let mutable result = ""
        let mutable runner = charArray.[0]
        let mutable counter = 1
        let pairs = 
            charArray
            |> Array.pairwise
        let same (pair: (char * char)) : bool =
            let (c1,c2) = pair
            c1=c2
        for p in pairs do
            if same p then
                counter <- counter + 1
            else
                let (c1 : char, c2 : char) = p
                runner <- c2
                if counter>1 then
                    result <- result + counter.ToString() + c1.ToString()
                    counter <- 1
                else
                    result <- result + c1.ToString()
        if counter>1 then
            result <- result + counter.ToString() + runner.ToString()
        else
            result <- result + runner.ToString()
        result

let decode (input : string) : string = 
    if input.Length < 2 then
        input
    else
        let numerals = [ '0'; '1'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9']
        let isNumeral (c : char) : bool =
            List.exists (fun h -> c = h) numerals
        let charArray = input.ToCharArray()
        let mutable result = ""
        let mutable counter = 0
        for ch in charArray do
            if isNumeral ch then
                counter <- counter * 10
                counter <- counter + (int ch - int '0')
            else
                if counter = 0 then
                    counter <- 1
                result <- result + String.replicate counter (string ch)
                counter <- 0
        result
