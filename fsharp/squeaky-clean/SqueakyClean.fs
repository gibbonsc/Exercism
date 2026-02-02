module SqueakyClean

open System

let transform (c: char) : string =
    if c = '-' then
        // 1: replace hyphen with underscore
        "_"
    elif c = ' ' then
        // 2: remove whitespace
        ""
    elif System.Char.IsUpper c then
        // 3. kebab uppercase
        "-" + (string (System.Char.ToLowerInvariant c))
    elif System.Char.IsDigit c then
        // 4. remove digit
        ""
    elif Seq.exists (fun (elm : char) -> elm = c) (seq {'α'..'ω'}) then
        // 5. question lowercase Greek letters between alpha and omega
        "?"
    else
        // leave other chracters alone
        string c

let clean (identifier: string): string =
    String.collect transform identifier
