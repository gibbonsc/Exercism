module PizzaPricing

// TODO: please define the 'Pizza' discriminated union type
type Pizza =
| Margherita
| Caprese
| Formaggio
| ExtraSauce of Pizza
| ExtraToppings of Pizza

let rec pizzaPrice (pizza: Pizza): int =
    match pizza with
    | Margherita -> 7
    | Caprese -> 9
    | Formaggio -> 10
    | ExtraSauce e ->
        1 + pizzaPrice e
    | ExtraToppings e ->
        2 + pizzaPrice e

let orderPrice(pizzas: Pizza list): int =
    let fee =
        match List.length pizzas with
        | 0 -> 0
        | 1 -> 3
        | 2 -> 2
        | _ -> 0
    let subtotal =
        pizzas
        |> List.map pizzaPrice
        |> List.sum
    subtotal + fee
