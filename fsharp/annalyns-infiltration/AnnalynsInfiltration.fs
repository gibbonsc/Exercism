module AnnalynsInfiltration

// let canFastAttack (knightIsAwake: bool): bool = failwith "Please implement the 'canFastAttack' function"
let canFastAttack (knightIsAwake: bool): bool =
    not knightIsAwake

// let canSpy (knightIsAwake: bool) (archerIsAwake: bool) (prisonerIsAwake: bool): bool =
//     failwith "Please implement the 'canSpy' function"
let canSpy (knightIsAwake: bool) (archerIsAwake: bool) (prisonerIsAwake: bool): bool =
    knightIsAwake || archerIsAwake || prisonerIsAwake

// let canSignalPrisoner (archerIsAwake: bool) (prisonerIsAwake: bool): bool =
//     failwith "Please implement the 'canSignalPrisoner' function"
let canSignalPrisoner (archerIsAwake: bool) (prisonerIsAwake: bool): bool =
    prisonerIsAwake && not archerIsAwake

let canFreePrisoner (knightIsAwake: bool) (archerIsAwake: bool) (prisonerIsAwake: bool) (petDogIsPresent: bool): bool =
    (petDogIsPresent && not archerIsAwake) || (prisonerIsAwake && not knightIsAwake && not archerIsAwake)
