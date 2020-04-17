---
layout: post

title: Uranium 00 - Creating a programming language with C++ and LLVM
excerpt: >
    Let me introduce you to Uranium, the ridiculously serious programming
    language I want to design.
    Creating a programming language with its respective compiler is not an
    easy project, so why to write my own language?
    Introduction, motivations, definitions, selected technologies and work plan
    of an ambitious personal project.
date: 2020-04-09
tags: [Compilers, Uranium, LLVM]
permalink: /uranium/00-introduction

mathjax: true
comments: true
---

Let's start with an obvious question...
What is the **very first thing** to do when you want to create something?
Choose a name and a logo, of course!
Let me introduce <span style="color: green;">**Uranium**</span>, my
not-yet-designed programming language.

<p>
<center>
<img src="/assets/images/2020_04_09_uranium_logo.svg" width="400" />
</center>
<figcaption>A bunch of radioactive zeros and ones that will soon destroy you.</figcaption>
</p>

This is <span style="color: red">**not a tutorial**</span>, this is a dairy of
my process building Uranium.
That means you'll accompany me while I learn, so I may say something that is
not quite right.
It also means that I don't know how far this project will go.
I'll see as I go.

Anyways, if you follow all the series you will achive amazing things, but you
will be expose to a lot of radiaction that may kill you (or at least get your
unborn child born with three legs).

As a disclaimer for any nonsense I might say, I will add that this article was
written during the coronavirus quarantine of 2020.
A month without leaving home makes anyone insane.


# Why to build a compiler?

Why spend so much time building a program as complex as a compiler?
Why to do it when there are hundreds of mature programming languages?
If you are reading this maybe you already have your own reasons, but if you're
reading this just out of curiosity and need someone to convince you to do it...
here are my main reasons:

* It's **fun**.
* **I don't like black boxes** and a compiler is a big black box that I've been
  using for a long time now.
  Building my own compiler is going to make that box less black, let's say that
  is going to be a <span style="color: gray">gray box</span>.
  It's not going to be a white/transparent box because making your own compiler
  from scratch that generates optimized code is a really difficult task.
  I don't thing I'm going to create a better compiler in a month
  than the one designed by a group of hundreds of experts over the years.
  It's not impossible, but it's really improbable.
  So I will try to find a good balance between writing all the code by my own
  and use some other tools.
  Even using tools created by others I will learn much more than I knew about
  compilers and their internal phases.
* It's a lot of **fun**.
* Knowing how compilers work **helps you write code better** suited to being
  optimized by the compiler.
* It's so much **fun**.
* Not a lot of people know how to build a compiler.
  It's a **difficult task**, so if I get something I will feel like a boss 😎.

Apart from all those reasons I will add a new one here that I didn't comment
before: I ❤️ programming, so I'm sure I'll have a great time.


# What is a compiler?

A compiler is a translator from one language to another.
It takes a file written in $$X$$ language and returns a different file written
in the $$Y$$ language.

<figure id="figure01" style="text-align: center">
<img src="/assets/images/2020_04_09_compiler_in_out.svg" width="400" />
<figcaption>
Figure 1: In this image I represent the compiler as a big black box,
and it's not a coincidence,
they really are pieces of software from which we usually ignore almost
everything.
</figcaption>
</figure>


## More about languages

Usually, compilers translate from one high level language to machine code.
**High level languages** are very expressive programming languages, similar to
any human language like English.
For example, even if you don't know *Python* you can imagine what this
code does:
{% highlight python %}
for i in my_array:
    print(i)
{% endhighlight %}
It's pure English!
It iterates an array and shows each element on the screen.

**Low level languages** are programming languages that are closer to machine
language than to human language.
Look at the next example:

{% highlight nasm %}
ldr r0,iAdrszMessResult
bl affichageMess            @ display message
add r4,#1                   @ increment counter
mov r0,r4
mov r1,#6                   @ division conuter by 6
bl division
cmp r3,#0                   @ remainder = zero ?
bne 1b                      @ no ->begin loop one
{% endhighlight %}

This is a fragment of *ARM Assembly* taken from *Rosetta Code*, an amazing
web page with tons of algorithms implemented in hundreds of languages
(hopefully it's going to contain Uranium code in the near future :).
What is this code doing?
The comments help a little bit, but anyway, it's much more difficult to
understand than a high level language.
You can see the [complete code here][rosettaArm].

**Machine code** is the most low level you can go.
It is the code that our machines can understand and execute
(e.i. zeros and ones arranged in the correct way).
This code depends on the CPU.
Each CPU is built differently and accepts certain types of instructions.
Luckily, not all CPUs are completely different, but we can group them into
families that share many common characteristics and instructions.
The most famous families are *x86*, *x86_64* and *AMD*.
Since I've given an example of each of the above types of programming languages
exposed, machine code won't be no less, here's an example:

{% highlight nasm %}
010101110101010001000110001111110011111100111111...
{% endhighlight %}

What does all that mean? 🤔
It is obvious that understanding this is much more difficult than any assembly
language.


## Phases of the compiler

As I said before, I hate black boxes.
So I'm going to update the [Figure 1](#figure01) by replacing the compiler
box with other elements.
If we open the compiler black box the picture is like this:

<figure id="figure02" style="text-align: center">
<img src="/assets/images/2020_04_09_compiler_phases.svg" />
<figcaption>
Figure 2: Now the big back box is split in smaller back boxes.
<br />
We can still break down some of these boxes, but I think it's enough for the
moment.
</figcaption>
</figure>

Hmmm... Now the number of black boxes is bigger!
Ok, relax.
If we keep opening the black boxes they will eventually stop being black and
we will be able to understand all the contents.
Until then, just relax.

We observe that a compiler is written in a series of sequential steps.
This is a good software engineering design, modular pieces of software that
are by far easier to approach than a big unique module.

In addition to the phases shown in [Figure 2](#figure02), other elements
besides the compiler are involved in the process of processing a programming
language.
Some programming languages like C++ has a **preprocessor** that modifies the
input file using macros before the file is fed into the compiler.
Apart from this translation, we also need some other tools to **link** the
compiled code with other previously compiled code or system functions.
So, processing programming languages can be trickier than I'm presenting
here, but so far it's is more than enough for us.
We can start our compiler and learn the rest of the things on the way.


# Useful tools - LLVM

LLVM can help us in the next black boxes of our previous graph.

<div style="text-align: center">
<img src="/assets/images/2020_04_09_compiler_phases_llvm.svg" />
<figcaption>
The scale of the black boxes now represent the effort and knowledge needed for
creating that modules.
</figcaption>
</div>

*Only two boxes and a half?!*
You say.
*Then I prefer not to learn LLVM and learn how to do it by myself*.
Ok, wait a moment.
Maybe we can change the size of the boxes and make the optimizer and code
generation phases bigger.

<div style="text-align: center">
<img src="/assets/images/2020_04_09_compiler_phases_llvm_big.svg" />
<figcaption>
The scale of the black boxes now represent the effort and knowledge needed for
creating that modules.
</figcaption>
</div>

Better now?
The last phases are too difficult to implement and they required a lot of
knowledge, so using LLVM is going to save us lot of time.
The optimizer is the hardest part, a lot of dark knowledge is involved there.
Also, the machine code generator requirese a lot of low level knowledge of the
CPU arquitecture.
LLVM add support for the commonst CPU and the facility to add our own backends
to generate code for or own CPUs.


# Useful tools - C++

Apart from the LLVM libraries we need a programming language to write the
compiler.
Maybe in a future I will write the Uranium compiler in Uranium, but at this
moment I need to begin with a different one.
I thought about using Rust, a programming language that I wanted to use in a
real project, but I finally changed to C++.
The reason? Mental health.

I already know C++.
Learning to use a new programming language while writing a compiler is not the
best choice.
Also, the are not official binds of LLVM for Rust.
There are some of them that I tried and seem to be great, but any bind can
change a little bit the definition (specially data types) in some functions
and the LLVM documentation is tough enough for adding more difficulties to
the process.
I know that I will end up looking to the source code a lot, so I prefer to use
the same language with a 100% equal API.

For those reasons, **C++ is the chosen option**.
What about the compiler?
I thing this election is pretty straightforward: **clang++**.
That's the LLVM C++ frontend.
It's also good to have the clang compiler installed because it's useful to
observe the generated IR output and compare to our language generated IR.
We will talk more about this in the next post.


# What's next?

Setting up the development environment is the next step to take.
Download, compile and install LLVM.
See you in the [next post][nextPost]!!


# References

* *Compilers: Principles, Techniques, & Tools* by
  *Alfred V. Aho, Monica S. Lam, Ravi Sethi and Jeffrey D. Ullman*.
  Second Edition.
  Chapter 1, sections 1.1 and 1.2.
* [Introduction to LLVM][llvmIntro] by Chris Lattner.


[llvmIntro]: https://www.aosabook.org/en/llvm.html
[nextPost]: /2020/04/10/uranium-01-compiling-llvm.html
[rosettaArm]: https://rosettacode.org/wiki/Loops/Do-while#ARM_Assembly
