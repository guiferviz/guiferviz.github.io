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

esto me toca la moral

The generated code looks like:
{% highlight llvm %}
; ModuleID = 'uranium_module'
source_filename = "main.ura"

define i8 @main() {
main_block:
  ret i8 4
}
{% endhighlight %}

<style>
/* source_filename is not detected by the LLVM Pygments parser.
 * To avoid the red color and the red box around the word I'm going to
 * consider that it's a keyword.
 * IMPORTANT: This works only with the Tango Pygments style.
 * If you change the style the keyword style may be different. */
.highlight .err {
	color: #204a87;
	font-weight: bold;
	border: none;
}
</style>
