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
categories: uranium
slug: 00-introduction
tags: [Compilers, Uranium, LLVM, Flex, Bison]

mathjax: true
comments: true
---

Let's start with an obvious question...
What is the **very first thing** to do when you want to create something?
Choose a name and a logo, of course!
Let me introduce <span style="color: green;">**Uranium**</span>, my
not-yet-designed programming language.

<figure id="uraniumLogo" style="text-align: center">
<img src="/assets/images/2020_04_09_uranium_logo.svg"
     width="400"
     alt="Uranium logo." />
<figcaption>
A bunch of radioactive zeros and ones that will soon destroy you.
</figcaption>
</figure>

And this is how I'd like Uranium to look like in the future.
It is a mixture of *C++* with *Python*, nothing too innovative in the syntax.

{% highlight cpp %}
int cube(x):
    return x*x*x

string s = ""
int n = 20
for int y = 7; y > -5; y--:
	for int x = -6; x < 7; x++:
		s += "·" if cube(x*x+y*y-n) < n*x*x*cube(y) else " "
	s += "\n"
print(s)
{% endhighlight %}

This is <span style="color: red">**not a tutorial**</span>, this is a dairy of
my process building Uranium.
That means you'll accompany me while I learn, so I may say something that is
not quite right.
It also means that I don't know how far this project will go.
I'll see as I go.
My goal is to at least build a compiler capable of processing the previous
code.

Anyways, if you follow all the series you will achieve amazing things, but you
will be expose to a lot of radiation that may kill you (or at least get your
unborn child born with three legs).

As a disclaimer for any nonsense I might say, I will add that this article was
written during the coronavirus quarantine of 2020.
A month without leaving home makes anyone insane.

{% include toc.html %}


# 1. Why to build a compiler?

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


# 2. What is a compiler?

A compiler is a translator from one language to another.
It takes a file written in $$X$$ language and returns a different file written
in the $$Y$$ language.

<figure id="figure01" style="text-align: center">
<img src="/assets/images/2020_04_09_compiler_in_out.svg"
     width="400"
     alt="Compiler input and output diagram." />
<figcaption>
Figure 1: In this image I represent the compiler as a big black box,
and it's not a coincidence,
they really are pieces of software from which we usually ignore almost
everything.
</figcaption>
</figure>

Usually, compilers translate input code to **machine code**.
We'll see more about this in the next section, but for now let's say that
machine code is code that can be understood and executed by a machine.
If the program $$X$$ is translated into a $$Y$$ machine code program,
then we can give it some input data, run it and get some output data.

<figure id="figure02" style="text-align: center">
<img src="/assets/images/2020_04_09_execution.svg"
     width="500"
     alt="Compiler and execution diagram." />
<figcaption>
Figure 2: A compiler generates machine code that can be executed with
different input data.
</figcaption>
</figure>

If the compilation and the execution with the input data is done at the same
time, We call interpreters to programs that perform those two tasks.
The execution time using interpreters is almost always slower than executing
compiled code.
That's because interpreters read the input code little by little and have to
make decisions immediately, they can't take too much time to optimize the code.
Interpreters do not really generate machine code, that's why they are not
really considered compilers.
Interpreters transform the input code and input data into the results of the
execution, without generating any extra code.

<figure id="figure03" style="text-align: center">
<img src="/assets/images/2020_04_09_interpreter.svg"
     width="500"
     alt="Interpreter diagram." />
<figcaption>
Figure 3: An interpreter takes the input code and the input data and
generates an output.
No machine code is generated.
</figcaption>
</figure>

Of course, not everything has to be black or white.
Among others we find compilers that compile code for virtual machines that
later interpret the code (like *Java* and its *Java Virtual Machine*)
and interpreters that do generate compiled code (*Just In-Time compilers*).


## 2.1. More about languages

Compilers usually translate from one high-level language to machine code.
**High-level languages** are very expressive programming languages, similar to
any human language like English.
With little code we can accomplish a lot.
For example, even if you don't know *Python* you can imagine what this
code does:
{% highlight python %}
for i in my_array:
    print(i)
{% endhighlight %}
It's pure English!
It iterates an array and shows each element on the screen.

As Uranium is going to be very similar to Python, Uranium is going to be a
high-level language.

**Low-level languages** are programming languages that are closer to machine
language than to human language.
In fact there is an almost direct correspondence between low-level language
instructions and generated machine code instructions.
In high level languages, a single instruction can be translated into hundreds
of machine code instructions.
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
Sometimes, it is also know as *machine language* or *native code*.
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


## 2.2. Phases of the compiler

As Uranium is going to be a compiled language I am going to focus only on
compilers, leaving aside interpreters.
However, as you might expect, compilers and interpreters share many
characteristics with each other.
So writing a compiler I will gain knowledge about both tools.

As I said before, I hate black boxes.
So I'm going to update the [Figure 1](#figure01) by replacing the compiler
box with other elements.
If we open the compiler black box the picture is like this:

<figure id="figure04" style="text-align: center">
<img src="/assets/images/2020_04_09_frontend_backend.svg"
     width="600"
     alt="A compiler is composed by a front end, an optimizer and a back end." />
<figcaption>
Figure 4: Now the big back box is split in smaller back boxes.
<br />
A compiler is composed by a front end module, an optimizer and a back end.
</figcaption>
</figure>

We observe that a compiler is written in a series of sequential steps.
This is a good software engineering design, modular pieces of software that
are by far easier to approach than a big unique module.
Some old compilers, such us **GCC**, are know to be very difficult to approach
because their design is not very modular.
Hopefully the situation is different in **LLVM**, the tool I will rely on to
build my compiler.
More about this tool in the next section.

The **compiler front end** reads the input code and translates it to an
**intermediate representation (IR)**.
That IR is nothing else than another programming language.
This different programming language is optimized by the **optimizer** and
translated to an specific machine code by the **compiler back end**.
An obvious question now arises: *Why to use an IR?*

Imagine that you translate your own language to C.
Now you can use any existing C compiler to generate your machine code.
Using C as an intermediate language you will reuse all the complex
optimizations techniques and the machine code generation of a well now
compiler, making your language as fast as C in an easy way.

In practice, C is not used for that purpose.
As we will see later, the language used as IR is a language created
specifically for that purpose.

Using the concept of IR we "only" need to build a front end that translate from
our own language to the IR and we will be able to compile to any machine
architecture from which we have a back end.
In the same way, if we are designing a CPU, we can write a back end for that
CPU and we will have a compiler for all the languages from which we have
front ends.

<figure id="figure05" style="text-align: center">
<img src="/assets/images/2020_04_09_frontend_backend_multi.svg"
     width="700"
     alt="Multiple front ends, one optimizer block and multiple back ends." />
<figcaption>
Figure 5: Using an IR we can reuse the different components of the compiler.
<br />
Writing a compiler is not longer a really hard task, let's reuse software!
</figcaption>
</figure>

The benefits of this approach is quite obvious.
We do not need to write an entire compiler from scratch for every pair of
language and CPU architecture.
In the real world there is not only one IR, but each project ends up using its
own intermediate language.
Anyway, using an IR has its advantages.

Let's continue splitting the front end and the back end of a compiler.

<figure id="figure06" style="text-align: center">
<img src="/assets/images/2020_04_09_compiler_phases.svg" />
<figcaption>
Figure 6: Main phases of a compiler.
<br />
We can still break down some of these boxes, but I think it's enough for the
moment.
</figcaption>
</figure>

*Hmmm... Now the number of black boxes is bigger!*
OK, relax.
If we keep opening the black boxes they will eventually stop being black and
we will be able to understand all the contents.
Until then, just relax.

As I progress with the construction of the compiler, I will go deeper
into each of the phases and learn a lot more about them.
To begin with, I will briefly describe each of the phases shown in
[Figure 6](#figure06) using an example.
Imagine we want to compile the expression: `1 + 2 * 3`.
It is very simple mathematical expression that evaluates to `7`.

* **Lexical Analyzer** or **scanner**.
The first step is to break the input in smaller units called tokens.
The given expression has 3 numbers and 2 operations.
In this phase, all spaces and comments are removed so that subsequent phases
do not need to deal with these elements.
Lexical errors are produced with inputs like `1 ^ 2` if the operator `^` is
not defined.
Any not allowed symbols are detected and reported.
Although syntactically incorrect, entries such as `1 + +2 3*` are lexically
correct and are not reported by the lexical analyzer.

<figure id="figure07" style="text-align: center">
<img src="/assets/images/2020_04_09_tokens.svg"
     width="600"
     alt="Tokens generated from the expression '1 + 2 * 3'." />
<figcaption>
Figure 7: The lexical analyzer splits the input text into unbreakable elements.
<br />
This figure shows the tokens generated from the expression in the text
<pre style="display: inline">"1 + 2 * 3"</pre>.
</figcaption>
</figure>

* **Syntax Analyzer** or **parser**.
Using a formal definition of a language, that is, a way of describing the set
of code that you can write with your language, this analyzer generates a
tree that represents the given expression and the evaluation order of the
operations.
The name of that tree is the Abstract Syntax Tree or AST.
The `1 + +2 3*` expression showed before will give an error during this phase.

<figure id="figure08" style="text-align: center">
<img src="/assets/images/2020_04_09_ast.svg"
     width="300"
     alt="Abstract Syntax Tree (AST) of the expression 1 + 2 * 3" />
<figcaption>
Figure 8: Abstract Syntax Tree (AST) of the expression 1 + 2 * 3.
Note that the precedence of the operations are implicit in the tree:
to evaluate the addition, the product must be computed first.
</figcaption>
</figure>

* **Semantic Analyzer**.
This analyzer deals with the data types and ensures that a variable is declared
before use.
Sometimes, the semantic analyzer and the lexical analyzer are mixed in the
same module.
Example: if you are trying to multiply a number by a string and this operation
is not defined in your language, then you will get a semantic error.

* **Intermediate Code Generator**.
Translate the AST to IR.
We will see much more about this in the next posts.
Bellow these lines, you will find an IR made up by me only for this example.

{% highlight nasm %}
i32 a = #1
i32 b = #2
i32 c = #3
i32 d = mul b, c
i32 e = sum a, d
return e
{% endhighlight %}

* **Optimizer**.
How can we optimize the given expression?
Very easy, we can just return 7 because we are using only constants, values
that are not going to change from execution to execution.

{% highlight nasm %}
return 7
{% endhighlight %}

* **Machine Code Generator** or back end.
The number 7 in binary could be the output of this expression.
Sometimes, once the machine code is generated, a second optimization phase can
be run.
This allows machine-specific optimizations to be applied.

{% highlight cpp %}
00000111
{% endhighlight %}

The communication between phases is made using some kind of representation.
The **source file** is the input of the lexical analyzer and its output is a
**stream of tokens**.
The syntax analyzer and the semantic analyzer are sometimes mixed in the
same module.
They receive tokens from the lexical analyzer and creates a **tree**
that represents the operations described in the code.
Using that tree, the code generator outputs a new code file written in an
**intermediate representation**.
Taking that code, the optimizer outputs an optimized version of that
intermediate representation.
The machine code generator outputs an object file with the **compiled code**.

In addition to the phases shown in [Figure 6](#figure06), other elements
besides the compiler are involved in the task of processing a programming
language.
Some programming languages like C++ has a **preprocessor** that modifies the
input file using macros before the file is fed into the compiler.
We also need some other tools to **link** the compiled code with other
previously compiled code or system functions.
So, processing programming languages can be trickier than I'm presenting
here, but so far it's is more than enough for us.
We can start our compiler and learn the rest of the things on the way.


# 3. Useful tools

As I said before, I want to find a good balance between programming everything
myself and using external libraries.

The condition I impose on myself is not to use any library if I can't implement
something basic equivalent by myself.
For example, if I know how to create a simple lexical analyzer that can
process numbers, keywords and common operators, then I can start using **Flex**
to program a more complex and efficient one.


## 3.1. Flex and Bison

Flex is a tool used to generate efficient scanners or lexical analyzers.
Flex tokenize an input text stream and returns a stream of tokens that are
consumed by the parser.

Bison helps us to generate a parser that checks the syntax of a program and
builds an AST.
Once you have an AST, it's pretty straightforward to generate the IR code.

<figure id="figure09" style="text-align: center">
<img src="/assets/images/2020_04_09_compiler_phases_flex_bison.svg"
     alt="Flex and Bison help us creating the scanner and the parser." />
<figcaption>
Figure 9: Modules that we can develop with the help of Flex and Bison.
</figcaption>
</figure>

Both programs are free and open source.


## 3.2. LLVM

LLVM can help us in the next black boxes of our previous graph.

<figure id="figure10" style="text-align: center">
<img src="/assets/images/2020_04_09_compiler_phases_llvm.svg"
     alt="LLVM can help in the IR code generation, in the optimization and the machine code generation." />
<figcaption>
Figure 10: LLVM can help in the IR code generation, in the optimization and
the machine code generation.
</figcaption>
</figure>

*Hmmm... LLVM only helps in two boxes and a half?*
You may say.
OK, wait a moment.
Maybe we can change the size of the boxes and make the optimizer and code
generation phases bigger.

<figure id="figure11" style="text-align: center">
<img src="/assets/images/2020_04_09_compiler_phases_llvm_big.svg"
     alt="Updated diagram with the size of the black boxes proportional to the difficulty of builing them." />
<figcaption>
Figure 11: The scale of the black boxes now represent the effort and knowledge
needed for creating that modules.
</figcaption>
</figure>

Better now?
The last phases are really difficult to implement and they required a lot of
knowledge, so using LLVM is going to save us lot of time.
The optimizer is the hardest part, a lot of dark knowledge is involved there.
Also, the machine code generator requires a lot of low level knowledge of the
CPU architecture.
LLVM adds support for the most common CPUs and the facility to add a custom
back end to generate code for our own CPUs.


## 3.3. C++

Apart from Flex, Bison and the LLVM libraries I need a programming language to
write the compiler.
Maybe in a future I will write the Uranium compiler in Uranium, but at this
moment I need to begin with a different one.
I thought about using Rust, a programming language that I wanted to use in a
real project, but I finally changed to C++.
The reason? Mental health.

* I already know C++.
Learning to use a new programming language while writing a compiler is not the
best choice.
* Also, there are not official binds of LLVM for Rust.
There are some of them that I tried and seem to be great, but any bind can
change a little bit the definition (specially data types) in some functions
and the LLVM documentation is tough enough for adding more difficulties to
the process.
I know that I will end up looking to the source code a lot, so I prefer to use
the same language with a 100% equal API.
* Flex and Bison have a lot of alternatives for any language, but the original
tools are made in C.
* C++ has a syntax very similar to C and also provides an object oriented
paradigm that is very convenient.

For those reasons, **C++ is the chosen option**.

What about the compiler used to compile my compiler?
I thing this election is pretty straightforward: **clang++**.
That's the LLVM C++ front end.
It's also good to have the clang compiler installed because it's useful to
observe the generated C++ IR output and compare it to the IR output generated
by our language.
We will talk more about this in the next posts.


# 4. What's next?

My plan is as follows:

1. **Generate some basic IR code that I can compile using LLVM**.
Of course, this is not the first step of any compiler, but I want to see
something working.
If I cannot manage to compile some basic code using LLVM there is no point in
implementing the rest of the phases of my compiler.
2. Implement a **very basic compiler that performs arithmetic operations**.
Creating a compiler that is capable of processing expressions like `2+22-1`
will allow me to see the entire end-to-end process.
3. **Define the Uranium language**.
Create a grammar using an **incremental approach**.
Starting with the expressions, then adding support for the variables, continue
with functions...
The number of features I wish to add to the language is still undetermined,
I will improvise according to my mood and the time I have.

Broadly speaking, those are the steps I'll be taking.
My idea is to define small milestones and write articles about them.
For example, the next objective is to set up the development environment:
download, compile and install LLVM and install Flex and Bison.
See you in the [next post][nextPost]!!

To make it easier, I've created an
[index page with all the Uranium posts][uraniumSeries].


# 5. References

* *Compilers: Principles, Techniques, & Tools* by
  *Alfred V. Aho, Monica S. Lam, Ravi Sethi and Jeffrey D. Ullman*.
  Second Edition.
  Chapter 1, sections 1.1 and 1.2.
  **Highly recommender reading**.
* [Introduction to LLVM][llvmIntro] by Chris Lattner.


[llvmIntro]: https://www.aosabook.org/en/llvm.html
[nextPost]: {% post_url 2020-04-21-uranium-01-devenv %}
[uraniumSeries]: /uranium
[rosettaArm]: https://rosettacode.org/wiki/Loops/Do-while#ARM_Assembly

