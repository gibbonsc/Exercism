module Meetup

open System

type Week = First | Second | Third | Fourth | Last | Teenth

let weekdayOffset (weekday: DayOfWeek) (following: DayOfWeek): int =
    // helper function: arithmetic with DayOfWeek enum values
    (int following - int weekday + 7) % 7

let meetup year month week dayOfWeek: DateTime =
    let anchorDay =
        match week with
        | Teenth -> DateTime(year, month, 13)
        | Last -> DateTime(year, month, 1).AddMonths(1).AddDays(-7)
        | First -> DateTime(year, month, 1)
        | Second -> DateTime(year, month, 8)
        | Third -> DateTime(year, month, 15)
        | Fourth -> DateTime(year, month, 22)
    let anchorWeekday = anchorDay.DayOfWeek
    anchorDay.AddDays(weekdayOffset anchorWeekday dayOfWeek)
