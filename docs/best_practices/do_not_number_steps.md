# Do not number steps

> Do not use numbers to set an order in your modules/functions/files/notebooks.

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

My first reaction to this is to cry. Please, **do NOT number the steps of your
process in you code**.

!!! note

    Numbering here means provide explicit order in the name. Using letters like
    a, b, c... is also equivalent to numbering.


## What will happen if you use numbers

In these two previous examples the situation does not seem that bad, but let me
explain what is going to happen when those greenfield projects have been active
for a few more months. All points to the second example evolving to something
like:

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

Some horrible things that have happened:

* The lower number is now 0, not 1 as before. I wonder what will happen if any
step before zero is necessary... Step -1?
* A new letter suffix has appeared. What does a "b" means after the number in
`01_02b_custom_extract.py`? It's a new step between step 02 and 03 or is this
new file replacing the previous `01_02_custom_extract.py`?
* Some human with a VCS complex started adding versions to the filenames, like
in `01_02b_custom_extract_v2.py`. GIT does this for you!
* Related the previous points... Where is version 1? Where is 'version A'?
Where is step 04?
* Is `01_03_new_base_transformations.py` in the correct folder? It starts by
`01`, but it is inside `02_transform/` and it contains the word
`transformations` in the file name.

Some even more horrible things that could have happened:

* The orchestrator that defines the execution order of these files calls
`01_03_new_base_extract_v2.py` first rather than `01_02b_custom_extract_v2.py`.
* The orchestrator calls neither `01_02b_custom_extract_v2.py` nor
`01_02_custom_extract.py`. So we are keeping older versions of our code in our
library.
* Some other outlandish stuff that I cannot even imagine now.

Although this almost-real example may have dispelled many doubts as to why I
think using numbers is not the best thing to do, let's look at it on more
detail.


## Why not to number?

Code is dynamic, we are continuously adding/removing features. If we only added
new files at the end there would not be much of a problem, but sometimes we
modify, delete or have to add new files at intermediate positions. What we
consider step 2 at the beginning of the project could be step 10 at the end.

If we need to add a new step between the step 1 and 2 we usually have two
options:

1. We rename all the steps from 2 onwards.
2. We made up a new naming strategy: `1a`, `1b`, `1_1`, `1.1`...

Renaming takes time, introduces a lot of changes on Git PRs, it is risky if we
do not update the code that call/uses those files (specially if we do not have
proper tests, really common on data projects)... Creating intermediate steps is
confusing, specially if the new step is not related at all with the previous
step.

A similar situation takes place if we remove one step. Our two options are:

1. Rename all the onwards steps.
2. Leave a 'hole' in the step list.

First option has the same downsides as before, the second one is also confusing:
Are we missing a file? Was it deleted for some reason? Did someone number the
files wrong by mistake?

But there is something else... Some automated process needs to call those files.
The runner/orchestrator does not know about numbers, numbers are just characters
in the filename. We are the ones in charge of defining the order of execution
in the orchestrator and that leads to even more confusion. We are completely
free to call step 4 first, then step 1 and later step 3 and do not even call
step 2. This means that the filenames are not reflecting the real order, they
are just there to confuse developers.

!!! Note

    In this post we are mainly talking about filenames, but the same applies to
    function names. If you have functions that need to be run in sequence you
    always have a main function that calls them. That would be the orchestrator
    of your process.


## Proposed solution

The proposed solution is to clearly define a main/orchestrator file that sets
the order. We can have a list of steps somewhere in the code, something like:

```orchestrator.py
call("extract/base_extract.py")
call("extract/custom_extract.py")
call("transform/base_transformations.py")
call("transform/join_sources.py")
```

If we add a new element in the second position of the list we do not need to
modify anything else if we are not using numbers in the names. If someone wants
to know the exact order should go to that file.

```orchestrator.py with new step added
call("extract/base_extract.py")
call("extract/extract_another_source.py")
call("extract/custom_extract.py")
call("transform/base_transformations.py")
call("transform/join_sources.py")
```


## Conclusion

Do not use numbers, they are confusing. Define the order in the code, you can
always trust the order of a piece of code that orchestrate your process.
