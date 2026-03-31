Function ValidateAge() {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateScript({ $_ -ge 18 },
            ErrorMessage = "'{0}' is not a valid age. Valid value is 18 and up")]
        [int] $Age
    )
    return "I'm $Age years old!"

    <#
    .SYNOPSIS
    Simple function to check if the input age is over 18.

    .DESCRIPTION
    This is a function to validate an age.
    It will throw a termination error when :
    a. The input value for the Age param won't satisfy the ValidateScript
    b. The input value doesn't match the expected type [int]
    Do not delete or modify this.

    .PARAMETER Age
    An integer represent the age, it should be 18 or up.
    #>
}

#Start all your code below this
Function NonTerminationError {
    Write-Error "Error: This is a non termination error"

    <#
    .DESCRIPTION
    A simple function that returns an error message but doesnt terminate the function.
    #>
}

Function ValueErrorHandling {
    param (
        $Age
    )
    try {
        ValidateAge -Age $Age
    }
    catch [System.Management.Automation.ValidationMetadataException],
        [System.Management.Automation.ArgumentTransformationMetadataException] {
        return "Error: Age need to be 18 and up"
    }
    catch {
        $_.Exception.GetType().FullName
        $_.Exception.InnerException?.GetType().FullName
        throw
    }

    <#
    .DESCRIPTION
    A function that takes in an input for the predefined ValidateAge function, it may catch error and return normal string with a warning message. 
    #>
}

Function TypedErrorHandling {
    param (
        [string] $Path
    )
    try {
        # pwsh allows enormous paths, so must artificially force a PathTooLongException
        if ($Path.Length -ge 257) {
            throw [System.IO.PathTooLongException]::new()
        }
        # otherwise, try something that could throw "file not found"
        Get-Item -Path $Path -ErrorAction Stop
    }
    catch [System.Management.Automation.ItemNotFoundException] {
        return "Error: File not found"
    }
    catch [System.IO.PathTooLongException] {
        return "The specified file name or path is too long, or a component of the specified path is too long."
    }
    catch {
        Write-Host "caught exception: $($_.Exception.GetType().FullName)"
        Write-Host "  containing message: $($_.Exception.Message)"
        throw
    }

    <#
    .DESCRIPTION
    A function that take in a string represent a path to open a file.
    This function should handle 2 different termination errors:
    - File not found
    - File path is too long (256)

    .PARAMETER Path
    String represent a filepath.
    #>
}

Function ReThrowErrorHandling {
    param (
        [string] $Path
    )
    if ([string]::IsNullOrWhiteSpace($Path))
    {
        throw "*Error: Path wasn't provided.*"
    }

    <#
    .DESCRIPTION
    A simple function to demonstrate the ability to rethrow a different error.
    Instead of throwing a filepath not exist, throw a custom error when the Path parameter wasn't provided.
    #>
}
