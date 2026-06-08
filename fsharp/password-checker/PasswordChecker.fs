module PasswordChecker

type PasswordError =
    | LessThan12Characters
    | MissingUppercaseLetter
    | MissingLowercaseLetter
    | MissingDigit
    | MissingSymbol

/// Validate the given password against the rules defined in the instructions. If it meets all
/// of the rules, return a result indicating success; otherwise return a result indicating
/// failure and an error indicating which rule was violated.
let checkPassword (password: string) : Result<string, PasswordError> =
    if 12 > Seq.length password then
        Error LessThan12Characters
    elif password = password.ToLowerInvariant() then
        Error MissingUppercaseLetter
    elif password = password.ToUpperInvariant() then
        Error MissingLowercaseLetter
    elif not (Seq.exists (fun c -> '0' <= c && c <= '9' ) password) then
        Error MissingDigit
    elif not (Seq.exists (fun c -> Seq.contains c "!@#$%^&*") password) then
        Error MissingSymbol
    else
        Ok password

/// Return a human-readable message indicating the meaning of the given result value.
let getStatusMessage (result: Result<string, PasswordError>) : string =
    match result with
    | Error LessThan12Characters ->
        "Error: does not have at least 12 characters"
    | Error MissingUppercaseLetter ->
        "Error: does not have at least one uppercase letter"
    | Error MissingLowercaseLetter ->
        "Error: does not have at least one lowercase letter"
    | Error MissingDigit ->
        "Error: does not have at least one digit"
    | Error MissingSymbol ->
        "Error: does not have at least one symbol"
    | Ok _ ->
        "OK"
