---
layout: post

title: Uranium 04 - Generating an 'int main' function
excerpt: >
    Time to generate some visible working IR code!
    I'm going to create a main function that returns an integer so I can check
    that the exit code returned by my compiled IR is the expected one.
    We will learn something new about integer numbers in LLVM.
date: 2020-04-13
tags: [Compilers, Uranium, LLVM, IR Code]

mathjax: false
comments: true
---

I ran:
```cmd
make && ./uc 2> main.ll && lli main.ll || echo $?
```

and I get... 4!!!

The generated code looks like:
```llvm
; ModuleID = 'uranium_module'
source_filename = "main.ura"

define i8 @main() {
main_block:
  ret i8 4
}
```

