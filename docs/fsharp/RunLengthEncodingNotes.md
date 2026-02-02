# Notes

Because **_F#_** and _functional programming_ were so new to me,
I spent extra time on the **RLE** (run length encoding) exercise.
I used a genAI chatbot as a tutor -
I propmted it to just give me hints rather than share code,
and as we proceeded it suggested patterns to try
that it claimed would improve my FP skill.

## RunLengthEncodingv1.fs.txt

I coded this one first, using an imperative-style algorithm --
a mindset and approach that I would have used to solve the puzzle
using _C_ or _C#_ or _Python_ or _PowerShell_.
(This is the first time I have
ever programmed a run-length-encoder/decoder,
so I had never actually before done this in any of those
programming languages.) I had dabbled enough with F# to know
that it wasn't truly disciplined functional style, because it
has variables (`mutable` bindings) and flow control structures
(`if`...`then`...`else` branchings and
`for`...`in`...`do`...`yield` loops). So I decided to ask a
clanker ([Gemini](https://gemini.google.com/)) to carefully act
as an FP tutor.

My first conversation with the clanker was very helpful - pretty
quickly it showed me how to enable the Testing view in
Visual Studio Code, with which I could run individual
Exercism tests one a time, and even single-step debug through
those tests while observing the values of bindings and function
arguments. It also explained things I didn't understand about
the _Interactive F#_ "REPL" capability of Visual Studio Code's
"Ionide F#" extension, which I had used to highlight and
interactively test code snippets in separate terminal "sandboxes."

## RunLengthEncodingv2.fs.txt

[Exercism.org](https://exercism.org/) participant glenn_j hinted
that I should start with recursion, and after a couple of days of
puzzling and pestering the clanker about F# `rec` syntax and
function, I completed a second version of the RLE functions,
each of which had _nested_ (_"higher order"_) recursive functions.

The clanker's judgment was that I had indeed build a funcitonal
solution, but that I was still in the two-step mindset of parsing
input into tokens and then parsing each individual token
into the desired result. It challenged me to see if I could
solve it using just one "Head :: Tail" patterned recursive function
rather than two nested recursions.

## RunLengthEncodingv3.fs.txt

This one took a bit longer, but with more study and a few more
clanker hints I figured out a "Head :: Tail" recursion pattern
that worked with just one recursive function in the decoder and
soon after the encoder.

THen the clanker challenged me to do it again, but this time
without any recursive functions at all, but using the `List.fold`
higher-order `reducer` function instead.

## RunLengthEncodingv4.fs.txt

This last one took me more than a week of searching and studying,
but eventually I got it to work and was pleased with its style.

While working through these four versions of RunLengthEncoding,
I have noticed that it takes me longer to write functional F#
code that actually compiles and runs, after which I usually
need to do a little more debugging work. On the other hand,
when I use the comfortable "imperative programming" style I
have used for decades, I can churn out code that compiles
and runs pretty quickly, but I almost always must spend a
lot more time testing and debugging and fixiing issues
before the code works reliably and robustly.
