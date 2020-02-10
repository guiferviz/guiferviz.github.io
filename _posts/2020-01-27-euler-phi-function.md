---
layout: post

title: Euler Phi/Totient function
excerpt: ""
date: 2020-01-31
tags: [Math, CodeForces, Euler]

mathjax: true
comments: true
---

Que sea menor o menor igual da lo mismo puesto que si es igual, m sería igual
a m, por lo que compartirían todos los factores primos.

$$
\displaystyle
\begin{aligned}
\phi(m)&=\phi(p_1^{e_1} \cdot p_2^{e_2} \cdots p_t^{e_t}) \\
       &=\phi(p_1^{e_1}) \times \phi(p_2^{e_2}) \times \cdots \times \phi(p_t^{e_t}) \\
       &=p_1^{e_1-1} \cdot (p_1-1) \times p_2^{e_2-1} \cdot (p_2-1) \times \cdots \times p_t^{e_t-1} \cdot (p_t-1) \\
       &=p_1^{e_1} \cdot \biggl(1-\frac{1}{p_1}\biggr) \times p_2^{e_2} \cdot \biggl(1-\frac{1}{p_2}\biggr) \times \cdots \times p_t^{e_t} \cdot \biggl(1-\frac{1}{p_t}\biggr) \\
       &=p_1^{e_1} \cdot p_2^{e_2} \cdots p_t^{e_t} \cdot \biggl(1-\frac{1}{p_1}\biggr) \times  \cdot \biggl(1-\frac{1}{p_2}\biggr) \times \cdots \times  \cdot \biggl(1-\frac{1}{p_t}\biggr) \\
       &=m \cdot \biggl(1-\frac{1}{p_1}\biggr) \times  \cdot \biggl(1-\frac{1}{p_2}\biggr) \times \cdots \times  \cdot \biggl(1-\frac{1}{p_t}\biggr)
\end{aligned}
$$

# Ejemplos de problemas

Aquí una pequeña lista de problemas que se pueden resolver utilizando el
operador módulo.


# Refs

* http://mathworld.wolfram.com/TotientFunction.html
* https://en.wikipedia.org/wiki/Euler%27s_totient_function
* Number Theory | Euler's Totient Function: Definition and Basic Example
https://www.youtube.com/watch?v=qIipeyQlLnQ
* The Multiplicativity of Euler's Totient Function
https://www.youtube.com/watch?v=HdpQk5cPB8Q&t=618s

