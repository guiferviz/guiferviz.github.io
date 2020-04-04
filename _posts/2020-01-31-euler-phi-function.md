---
layout: post

title: Euler Phi/Totient function
excerpt: "Aprendiendo sobre la función Phi de Euler motivado por la resolución de un problema de CodeForces."
date: 2020-01-31
tags: [Math, CodeForces, Euler]

mathjax: true
comments: true
---

Esta semana me topé con
[este problema](https://codeforces.com/contest/1295/problem/D)
en una competición de CodeForces.
Yo sabía que no se resolvía por fuerza bruta (sí, soy un hacha :P), pero la
pregunta era ¿con qué se resuelve pues?
Primero analicemos el problema y luego os presentaré a la función matemática
aliada que nos ayudará en la batalla contra este enunciado.

El enunciado es el siguiente.
Tenemos dos números enteros $$a$$ y $$m$$ y el problema nos pide que contemos
cuantos valores puede tomar el entero $$x$$ tal que $$0 \le x < m$$ y se cumpla
$$\gcd(a, m) = \gcd(a + x, m)$$.
$$\gcd$$ representa el máximo común divisor (*greatest common divisor*).


# Greatest common divisor

Lo primero es tener claro lo que significa el **máximo común divisor**.
El máximo común divisor de dos números cualesquiera es la intersección de los
factores primos que forman dichos números.
Esta imagen de Wikipedia debería dejar más clara la definición:

<p>
<center>
<img alt="máximo común divisor explicado gráficamente"
     width="300"
     src="/assets/images/2020_01_31_gcd_48_60.jpg" />
</center>
<figcaption>
Máximo común divisor explicado gráficamente.
La intersección de los factores primos de 48 y 60 es: 2, 2, y 3.
Por lo tanto, el \(\gcd(48, 60) = 2 \cdot 2 \cdot 3 = 12\).
Dicho de otra forma, 12 es el número máximo que puede dividir de manera exacta
a 48 y 60.
(Imagen: Wikipedia)</figcaption>
</p>

El máximo común múltiplo se resuelve eficientemente usando un algoritmo
conocido desde tiempos de la antigua Grecia.
Se trata del
[algoritmo de Euclides](https://es.wikipedia.org/wiki/Algoritmo_de_Euclides).


# Desarrollo del problema

Una vez entendidos todos los elementos que aparecen en el enunciado del
problema podemos proceder con su resolución.

Definamos $$y = a + x$$.
¿Qué podemos decir de los valores de $$y$$ que cumplen el requerimiento del
enunciado?
Sabemos que $$y \in [a, a + m)$$ por la propia definición de $$x$$ dada
en el enunciado.
¿Qué más sabemos?
Sabemos que entre los factores primos que componen $$y$$ deben encontrarse
aquellos que componen $$\gcd(a, m)$$, y pueden contener otros factores
distintos de aquellos que componen $$\frac{m}{\gcd(a, m)}$$ (es decir, los
factores que componen $$m$$ excepto aquellos que forman parte del
$$\gcd(a, m)$$).
Utilicemos los números $$a=48$$ y $$m=60$$ del ejemplo de la anterior imagen
para aclarar esto último que he dicho.
$$\gcd(48, 60) = 2 \cdot 2 \cdot 3 = 12$$.
$$y$$ debe de tener 2, 2, y 3 entre sus factores pero no el 5.
Si no tuviera ni 2, 2 o 3 entre sus factores, o si tuviera el 5,
$$\gcd(y, 60)$$ sería distinto del 12.
Dicho de otra forma, $$y$$ debe de ser un múltiplo de 12 que no contenga el 5
entre sus factores.

Vamos a definir $$y = 12 \cdot k$$, ¿cuántos valores de $$k$$ no contienen el
número 5 entre sus factores?
Dicho de otra forma, ¿cuántos números primos relativos a 5 hay?
Realmente hay infinitos, pero ¿cuántos hay en el rango
$$y \in [a, a + m) = [48, 48+60)$$?
Los valores que puede tomar $$k$$ son 4, 5, 6, 7 y 8 para que $$y$$ esté en el
rango indicado.
De todos esos, obviamente el 5 no es primo relativo de 5.
Por lo que los valores válidos de $$k$$ son 4.

¿Cómo podemos simplificar ese cálculo?
Para ello hay que darse cuenta de una cosa.
Para todo valor de $$y > m, \gcd(y, m) = \gcd(y - m, m)$$.
Si esto no te convence haz una pausa y convéncete a ti mismo de que esto es
así.
Busca recursos sobre el máximo común divisor para entenderlo mejor.
Además, como $$0 \le x < m$$, sabemos que hay $$m$$ valores distintos de $$x$$.
Esto básicamente transforma nuestra pregunta a:
¿cuántos valores de $$k$$ menores de 5 son coprimos de 5?


# Euler Phi function o Euler Totient function

¿Cómo podemos automatizar este cálculo?
La respuesta directa a esta pregunta la da la función $$\varphi(n)$$ de Euler,
también conocida como la función indicatriz de Euler (*Totient function* en
inglés).
Esta función devuelve la cantidad de números menores de $$n$$ que son
primos relativos de $$n$$.
Justo lo que necesitamos.
Normalmente se define la función $$\varphi(n)$$ como la cantidad de números
menores que $$n$$ coprimos de $$n$$.
Realmente, definirla que sea menor o menor igual da lo mismo puesto que si es
igual compartirían todos los factores primos.

Puesto que esta función nos da lo que necesitamos, lo que debemos programar es:

$$
\varphi\left(\dfrac{m}{\gcd(a, m)}\right)
$$

Vamos a ir desgranando el comportamiento de esta función.
Empezando con una definición formal, que no viene siendo más que la forma
matemática de escribir lo comentado en el párrafo anterior.

$$
\varphi(m)=|\{n\in \mathbb{N} |n\leq m\land \mathrm {mcd} (m,n)=1\}|
$$

$$\varphi(m)$$ es el número de elementos (denotado por $$|\cdot|$$) del
conjunto ($$\{\cdot\}$$) formado por los números naturales (\mathbb{N}, no
incluye el 0) que son menores de $$m$$ y que son primos relativos o coprimos
de $$m$$ (dicho de otra forma, $$\gcd(m, n) = 1$$).

Empecemos con algún ejemplo.
Supongamos que queremos obtener todos los números menores de 11 y coprimos
a 11.
Pues bien, es fácil darse cuenta de que 11 es un número primo, por lo que hay
10 números naturales menores que 11 que no comparten ningún factor primo con
él:
<br />
$$
\varphi(11) = |\{1, 2, 3, 4, 5, 6, 7, 8, 9, 10\}| = 10
$$

Siendo $$p$$ un número primo, la fórmula general es:

$$
\varphi(p) = p - 1
$$

¿Qué pasa con $$\varphi(8)$$?
<br />
$$
\require{cancel}
\varphi(8) = |\{1, \xcancel{2}, 3, \xcancel{4}, 5, \xcancel{6}, 7\}| = 4
$$

8 no es primo, pero puede descomponerse fácilmente en $$2^3$$.
En lugar de pintarlo como una lista vamos a distribuirlo como una matriz con
$$p$$ columnas:
<br />
$$
\require{cancel}
\varphi(3^2) =
\left|
\begin{Bmatrix}
1 & \xcancel{2} \\
3 & \xcancel{4} \\
5 & \xcancel{6} \\
7 & \xcancel{8}
\end{Bmatrix}
\right|
= 4
$$

Se observa que la última columna contiene todos los múltiplos de $$p$$,
lo cuál es bastante obvio porque la última columna es la columna $$p$$.
Para extraer la fórmula general de $$\varphi(p^n)$$ quizás sea útil pintar
otro ejemplo.
Pintemos $$\varphi(3^2)$$:
<br />
$$
\require{cancel}
\varphi(3^2) =
\left|
\begin{Bmatrix}
1 & 2 & \xcancel{3} \\
4 & 5 & \xcancel{6} \\
7 & 8 & \xcancel{9}
\end{Bmatrix}
\right|
= 6
$$

Puedes pintar algunos casos más si lo deseas, pero yo paso directamente a
mostrarte la expresión general.
La forma de calcularlo es tomando el total de números y restándole la
cantidad de números que hay en la última columna:

$$
\varphi(p^n) = p^n - p^{n - 1} = p^{n - 1} (1 - p^n)
$$

Seguimos. ¿Cuánto vale $$\varphi(15)$$?
15 no es primo ni es la potencia de un primo, así que la fórmula anteriormente
expuesta no sirve.
$$15 = 3 \cdot 5$$, por lo que cualquier número menor de 15 que esté formado
por el factor primo 3 o el factor primo 5 no es coprimo de 15 y no debemos de
contarlo.
<br />
$$
\require{cancel}
\varphi(15) = |\{1, 2, \xcancel{3}, 4, \xcancel{5}, \xcancel{6},
7, 8, \xcancel{9}, \xcancel{10}, 11, \xcancel{12}, 13, 14,
\xcancel{15}\}| = 8
$$

De nuevo, pintemos en forma de matriz los números:
<br />
$$
\require{cancel}
\varphi(15) =
\left|
\begin{Bmatrix}
1           &           2 & \xcancel{3} \\
4           & \xcancel{5} & \xcancel{6} \\
7           &           8 & \xcancel{9} \\
\xcancel{10}&          11 & \xcancel{12}\\
         13 &          14 & \xcancel{15}
\end{Bmatrix}
\right|
= 8
$$

Esta vez es un poco más difícil de verlo, pero tenemos que
$$\varphi(15) = \varphi(3) \varphi(5) = 2 \cdot 4 = 8$$.
Si calculamos el resto (operación módulo) de cada uno de los valores al
dividirlos entre 3, todos los números de una columna dan el mismo resto:
la primera columna resto 1, la segunda columna resto 2 y la última columna
resto 0.
Si calculamos el resto para el 5 obtenemos que en cada columna los restos son
todos distintos unos a otros, es decir, que los restos van de 0 a 4.
Por ejemplo, en la primera columna de arriba a abajo los restos son:
1, 4, 2, 0 y 3.
Todos los números son distintos, y solo el elemento que da de resto 0 es
múltiplo de 5.

Esto se puede probar más rigurosamente pero no lo haré en este artículo.
En las referencias podrás encontrar otros recursos que profundizan más en el
tema.

De forma más general, para cualquier número
$$n = p_1^{e_1} p_2^{e_2} \ldots p_t^{e_t}$$, siendo $$p_i^{e^i}$$ el $$i$$
primo que lo compone $$n$$, se puede escribir la siguiente expresión general:
$$
\displaystyle
\begin{aligned}
\varphi(n)&=\varphi(p_1^{e_1} p_2^{e_2} \ldots p_t^{e_t}) \\
          &=\varphi(p_1^{e_1}) \varphi(p_2^{e_2}) \ldots \varphi(p_t^{e_t}) \\
          &=p_1^{e_1-1} (p_1-1) \cdot p_2^{e_2-1} (p_2-1) \cdot \ldots \cdot p_t^{e_t-1} (p_t-1) \\
          &=p_1^{e_1} \left(1-\frac{1}{p_1}\right) \cdot p_2^{e_2} \left(1-\frac{1}{p_2}\right) \cdot \ldots \cdot p_t^{e_t} \left(1-\frac{1}{p_t}\right) \\
          &=p_1^{e_1} p_2^{e_2} \ldots p_t^{e_t} \cdot \biggl(1-\frac{1}{p_1}\biggr) \biggl(1-\frac{1}{p_2}\biggr) \ldots \biggl(1-\frac{1}{p_t}\biggr) \\
          &=n \cdot \biggl(1-\frac{1}{p_1}\biggr) \biggl(1-\frac{1}{p_2}\biggr) \ldots \biggl(1-\frac{1}{p_t}\biggr) \\
          &=n \prod _{i=1}^{t}\left(1-{\frac {1}{p_{i}}}\right)
\end{aligned}
$$


# Implementación

La implementación no tiene mayor historia, es implementar una factorización
y posteriormente una multiplicación de los primos (ignorando el exponente
de dichos primos).

La implementación de $$\gcd(a, b)$$ que usamos es la que está incluida en
el módulo estándar de Python `math`.

```python
def prime_factors(n):
    """Return a list of the prime factors that compose n. """

    # Factorization is defined for natural numbers.
    assert n > 0

    # Base case.
    if n == 1:
        return [1]

    f = []
    # Check 2 first for saving half iterations in the next for loop.
    while n % 2 == 0:
        f.append(2)
        n /= 2
    # Check the odd numbers.
    for i in range(3, int(n**0.5) + 1, 2):
        while n % i == 0:
            f.append(i)
            n /= i

    # Prime number case.
    if n > 1:
        f.append(int(n))

    return f


def eulers_phi_fun(n):
    """Euler's Totient function. """

    f = prime_factors(n)
    val = n
    # Iterate for the unique list of primes.
    for i in set(f):
        val *= 1 - 1 / i
    return int(val)


def solve(a, m):
    """Solve problem for the given a and m. """

    gcd = math.gcd(a, m)
    n = m / gcd
    phi = eulers_phi_fun(n)
    print(phi)
```


# Referencias

Aquí te dejo una lista de enlaces que me ayudaron a entender de qué iba eso de
la función $$\varphi$$ de Euler.
No solo explica qué es, sino que incluye muy buenos ejemplos y demostraciones
para entenderla en profundidad.

Altamente recomendados estos dos vídeos de  Michael Penn:
* [YouTube - Number Theory | Euler's Totient Function: Definition and Basic Example](
https://www.youtube.com/watch?v=qIipeyQlLnQ)
* [YouTube - The Multiplicativity of Euler's Totient Function](
https://www.youtube.com/watch?v=HdpQk5cPB8Q&t=618s)

Otros recursos:
* [Totient function en Wolfram Alpha](http://mathworld.wolfram.com/TotientFunction.html)
* [Totient function en Wikipedia](https://en.wikipedia.org/wiki/Euler%27s_totient_function)
* [YouTube - Euler's Phi function proof](
https://www.youtube.com/watch?v=BHn97iCZLm4)

