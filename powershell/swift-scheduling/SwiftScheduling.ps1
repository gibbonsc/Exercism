Function Invoke-SwiftScheduling() {
    [CmdletBinding()]
    Param(
        [datetime]$MeetingStart,
        [string]$Description
    )

    switch -Regex ($Description) {

        "NOW" { return $MeetingStart.AddHours(2) }

        "ASAP" {
            if ($MeetingStart.Hour -lt 13) {
                return [DateTime]::new(
                    $MeetingStart.Year,
                    $MeetingStart.Month,
                    $MeetingStart.Day,
                    17, 0, 0  # 17:00
                )
            }
            else {
                return [DateTime]::new(
                    $MeetingStart.Year,
                    $MeetingStart.Month,
                    $MeetingStart.Day,
                    13, 0, 0  # 13:00
                ).AddDays(1)
            }
        }

        "EOW" {
            $WeekDayIndex = [int]($MeetingStart.DayOfWeek)
            if ($WeekDayIndex -in (1..3)) {
                # meeting started Mon .. Wed
                $FridayOffset = 5 - $WeekDayIndex
                return [DateTime]::new(
                    $MeetingStart.Year,
                    $MeetingStart.Month,
                    $MeetingStart.Day,
                    17, 0, 0  # 17:00
                ).AddDays($FridayOffset)
            }
            elseif ($WeekDayIndex -in (4..5)) {
                # meeting started Thu .. Fri
                $SundayOffset = 7 - $WeekDayIndex
                return [DateTime]::new(
                    $MeetingStart.Year,
                    $MeetingStart.Month,
                    $MeetingStart.Day,
                    20, 0, 0  # 20:00
                ).AddDays($SundayOffset)
            }
            else {
                throw "$($MeetingStart.DayOfWeek) MeetingStart not between Monday and Friday"
            }
        }

        '^(\d+)M$' {
            # N-th month
            $N = [int]($Matches[1])
            $StartMonth = $MeetingStart.Month
            $Day1NthMonth = [DateTime]::new(
                $MeetingStart.Year,  # this year
                $N,  # N-th month
                1,  # first day
                8, 0, 0  # 8:00
            )
            if ($N -le $StartMonth) {
                # meeting started in or after N-th month
                $Day1NthMonth = $Day1NthMonth.AddYears(1)  # next year
            }
            $Day1Weekday = [int]($Day1NthMonth.DayOfWeek)
            if ($Day1Weekday -eq 6) {
                # Saturday
                return $Day1NthMonth.AddDays(2)  # following Monday
            }
            elseif ($Day1Weekday -eq 0) {
                # Sunday
                return $Day1NthMonth.AddDays(1)  # following Monday
            }
            return $Day1NthMonth
        }

        '^Q(\d+)$' {
            # N-th quarter
            $N = $Matches[1]
            $StartMonth = $MeetingStart.Month

            $StartQuarter = 1
            if ($StartMonth -in @(4, 5, 6)) { $StartQuarter = 2 }
            elseif ($StartMonth -in @(7, 8, 9)) { $StartQuarter = 3 }
            elseif ($StartMonth -in @(10, 11, 12)) { $StartQuarter = 4 }

            # LookupTable: quarter starts in Jan, Apr, Jul, or Oct
            $QuarterStartMonth = @{ "1" = 1; "2" = 4; "3" = 7; "4" = 10 }

            $LastDayNthQuarter = [DateTime]::new(
                $MeetingStart.Year,  # this year
                $QuarterStartMonth["$N"],  # N-th quarter
                1,  # first day
                8, 0, 0
            ).AddMonths(3).AddDays(-1)  # last day of N-th quarter

            if ($N -lt $StartQuarter) {
                # meeting started after N-th quarter
                $LastDayNthQuarter = $LastDayNthQuarter.AddYears(1)
            }

            $LastWorkdayNthQuarter = $LastDayNthQuarter
            $LastDayWeekday = [int]($LastDayNthQuarter.DayOfWeek)
            if ($LastDayWeekday -eq 0 ) {
                # Sunday
                return $LastWorkdayNthQuarter.AddDays(-2) # previous Friday
            }
            elseif ($LastDayWeekday -eq 6) {
                # Saturday
                return $LastWorkdayNthQuarter.AddDays(-1) # previous Friday
            }
            return $LastWorkdayNthQuarter
        }
    }

    <#
    .SYNOPSIS
    Find the actual dates for deliveries.

    .DESCRIPTION
    Convert delivery date descriptions to actual delivery dates, based on when the meeting started.

    .PARAMETER MeetingStart
    A datetime object for delivery date.

    .PARAMETER Description
    A string describes the nature of the delivery date.

    .EXAMPLE
     #>
}
