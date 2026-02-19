module Isogram

let isIsogram (str: string) : bool =
    // normalize to lowercase and cull non-letters
    let isLowerLetter (ch : char) : bool =
        (ch >= 'a') && (ch <= 'z')
    let lowers = Seq.filter isLowerLetter (str.ToLower())

    // to ensure there are no duplicates,
    //   sort then check adjacent letters
    let notSame (c1 : char, c2 : char) : bool =
        c1<>c2
    lowers
    |> Seq.sort
    |> Seq.pairwise
    |> Seq.forall notSame
