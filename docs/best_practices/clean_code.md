# Clean code

In this document I will go through what I
consider to be bad practices explaining why they are bad and how I think they
could be better addressed.


## Numbering steps

Do not use numbers to set an order in your functions/files/notebooks.

Why? Code is dynamic, we are continuously adding/removing features. What we
consider step 2 at the beginning of the project could be step 10 at the end. If
I we need to add a new step between the step 1 and 2 we usually have two
options:

1. We rename all the steps from 2 onwards.
2. We create a step 1a or 1_1.

Renaming takes time, introduces a lot of changes on Git PRs, it's risky if we
do not update the related Airflow code... Creating intermediate steps is
confusing, specially if the new step is not related at all with the previous
step.

The proposed solution is to clearly define a main/orchestrator file that sets
the order. We can have a list of steps somewhere in the code, if we add a new
element in the second position of the list we do not need to modify anything
else if we are not using numbers in the names. If someone wants to know the
exact order should go to that file.

Sometimes we might even realise at a late stage that it is better to call step
3 before step 2 and so define it in the orchestrator. Numbers would not only
not be helpful but even confusing. The numbers would be behaving like an
outdated comment in this example. Reading what we have defined in the
orchestrator is indeed the only way to be sure about the real order of the
steps.

Conclusion: Do not use numbers, they are confusing. Define the order in the
code, you can always trust code.

Note: numbering here means provide explicit order in the name. Using letters like
a, b, c... is also equivalent to numbering.
