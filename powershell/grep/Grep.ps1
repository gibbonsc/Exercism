# intentionally not used:
#   Select-String cmdlet;
#   wildcard expressions, operators -like, -notlike;
#   regular expressions, operators -match, -notmatch

Function Invoke-Grep() {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $True)]
        [string]$Pattern,
        [Parameter(Mandatory = $True, ValuefromPipeline = $True)]
        [string[]]$Files,
        [switch]$Number,
        [switch]$List,
        [switch]$Insensitive,
        [switch]$Invert,
        [switch]$Whole
    )

    process {
        $citedFiles = @{}
        $MultipleFiles = ($Files.Count -gt 1)
        foreach ($f in $Files) {
            $lineNum = 0
            foreach ($line in $Global:FILES[$f]) {
                $lineNum++

                # match index expression, per -Whole and -Insensitive flags
                if ($Whole -and $Insensitive) {
                    $idx = ($line.ToLower() -eq $Pattern.ToLower()) ? 0 : -1
                }
                elseif ($Whole) {
                    $idx = ($line -eq $Pattern) ? 0 : -1
                }
                elseif ($Insensitive) {
                    $idx = $line.ToLower().IndexOf($Pattern.ToLower())
                }
                else {
                    $idx = $line.IndexOf($Pattern)
                }

                # -Invert flag negates (0 -le $idx) match criterion
                $found =
                ((0 -le $idx) -and -not $Invert) -or
                ($Invert -and (0 -gt $idx))

                if ($found) {
                    if ($List) {
                        # output filename instead of matched line
                        [void] ($citedFiles[$f] = $null)
                    }
                    else {
                        $result = $line
                        # -Number flag prepends line number to matched line
                        if ($Number) { $result = "$($lineNum):" + $result }
                        # multiple files prepends filename to matched line
                        if ($MultipleFiles) {
                            "$($f):" + $result
                        }
                        else {
                            $result
                        }
                    }
                }
            }
        }
        if ($List) { $citedFiles.Keys }  # emit -List discoveries
    }

    <#
    .SYNOPSIS
    Implement a grep function similar to the grep command in unix system.

    .DESCRIPTION
    The Unix grep command searches files for lines that match a regular expression.
    Your task is to implement a simplified grep command, which supports searching for fixed strings.

    The grep command takes three arguments:

    1. The string to search for.
    2. Zero or more flags for customizing the command's behavior.
    3. One or more files to search in.

    It then reads the contents of the specified files (in the order specified), finds the lines that contain the search string, and finally returns those lines in the order in which they were found.
    When searching in multiple files, each matching line is prepended by the file name and a colon (':').
    Attempt to read file that doesn't exist should throw an error.

    .PARAMETER Pattern
    The string to be matched

    .PARAMETER Files
    An array of string, each represent a text file to be accessed and get to its content

    .PARAMETER Number
    A switch parameter, similar to '-n' flag

    .PARAMETER List
    A switch parameter, similar to '-l' flag

    .PARAMETER Insensitive
    A switch parameter, similar to '-i' flag

    .PARAMETER Invert
    A switch parameter, similar to '-v' flag

    .PARAMETER Whole
    A switch parameter, similar to '-x' flag

    .EXAMPLE
    ```greeting.txt
    @"
    Hello everybody,
    Welcome to Exercism!
    Please enjoy the Powershell track,
    and have fun coding!
    "@
    ```
    Grepping the word 'power' as case-insensitive in file "greeting.txt", also show line number:

    Invoke-Grep -Pattern "power" -Files @("greeting.txt") -Number -Insensitive
    Returns: @("3:Please enjoy the Powershell track,")
    #>
}