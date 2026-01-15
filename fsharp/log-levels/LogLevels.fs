module LogLevels

open System
let message (logLine: string): string =
    logLine.Split([| ':' |])
    |> Array.last
    |> fun s -> s.Trim()

let logLevel (logLine: string): string = // failwith "Please implement the 'logLevel' function"
    logLine.Split( [| ':' |])
    |> Array.head
    |> fun s -> s.Substring(1,s.Length - 2).ToLower()

let reformat (logLine: string): string = // failwith "Please implement the 'reformat' function"
    let msg = message logLine
    let lvl = logLevel logLine
    msg + " (" + lvl + ")"