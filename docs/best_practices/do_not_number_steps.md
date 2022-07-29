# Do not number steps

!!! TLDR "TLDR"

    Do not use numbers to set an order in your
    modules/functions/files/notebooks. They just increase the cognitive load and
    leads to errors. If you want to know the order of execution go to your
    orchestrator or main function that calls them.

In data engineering projects I have very often come across projects with a
folder structure similar to the following one:

```
my_project/
├─ src/
│  ├─ 01_base_extract.py
│  ├─ 02_custom_extract.py
│  ├─ 03_base_transformations.py
│  ├─ 04_join_sources.py
│  ├─ ... more files here ...
```

Sometimes it is even more bizarre:

```
my_project/
├─ src/
│  ├─ 01_extract/
│  │  ├─ 01_01_base_extract.py
│  │  ├─ 01_02_custom_extract.py
│  ├─ 02_transform/
│  │  ├─ 02_01_base_transformations.py
│  │  ├─ 02_02_join_sources.py
│  ├─ ... more folders and files here ...
```

When I see something like this my first reaction is to cry :cry:. Please, **do
NOT number the steps of your process in you code**.

!!! note

    Numbering here means provide explicit order in the name. Using letters like
    a, b, c... is also equivalent to numbering.


## What will happen if you use numbers

In these two previous examples the situation does not seem that bad, but let me
explain what is going to happen when those *greenfield* projects have been
active developed for a few more months. Let's use the second list of files as
an example. It is quite likely that the directory structure will end up looking
like this:

```
my_project/
├─ src/
│  ├─ 01_extract/
│  │  ├─ 01_00_setup_extractions.py
│  │  ├─ 01_00b_setup_custom_extract.py
│  │  ├─ 01_02_custom_extract.py
│  │  ├─ 01_02b_custom_extract.py
│  │  ├─ 01_02b_custom_extract_v2.py
│  │  ├─ 01_03_new_base_extract_v2.py
│  │  ├─ 01_05_extract_other_source.py
│  ├─ 02_transform/
│  │  ├─ 02_01_base_transformations.py
│  │  ├─ 02_02_join_sources.py
│  │  ├─ 01_03_new_base_transformations.py
│  ├─ ... more folders and files here ...
```

Some horrible things have happened:

* A new file called `01_00_setup_extractions.py` has been added, and with it a
new minimum step number. The lower step is now 0, not 1 as before. I wonder
what will happen if any step before zero is necessary... Step -1?
* A new letter suffix has appeared. What does a "b" means after the number in
`01_02b_custom_extract.py`? Is it a new step between step 02 and 03 or is this
new file replacing the previous `01_02_custom_extract.py`?
* Some human with a VCS complex started adding versions to the filenames, like
in `01_02b_custom_extract_v2.py`. GIT does this for you!
* Where is version 1? Where is version "a"? Where is extract step 04?
* Is `01_03_new_base_transformations.py` in the correct folder? It starts by
`01`, but it is inside `02_transform/` and it contains the word
`transformations` in the file name.

Some even more horrible things that could have happened:

* The orchestrator that defines the execution order of these files calls
`01_03_new_base_extract_v2.py` first rather than `01_02b_custom_extract_v2.py`.
* The orchestrator calls neither `01_00_setup_extractions.py` nor
`01_02_custom_extract.py`. So we are keeping older versions of our steps in our
codebase.
* Some other outlandish stuff that I cannot even imagine now :exploding_head:.

Although this almost-real example may have dispelled many doubts as to why I
think using numbers is not the best thing to do, let's look at it on more
detail.


## Why not to number?

**Code is dynamic**, we are continuously adding/removing features. If we only
added new files at the end there would not be much of a problem, but sometimes
we modify, delete or add new files at intermediate positions. What we consider
step 2 at the beginning of the project could be step 10 at the end.

If we need to add a new step between the step 1 and 2 we usually have two
options:

1. We rename all the steps from 2 onwards.
2. We make up a new naming strategy: `1a`, `1b`, `1_1`, `1.1`...

Renaming takes time, introduces a lot of noise on PRs, it is risky if we do not
update the code that call/uses those files (specially if we do not have proper
tests, really common on data projects)... Creating intermediate steps is
confusing, specially if the new step is not related at all with the previous
step. If we have a file numbered with a `1` and another one with `1.1`, we
expect `1.1` to be a sub-step of step `1`.

A similar situation takes place if we remove one step. Our two options are:

1. Rename all the following steps.
2. Leave a *hole* in the step list.

First option has the same downsides as before, the second one can also lead to
confusions: Are we missing a file? Was it deleted for some reason? Did someone
number the files wrong by mistake?

But there is something else... Some main process needs to call those files. The
runner/orchestrator does not know about numbers, numbers are just characters in
the filename. We are the ones in charge of defining the order of execution in
the orchestrator and that leads to even more confusion. We are completely free
to call step 4 first, then step 1 and later step 3 and do not even call step 2.
This means that the filenames are not reflecting the real order, they are just
there to increase the [cognitive
load](https://en.wikipedia.org/wiki/Cognitive_load) of developers.

!!! Note

    In this post we are mainly talking about filenames, but the same applies to
    function names. If you have functions that need to be run in sequence you
    always have a main function that calls them. That would be the orchestrator
    of your process.


## Proposed solution

The proposed solution is to clearly define a main/orchestrator file that sets
the order. We can have a list of steps somewhere in the code, something like:

```python title="orchestrator.py"
call("extract/base_extract.py")
call("extract/custom_extract.by")
call("transform/base_transformations.by")
call("transform/join_sources.by")
```

If we are not using numbers and we want to add a new step, we do not need to
modify any existing code or filename. We just need to add a new line in the
orchestrator.

```python title="orchestrator.py with new step added"
call("extract/base_extract.py")
call("extract/extract_another_source.py")  # <-- New line
call("extract/custom_extract.py")
call("transform/base_transformations.py")
call("transform/join_sources.py")
```

If someone wants to know the exact order should go to that file.


## Conclusion

Do not use numbers in function/module/file names, they lead to confusion.
Define the order in code, you can always trust the order of a piece of code
that orchestrate your process.
