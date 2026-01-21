module RomanNumerals

let roman (arabicNumeral : int) : string =
    let units = arabicNumeral % 10
    let tens = (arabicNumeral - units) / 10 % 10
    let hundreds = (arabicNumeral - tens - units) / 100 % 10
    let thousands = (arabicNumeral - hundreds - tens - units) / 1000
    let romanUnits =     [ ""; "I"; "II"; "III"; "IV"; "V"; "VI"; "VII"; "VIII"; "IX" ]
    let romanTens =      [ ""; "X"; "XX"; "XXX"; "XL"; "L"; "LX"; "LXX"; "LXXX"; "XC" ]
    let romanHundreds =  [ ""; "C"; "CC"; "CCC"; "CD"; "D"; "DC"; "DCC"; "DCCC"; "CM" ]
    let romanThousands = [ ""; "M"; "MM"; "MMM" ]
    romanThousands.[thousands] + romanHundreds[hundreds] + romanTens[tens] + romanUnits[units]
