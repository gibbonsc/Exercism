module Gigasecond
open System
let add (beginDate : DateTime) =
    beginDate.AddSeconds(1.0e9)