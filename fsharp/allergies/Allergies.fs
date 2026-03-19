module Allergies

open System

type Allergen =
| Eggs
| Peanuts
| Shellfish
| Strawberries
| Tomatoes
| Chocolate
| Pollen
| Cats

let allergyValue (allergen : Allergen) : int =
    match allergen with
    | Eggs -> 1
    | Peanuts -> 2
    | Shellfish -> 4
    | Strawberries -> 8
    | Tomatoes -> 16
    | Chocolate -> 32
    | Pollen -> 64
    | Cats -> 128

let allergicTo (codedAllergies : int) (allergen : Allergen) : bool =
    allergyValue allergen &&& codedAllergies <> 0

let list (codedAllergies : int) : Allergen list =
    [
        Eggs; Peanuts; Shellfish; Strawberries;
        Tomatoes; Chocolate; Pollen; Cats;
    ]
    |> List.filter (allergicTo codedAllergies)
