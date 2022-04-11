
Executing this:
```cmd
printf "123 + 23   23 \n + + 12+ 2" | ./scanner
```

You get:
```cmd
123 --> constant number
Iteration: 0. Token: 2
+ --> add operator
Iteration: 1. Token: 1
23 --> constant number
Iteration: 2. Token: 2
23 --> constant number
Iteration: 3. Token: 2
New line
Iteration: 4. Token: 0
+ --> add operator
Iteration: 5. Token: 1
+ --> add operator
Iteration: 6. Token: 1
12 --> constant number
Iteration: 7. Token: 2
+ --> add operator
Iteration: 8. Token: 1
2 --> constant number
Iteration: 9. Token: 2
End of file!
Iteration: 10. Token: -1
Total number of operations: 4
```

We observe that is tokenizing the input very well, but at the same time it
doesn't care about the syntax.
For example, Two `+` operators are not a problem for the scanner.

It is ignoring extra spaces.

It's not ignoring the new lines because I added that specific rule.

It also gives a correct answer even if not spaces are delimiting the input
tokens, like in `12+`.

[]: https://perso.esiee.fr/~najmanl/compil/Flex/flex_2.html
[]: https://aquamentus.com/tut_lexyacc.html
[flexBisonCmake]: https://cmake.org/cmake/help/v3.0/module/FindFLEX.html

