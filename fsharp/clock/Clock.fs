module Clock

let create (hours : int) (minutes : int) : (int * int) =
    let totalM = hours * 60 + minutes  // total minutes
    let totalMinutes =
        if totalM >= 0 then
            totalM
        else  // roll negative minutes up
              // into positive day minute mark
            (24 * 60) - (-totalM % (24 * 60))
    // apply clockface modular arithmetic
    let hourHand = (totalMinutes / 60) % 24
    let minuteHand = totalMinutes % 60
    (hourHand, minuteHand)

let add (minutes : int) (clock : (int * int)) : (int * int) =
    let hourHand, minuteHand = clock
    create 0 (hourHand * 60 + minuteHand + minutes)

let subtract (minutes : int) (clock : (int * int)) : (int * int) =
    add (- minutes) clock

let display (clock : (int * int)) : string = 
    let handString (hand : int) : string =
        match hand with
        | hand when hand < 10 -> ("0" + string hand)
        | _ -> string hand

    let hourHand, minuteHand = clock
    let hourString =
        handString hourHand
    let minuteString =
        handString minuteHand
    hourString + ":" + minuteString
