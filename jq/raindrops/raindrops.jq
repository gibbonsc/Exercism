{
    number: .number,  # Don't Lose My Number
    r3: (.number % 3 == 0),  # divisible by 3?
    r5: (.number % 5 == 0),  # by 5?
    r7: (.number % 7 == 0)   # by 7?
}
| if ( (.r3 or .r5 or .r7) | not ) then  # divisible by none of 3,5,7
    "\(.number)"
  else  # find and concatenate corresponding sounds
    [
        if .r3 then "Pling" else "" end,
        if .r5 then "Plang" else "" end,
        if .r7 then "Plong" else "" end
    ]
    | add
  end
