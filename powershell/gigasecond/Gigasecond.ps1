Function Add-Gigasecond() {
    [CmdletBinding()]
    Param(
        [DateTime]$Time
    )
    $Time + [TimeSpan]::new([long](10000000 * 1000000000))
    # 10,000,000 ticks per second * 1,000,000,000 ticks per gigasecond

    <#
    .SYNOPSIS
    Add a gigasecond to a date.

    .DESCRIPTION
    Take a moment and add a gigasecond to it.

    .PARAMETER Time
    A datetime object, to which a gigasecond will be added.

    .EXAMPLE
    Add-Gigasecond -Time
    #>
}
