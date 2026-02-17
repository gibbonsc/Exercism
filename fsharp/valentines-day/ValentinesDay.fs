module ValentinesDay
// revised: essentially the same algorithm, but
//  improved names (let bindings, declarations etc.)
//  and rewrote comments according to learning mindset

type Approval =
    | Yes
    | No
    | Maybe

type Cuisine =
    | Korean
    | Turkish

type Genre =
    | Crime
    | Horror
    | Romance
    | Thriller

type Activity =
    | BoardGame  // no associated data
    | Chill  // no associated data
    | Movie of Genre  // associated with a Genre
    | Restaurant of Cuisine  // associated with a Cuisine
    | Walk of int // associated with an int: distance to walk

let rateActivity (activity: Activity): Approval =
    match activity with

    // Movie: approve Romance, disapprove other genres
    | Movie g ->  // g is a Genre
        match g with
        | Romance -> Approval.Yes
        | _ -> Approval.No  // disapprove Crime, Horror, Thriller

    // Go out to eat: approve Korean, tolerate Turkish
    | Restaurant c ->  // c is a Cuisine
        match c with
        | Korean -> Approval.Yes
        | Turkish -> Approval.Maybe

    // Go for a walk: approve up to 3, tolerate up to 5
    // many solutions do this with yet another match,
    // but I still used an if...elif chain.
    | Walk distance ->  // distance is an int
        if distance >= 5 then
            Approval.No
        elif distance >= 3 then
            Approval.Maybe
        else
            Approval.Yes

    // disapprove remaining Activity selections (BoardGame, Chill)
    | _ -> Approval.No
