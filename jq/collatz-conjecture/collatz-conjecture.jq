def step:
  #   transform:
  # {
  #   number: n,
  #   counter: c
  # }
  #   into:
  # {
  #   number: (next in Collatz sequence),
  #   counter: (c+1)
  # }
  {
    # Collatz formula:
    "number": (
      if .number % 2 == 0 then
        # evens cut in half,
        .number / 2
      else
        # odds trebled plus one
        3 * .number + 1
      end
    ),
    # increment step counter
    "counter": (.counter + 1)
  }
;

def steps:
  if . < 1 then
    "Only positive integers are allowed"
    | halt_error
  elif . == 1 then  # already at 1
    0
  else
    {  # seed the stepper
      "number": .,
      "counter": 1
    }
    | [  # keep stepping until 1 reached
      while(
        .number != 1; . | step
      )
    ]
    | last  # fetch the final step
    | .counter  # output the counted steps
  end
;
