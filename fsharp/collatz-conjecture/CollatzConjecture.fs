module CollatzConjecture

let steps (number: int): int option =
    if number <= 0 then
        None
    else
        let rec stepper (step: int * int): (int * int) =
            let acc, num = step
            if 1 = num then
                acc, 1
            elif num % 2 = 0 then
                stepper (1 + acc, num >>> 1)
            else
                stepper (1 + acc, 1 + num + (num <<< 1))
        let count, _ = stepper (0, number)
        Some count
