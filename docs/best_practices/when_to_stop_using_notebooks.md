# When to stop using Python notebooks

!!! TLDR "TLDR"

    Use notebooks just for ad-hoc projects, PoCs, experiments or when you need
    visualizations. Use Python packages for any other use case.

In both **data engineering** and **data science**, the use of **notebooks is
widespread**. It is very easy and intuitive to open a Jupyter/Databricks
notebook in your favourite browser and start executing commands. Pretty much
anyone can train a machine learning model coping and pasting 4 lines of code.
Writing code to migrate 100 tables from one storage account to another can be
done in a matter of minutes. This ease of use is a positive aspect of
notebooks, but they can also be a double-edged sword if you don't know **when
to stop using them**.

As a data engineer, I have come across many large projects that are purely
developed with notebooks. Notebooks are a powerful tool, do not get me wrong,
but they are not suitable for all use cases. In this document I will go through
the main reasons why notebooks are **not the best option** when we want to
create a serious **product or a library/framework** that can be used across
multiple projects.

This post is mainly focus on Python and Databricks and, of course, is very
opinionated. I will be happy to discuss any of the points presented here with
anyone who disagrees.


## What is a product/library/framework?

I just said that using notebooks for products, libraries or frameworks is not
the right thing to do. What do I mean by products, libraries or frameworks?
What are the characteristics of such projects?

* We need quality code. This includes the usage of linters, type checkers and
consistent formatting and import order.
* Tested code. The more projects are using the library/framework the more
important it is to have them well tested and maintained.
* You want to have a better control of your requirements.
* Consistent versioning: do not overwrite old versions with new code. If a
project is using an specific version of your library, the artifact stored under
that version number should never change.
* Libraries/frameworks should be easy to use across different projects, more
than one version should exists at the same time to support old projects that
are not up to date.

In general, products, libraries and frameworks should be reliable, well tested,
and they need to follow the best software engineering practices. This post does
not apply for ad-hoc analytics, PoCs or any *quick and dirty* projects.


## What is the alternative?

_OK, notebooks are not good enough for you, so what is the alternative?_ Very
good question! The standard way to produce and distribute Python software is
using packages. A package is nothing more than a series of files with code that
is somehow related. In other words, a compressed file containing code created
for a specific purpose.

You have probably used packages before. For example, when you run:

```
pip install pandas
```

You are telling `pip` to look for the Pandas package in the [public package
index](https://pypi.org) and install it in your environment.

Instead of writing notebooks, the alternative proposed in this post is the
creation of one or more Python packages and maintain that package as if it were
a normal Python project. Software engineering has evolved a lot in the last 50
years and the development of a Python package is compatible with all these best
practices. Notebooks, on the other hand, are a step backwards in many of these
aspects. Keep reading to find out what I mean.

!!! note

    Although this post is mainly about Python, all the information here applies
    to any other language. For example, Scala can be used in notebooks but you
    can also create Jar packages (the equivalent of Python's Wheel) using
    [sbt](https://www.scala-sbt.org).


## Boilerplate code VS Python package

We do not usually start new projects from an empty directory. In the best
case we have a template that we clone, other times we just copy and existing
project and remove those parts that are not needed for our new project.

If you are building some kind of internal framework for your company, you need
to clarify the differences between your framework and the projects that are
going to use it.

Having a Python package does not mean that we no longer need a project template
which we have to clone when we want to start new projects. It is still
absolutely necessary. The main difference is that the boilerplate code you need
should be as minimal as possible. Project templates should call functions
defined in the library and there should be no business logic in them, just a
skeleton ready to be completed by the developer.

It is also possible to have a library with common code and import it from a
notebook! The important thing is that the library with common code should be a
Python package that follows good practices. Who, how and when we use the library
is out of scope of this post.

!!! tip

    [CookieCutter](https://github.com/cookiecutter/cookiecutter) is a nice tool
    for building templates :)


## Comparison


### Magic and DBUtils

Python magic and Databricks DBUtils are cool, but they only work on
Jupyter/Databricks. When we work on notebooks it is really easy to end up using
this kind of tools. For example, if you avoid using
[`%run`](https://docs.databricks.com/notebooks/notebooks-use.html#use-run-to-import-a-notebook)
because it cannot be done in a Python package, you will get much more portable
code.

DBUtils can be used from a Python package, but it is not as easy as writing
`dbutils`. If you develop locally and you want your code to run locally you will
prioritize different tools/options before using DBUtils, which gives you again
more portable code.


#### Run magic VS Python imports

Databricks has a Python magic used to run other notebooks. In addition to
making the code less portable, the use of `%run` can lead to other problems.
The `%run` magic works as a C/C++ preprocessor, it copies all the code from a
different notebook into the current notebook and runs it. Why is this bad? You
overwrite existing functions, imported modules and local variables. Here you
have a real example I have found some months ago:

```python title="notebook1.py"
# Cell 1
from datetime import datetime
datetime.now()
```

```python title="notebook2.py"
# Cell 1
import datetime

# Cell 2
%run ./notebook1

# Cell 3
datetime.datetime.now()  # BOOOOOOOOOOOOM!!!
# AttributeError: type object 'datetime.datetime' has no attribute 'datetime'
```

In `notebook2.py` we `import datetime` first and later we _copy and paste_ the
`notebook1.py` code in cell 2. This runs `from datetime import datetime` and
overwrites the existing datetime module. Cell 3 fails for obvious reasons.

Besides that, after running more than one notebook with `%run` it is not easy
to know where a function has been defined. It is equivalent to Python's `from x
import *`, something [strongly
discouraged](https://stackoverflow.com/questions/2386714/why-is-import-bad)
because it makes the code very difficult to follow and can overwrite
existing local variables. It is specially difficult in notebooks where we
cannot use the _Go to definition_ option that we usually have in powerful IDEs.

Moreover, sometimes even the powerful IDEs and their linters cannot tell where
functions come from if the fearsome `import *` is used.

Finally, if we execute two `%run ./notebook1` in a row on the same notebook it
will run twice. This is a problem especially if there is any code other than
function definitions. Python imports take this into account and do not re-run
code that has already been imported.

In Databricks we can also use
[`dbutils.notebook.run`](https://docs.databricks.com/dev-tools/databricks-utils.html#run-command-dbutilsnotebookrun)
to run notebooks, but they are executed in a different process, so we cannot
compare that with Python imports.


### Share folders VS Python Package Index

A common way to deploy projects made with notebooks is to copy the files to a
shared directory such as `/Share` in Databricks. This brings two main problems.

* It **complicates the deployment process if we want to maintain more than one
version at the same time**. Imagine that you are working on an internal
framework for your company. This kind of framework is used in more than one
project at the same time. Older and still active projects may require an older
version of the utility library, if only the latest version is deployed, copies
of the utility library will end up being made within each project's repository
to ensure that a new version will not break the existing code. A folder
structure like `/Shared/my_package/v0.1`, `/Shared/my_package/v0.2`... can be
created but you need to check that all your `%runs` in your project are
pointing to the same required version.

* Normally, as the name suggests, the `/Share` **directory is accessible by
everyone**, so we can make accidental modifications while reading those files
in the Databricks Workspace or, even worse, hot fixes that are applied on the
deployed files are never applied in the repository so they are lost after the
next deployments. Once a version is deployed is should never be modified.

* Databricks has the option of using Git repositories. I honestly never
explored in-depth that feature, but it looks to be impossible to maintain more
than one version of your code published at the same time.

[Artifactory](https://jfrog.com/artifactory/) or any server that allow us to
deploy Python packages can solve this problems. Every deployment should have a
different version, you cannot replace existing deployed versions. In your
cluster or in your job definition you can specify the version you want to use
in your project and you can upgrade it when you decide. No more errors due to
breaking changes in your dependencies. Besides that, if the update does not
contains breaking changes, you do not need to modify the source files at all.
We do not need to go through all the import statements and update the path,
imports do not use paths like `%run` does. And we do not need to modify the
`PYTHONPATH` environment variable at all, just write a normal Python import.

!!! tip

    [Semantic versioning](https://semver.org) can be easily applied to Python
    packages. It can even be automated using tools like
    [semantic-release](https://github.com/semantic-release/semantic-release).


### Dependency management

In Python packages you can include dependencies and specify the minimum and
maximum compatible versions. You can also use tools like
[Poetry](https://python-poetry.org) or
[pip-compile](https://github.com/jazzband/pip-tools) to lock the versions of
the dependencies. This is difficult to achieve in notebooks.

**Locking your dependencies is specially useful** when creating Docker images
for our **products**. We must be able to exactly reproduce the build of our
images. If instead of creating our images with the already tested dependencies
(the ones in our lock file) we rely on the latest versions installed by `pip`,
there is no guarantee that the code will work.

For **libraries/frameworks we should include the information about our
dependencies** within the package. I do not mean to include all the related
wheels inside our wheel, no, just the metadata of what packages and versions
need to be installed with our package. I have seen libraries that contain a
`requirements.txt` file with pinned versions of its dependencies, but the
package is build without any information about those dependencies.

!!! Tip

    You know that your package does not have metadata about your requirements
    when you run a `pip install <your-package>` and just your package is
    installed.

    When using Poetry always use `poetry add <your-dependency>` instead of
    `pip install <your-dependency>`. The latter just installs the dependency
    in your local environment and does not add it to the package.

!!! Warning

    Remember to add your dependencies with lower and upper bounds on the
    versions to avoid surprises.


### Local development

Using Python libraries you can build, run and test your code locally, saving
costs in cloud computing. Most of the time we do not need to work on big
clusters or even on small clusters. Why to pay for a head node + 1 worker node
while we are just writing a complex query for 30 min? Write the code locally,
test the code with some sample data, deploy your code once you are sure it is
working and run it on production data.

No more excuses like _I couldn't develop because my internet was down_!

With local development comes the use of well-known Python tools like:

* Linters: `pylint`, `flake8`...
* Type checkers: `pyright`, `mypy`...
* Testing frameworks: `pytest`...
* Style checkers/formatters: `Black`...
* Your favourite IDE: `VIM`, `PyCharm`, `VSCode`...


## Python packages downsides

Nothing is perfect. With the use of Python packages come several problems:

* The **learning curve is steeper**. Especially in the world of data, many
people have only worked with notebooks and understanding how Python packages
work can take some extra time for them. I am not saying it is difficult, but it
does require some time which may delay the project.

* Libraries induce to abstract concepts using classes. Like notebooks,
object-oriented programming (OOP) is very powerful, but needs to be used well.
Unnecessarily complex design can lead to unmaintainable projects. The **right
balance between abstraction and complexity** must be found. I know it is
possible to use classes on notebooks but, in my experience, people get crazier
with classes when they work in libraries. Especially if their goal is to create
a super flexible framework.

* **Performance tuning** is a bit more difficult. A performance issue is
usually detected in the performance environment at best, or in the production
environment at worst. To work in such cases we need to test different queries
on a large collection of data that we cannot have locally. Copy and paste
functions/queries from the package into a notebook in an environment with a lot
of data may be needed. Another option is to build and deploy the package each
time a new change is made, which can be awkward.

* Most companies work with private code, so publishing to the public
package index is not an option. We **need a private package index** or just
deploy wheel files to a storage location. The recommended option is to have our
own private repository, otherwise deploying wheels in a storage folder becomes
very similar (and risky) as deploying notebooks in a directory. Setting up a
package index server is not difficult but, again, it needs to be done by
someone.


## Conclusions

**When are notebooks useful?**

* When we want to run ad-hoc queries/visualizations.
* When prototyping or running PoCs.
* When we want to experiment with data that takes some time to load in memory.

**When notebooks should be avoided?**

* When we want to deliver or reuse the solution as a whole (wheel package).
* When we want to have a better control on the versions (including parallel
versions).
* When proper testing is needed, including coverage and test reports.
* When we want to develop locally.
* When we want to write cloud-agnostic code (`dbutils` and some of the magic
work only on Databricks).
* When you want to use linters like `pylint` or `flake8`, type checkers like
`pyright`, your favourite IDE (VIM :heart:), auto formatting tools like
`Black`... In general, any tool that works with normal Python projects but do
not integrate well with notebooks.

As can be seen, there are many more reasons for not using them. Experiment as
much as you want with notebooks, but **please** :pray: do not try to build a
reliable and quality product around them. And if you do, **please** :pray:
don't call me to maintain it.
