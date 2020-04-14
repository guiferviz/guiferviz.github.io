---
layout: post

title: Uranium 02 - Compiling a C++ program that uses LLVM libraries
excerpt: >
    Let's write a CMakeLists.txt that allows us to compile our project.
date: 2020-04-11
tags: [Compilers, Uranium, LLVM, IR Code]

mathjax: false
comments: true
---

As explained in the [previous post][prevPost], I have the last released
version of LLVM installed in my machine.

At the beggining a big confussion with the headers under the "llvm-c" dir.
Those headers are the C API, the ones I'm using here are the C++ API.

This is how the `CMakeLists.txt` looks like.
<script src="https://emgithub.com/embed.js?target=https%3A%2F%2Fgithub.com%2Fguiferviz%2Furanium%2Fblob%2Fpost02%2FCMakeLists.txt&style=github&showBorder=on&showLineNumbers=on&showFileMeta=on"></script>

This is the code of the `main.cpp` file:
<script src="https://emgithub.com/embed.js?target=https%3A%2F%2Fgithub.com%2Fguiferviz%2Furanium%2Fblob%2Fpost02%2Fsrc%2Fmain.cpp&style=github&showBorder=on&showLineNumbers=on&showFileMeta=on"></script>

And this one is the expected output.

<div style="text-align: center">
<img src="/assets/images/2020_04_11_expected_output.png" />
<figcaption>
Expected output.
A couple of hateful warnings appear at first, but I'm good at ignoring them.
</figcaption>
</div>

You cannot compile this code, you need a `main` function.


# Full code in GitHub

Check out the repository with the [code from this post][repo].
All the code of this post is tagged with `post02`.


# References

* [LLVM Programmers manual about contexts][llvmCtx].
* [LLVM LangRef about Modules][llvmModule].


[prevPost]: /2020/04/10/uranium-01-compiling-llvm.html
[repo]: https://github.com/guiferviz/uranium/tree/post02
[llvmCtx]: https://releases.llvm.org/10.0.0/docs/ProgrammersManual.html#achieving-isolation-with-llvmcontext
[llvmModule]: https://releases.llvm.org/10.0.0/docs/LangRef.html#module-structure

