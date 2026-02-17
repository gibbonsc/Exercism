module Leap

let leapYear (year: int): bool =
    let divisibleBy4 : bool =
        0 = (year % 4)
    let divisibleBy100 : bool =
        0 = (year % 100)
    let divisibleBy400 : bool =
        0 = (year % 400)
    if divisibleBy100 then
        divisibleBy400
    else
        divisibleBy4
