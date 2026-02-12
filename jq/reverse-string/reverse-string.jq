.value + "!"  # tag extra character (for empty-string edge-case)
| explode  # convert to array of codepoints
| reverse  # (I found another helpful filter in jq's fine manpage)
| implode  # convert back to string
| .[1:]  # slice away tagged extra character
