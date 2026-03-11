module InterestIsInteresting

let interestRate (balance: decimal): single =
    match balance with
    | balance when balance < 0m -> 3.213f
    | balance when balance < 1_000m -> 0.5f
    | balance when balance < 5_000m -> 1.621f
    | _ -> 2.475f

let interest (balance: decimal): decimal =
   let rate = decimal (interestRate balance) / 100m
   balance * rate

let annualBalanceUpdate(balance: decimal): decimal =
   balance + (interest balance)

let amountToDonate(balance: decimal) (taxFreePercentage: float): int =
   if balance >= 0m then
       let taxFreeAmount = balance * ((decimal taxFreePercentage) / 100m)
       int (2.0m * taxFreeAmount)
       (* "You don't mind paying tax on the second half of the donation?" *)
   else
       0
