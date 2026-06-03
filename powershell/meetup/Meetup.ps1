Function Get-MeetUp {
    param(
        [int]$year,
        [int]$month,
        [string]$weekday,
        [string]$schedule
    )
    switch ($schedule) {
        "first" {
            $AnchorDay = [DateTIme]::new($year, $month, 1)
            break
        }
        "second" {
            $AnchorDay = [DateTime]::new($year, $month, 8)
            break
        }
        "third" {
            $AnchorDay = [DateTime]::new($year, $month, 15)
            break
        }
        "fourth" {
            $AnchorDay = [DateTime]::new($year, $month, 22)
            break
        }
        "last" {
            $AnchorDay = [DateTime]::new(
                $year, $month, 1).AddMonths(1).AddDays(-7)
            break
        }
        "teenth" {
            $AnchorDay = [DateTime]::new($year, $month, 13)
            break
        }
    }
    $AnchorWeekday = $AnchorDay.DayOfWeek
    $TargetWeekday = [DayOfWeek]$weekday
    $Offset = ([int]$TargetWeekday - [int]$AnchorWeekday + 7) % 7
    return $AnchorDay.AddDays($Offset)

    <#
    .SYNOPSIS
    In this exercise you will be given the recurring schedule, along with a month and year, and then asked to find the exact date of the meetup.
    
    .DESCRIPTION
    Given information for a meep up : year, month, weekday and schedule, return a datetime object of the meetup date.
    
    .PARAMETER Year
    The year of the meetup date.

    .PARAMETER Month
    The month of the meetup date.

    .PARAMETER Weekday
    The weekday of the meetup date.

    .PARAMETER Schedule
    The position of the specified weekday within the month.
    
    .EXAMPLE
    Get-MeetUp -Year 2002 -Month 12 -Weekday Monday -Schedule first
    Return: Monday, December 2, 2002 00:00:00 

    Note: 00:00:00 is just an example, Get-Date will return the current time (hour, min) based on your system unless you specify them.
    #>
}