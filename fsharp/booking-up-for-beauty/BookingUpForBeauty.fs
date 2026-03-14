module BookingUpForBeauty
open System.Text.RegularExpressions
open System

let schedule (appointmentDateDescription: string): DateTime =
    let pattern = @"
    (
        (?<month>  \d{1,2} ) \/    # month (1 or 2 digits) then slash
        (?<day>    \d{1,2} ) \/    # day (1 or 2 digits) then slash
        (?<year>   \d{4}   ) \s+   # year (4 digits), then whitespace
    |
        (?<month>  \w+     ) \s+   # month text then space
        (?<day>    \d{1,2} ) ,?\s* # day (1 or 2 digits) then opt. comma
        (?<year>   \d{4}   ) \s+   # year (4 digits), then whitespace
    )
        (?<hour>   \d{1,2} ) :     # hour (1 or 2 digits) then colon
        (?<minute> \d{2}   ) :     # minute (2 digits) then colon
        (?<second> \d{2}   )       # second (2 digits)
    "
    let matchObject = Regex.Match(
        appointmentDateDescription,
        pattern,
        RegexOptions.IgnorePatternWhitespace)
    if matchObject.Success then
        let matches = matchObject.Groups
        let monthString = matches.["month"].Value
        let parsedMonth =
            match monthString with
            | "January" -> 1
            | "February" -> 2
            | "March" -> 3
            | "April" -> 4
            | "May" -> 5
            | "June" -> 6
            | "July" -> 7
            | "August" -> 8
            | "September" -> 9
            | "October" -> 10
            | "November" -> 11
            | "December" -> 12
            | _ -> int monthString
        let year, month, day, hour, minute, second =
            int matches.["year"].Value,
            parsedMonth,
            int matches.["day"].Value,
            int matches.["hour"].Value,
            int matches.["minute"].Value,
            int matches.["second"].Value
        DateTime(year, month, day, hour, minute, second)
    else
        DateTime(0)

let hasPassed (appointmentDate: DateTime): bool =
    let rightNow = DateTime.Now
    appointmentDate < rightNow

let isAfternoonAppointment (appointmentDate: DateTime): bool =
    appointmentDate.Hour >= 12 && appointmentDate.Hour < 18

let description (appointmentDate: DateTime): string =
    let year, month, day, hour24, minute, second =
        appointmentDate.Year,
        appointmentDate.Month,
        appointmentDate.Day,
        appointmentDate.Hour,
        appointmentDate.Minute,
        appointmentDate.Second
    let hour, meridian =
        match hour24 with
        | hour24 when hour24 > 12 -> (hour24 - 12), "PM"
        | _ -> hour24, "AM"
    $"You have an appointment on {month}/{day}/{year} {hour}:{minute:D2}:{second:D2} {meridian}."

let anniversaryDate(): DateTime =
    let thisYear = DateTime.Now.Year
    DateTime(thisYear, 9, 15, 0, 0, 0)
