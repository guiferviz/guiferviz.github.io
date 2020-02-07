```python
%matplotlib inline
import matplotlib.pyplot as plt

import numpy as np


N_ELEMENTS = 10
SEED = 124
```


```python
def get_random_list(n_elements):
    np.random.seed(SEED)
    random_list = np.arange(0, n_elements) - n_elements
    random_list = np.random.permutation(random_list)
    return random_list

random_list = get_random_list(N_ELEMENTS)
random_list
```




    array([ -4,  -2,  -7,  -5,  -6, -10,  -1,  -8,  -3,  -9])




```python
#len(iter(random_list))
```


```python
def sample_list(random_iter):
    random_list = [i for i in random_iter]
    length = len(random_list)
    idx = np.random.randint(0, length - 1)
    return random_list[idx]

sample_list(iter(random_list))
```




    -10




```python
def test_sample_method(method, random_list, n_times):
    samples = []
    for i in range(n_times):
        samples.append(method(iter(random_list)))
    plt.hist(samples)

test_sample_method(sample_list, random_list, 40)
```


![png](output_4_0.png)



```python
test_sample_method(sample_list, random_list, 10000)
```


![png](output_5_0.png)



```python
def sample_list(random_iter):
    random_list = [i for i in random_iter]
    length = len(random_list)
    idx = np.random.randint(0, length)
    return random_list[idx]

test_sample_method(sample_list, random_list, 10000)
```


![png](output_6_0.png)



```python
def sample_reservoir(random_iter):
    sample = next(random_iter)
    for i, n in enumerate(random_iter):
        if np.random.randint(0, i + 1) == 0:
            sample = n
    return sample

sample_reservoir(iter(random_list))
```




    -8




```python
test_sample_method(sample_list, random_list, 10000)
```


![png](output_8_0.png)



```python

```
