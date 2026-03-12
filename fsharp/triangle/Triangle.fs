module Triangle

let boolToInt (b : bool) : int = if b then 1 else 0
let countEqualPairs (arg : float list) : int =
    [ (arg.[0] = arg.[1]); (arg.[0] = arg.[2]); (arg.[1] = arg.[2]) ]
    |> List.map boolToInt
    |> List.sum
let validateTriangleInequalities (triangle : float list) : bool =
    triangle.[0] > 0.0 &&
    triangle.[1] > 0.0 &&
    triangle.[2] > 0.0 &&
    triangle.[0] + triangle.[1] >= triangle.[2] &&
    triangle.[1] + triangle.[2] >= triangle.[0] &&
    triangle.[0] + triangle.[2] >= triangle.[1]
let equilateral (triangle : float list) : bool =
    validateTriangleInequalities triangle &&
    countEqualPairs triangle = 3
let isosceles (triangle : float list) : bool =
    validateTriangleInequalities triangle &&
    countEqualPairs triangle >= 1
let scalene (triangle : float list) : bool =
    validateTriangleInequalities triangle &&
    countEqualPairs triangle = 0

(*
    All test cases provided inputs as lists of three floats.
    If a test case featured two floats (two line segments)
    or four floats (quadrilateral), etc., then I suppose
    another input validation might have been needed, such as:

    if triangle.Length <> 3 then failwith "Invalid argument: length isn't 3"

    The exercise also waived away validation against degenerate triangles.
*)
