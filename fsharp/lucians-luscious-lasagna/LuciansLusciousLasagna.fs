module LuciansLusciousLasagna

// TODO: define the 'expectedMinutesInOven' binding
let expectedMinutesInOven =
    40

// TODO: define the 'remainingMinutesInOven' function
let remainingMinutesInOven elapsed =
    expectedMinutesInOven - elapsed

// TODO: define the 'preparationTimeInMinutes' function
let preparationTimeInMinutes layers =
    2 * layers

// TODO: define the 'elapsedTimeInMinutes' function
let elapsedTimeInMinutes layers elapsed =
    2 * layers + elapsed
