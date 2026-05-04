module RobotSimulator

type Direction = North | East | South | West
type Position = int * int
type Robot = { d: Direction; p: Position }

let create (direction: Direction) (position: Position): Robot =
    let r: Robot = {
        d = direction
        p = position
    }
    r

let move (instructions: string) (robot: Robot) =
    let oneMove (r: Robot) (perform: char) : Robot =
        let newDirection: Direction =
            match perform with
            | 'L' ->
                match r.d with
                | Direction.North -> Direction.West
                | Direction.East -> Direction.North
                | Direction.South -> Direction.East
                | Direction.West -> Direction.South
            | 'R' ->
                match r.d with
                | Direction.North -> Direction.East
                | Direction.East -> Direction.South
                | Direction.South -> Direction.West
                | Direction.West -> Direction.North
            | _ ->
                r.d
        let newPosition: (int * int) =
            if perform = 'L' || perform = 'R' then
                r.p
            else
                match newDirection with
                | Direction.North -> (fst r.p, (snd r.p) + 1)
                | Direction.East -> ((fst r.p) + 1, snd r.p)
                | Direction.South -> (fst r.p, (snd r.p) - 1)
                | Direction.West -> ((fst r.p) - 1, snd r.p)
        {
            d = newDirection
            p = newPosition
        }
    let iChars: char array =
        instructions
        |> Seq.toArray
    iChars
    |> Array.fold oneMove robot
