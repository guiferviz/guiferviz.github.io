---
excerpt: >
    Ejemplo práctico.
    Paso a paso a través de la derivación matemática necesaria para estimar
    el parámetro de una distribución de Bernoulli con MLE.
date: 2019-10-18 19:40:00
tags: [Statistics]
comments: true
jsxgraph: true
---


# 🇪🇸 Maximum Likelihood Estimation - Parte 2

En esta segunda parte vamos a dar por hecho que se conoce el concepto de MLE
que fue visto en detalle en la [primera parte][mle1] de esta serie de dos
artículos.

Esta segunda parte es mucho más intensa y emocionante que la anterior. En la
primera parte se explica el concepto de forma gráfica y con un ejemplo
interactivo, pero una vez eso se tiene claro llega el momento de introducir
notación matemática 😬.

Tal y como dijimos en el anterior atículo, hoy demostraremos el porqué la
división $\frac{\text{# caras}}{\text{# lanzamientos}}$ nos devuelve el valor
del parámetro $p$ más *likelihood* en cualquier secuencia de lanzamientos de
una moneda.


## Requisitos

* Nociones muy básicas de estadística, como saber calcular la media de una
muestra.

* Conocer el concepto del Maximum Likelihood Estimation (MLE). Puedes
aprenderlo sin salir de este blog en la primera parte.

* Saber lo que es una derivada y cómo usarla para minimizar una función.


## Más monedas

Estuvimos trabajando con monedas y seguiremos con ellas durante este artículo.
En esta segunda parte vamos a hacer un esfuerzo por obtener expresiones
generales, que sirven para cualquier tipo de moneda y para cualquier resultado
obtenido por dicha moneda. No os quiero asustar con palabrería, vayamos paso a
paso. En primer lugar llamaremos $X$ al resultado obtenido tras lanzar $N$
monedas, es decir, $X$ es una lista con caras y cruces. La primera cara o cruz
corresponde al primer lanzamiento y así sucesivamente hasta el lanzamiento $N$.

$X = (X_1, X_2, \dots, X_N)$ Diremos que $X_i = 1$ cuando haya salido cara en
el lanzamiento $i$. Del mismo modo, diremos que $X_i = 0$ cuando el lanzamiento
$i$ haya sido cruz. En ambos casos $i = 1, 2, \dots, N$. Para que esto quede
claro vamos a ver un ejemplo. Suponed que lanzamos una moneda 3 veces y
obtenemos: <span class="head"></span> , <span class="head"></span> , <span
class="tail"></span>. ¿Cuál es el vector $X$ asociado a dicha secuencia de
lanzamientos? Muy sencillo: $X = (1, 1, 0)$.

Hagamos un pequeño repaso a las probabilidades de obtener cara o cruz. ¿Cuál es
la probabilidad de obtener cara?

<p style="text-align: center" markdown>
$P($<span class="head"></span>$) = P(X_i = 1) = p$
</p>

¿Cuál es la probabilidad de obtener cruz?

<p style="text-align: center" markdown>
$P($<span class="tail"></span>$) = P(X_i = 0) = 1 - p$
</p>

A modo de información extra, este tipo de distribución de probabilidad se le
conoce como distribución de
[*Bernoulli*](https://es.wikipedia.org/wiki/Distribuci%C3%B3n_de_Bernoulli).
Por lo tanto, en este artículo nos vamos a centrar en estimar el parámetro de
una distribución de *Bernoulli*, parámetro que en nuestro ejemplo con monedas
hemos llamado $p$.


## Yendo un poco más lejos

¿Cuál es la probabilidad de obtener $X_i$? *¿Cómo?* Me refiero a cuál es la
probabilidad de que en un lanzamiento $i$ (es decir, en cualquier lanzamiento)
se consiga el resultado obtenido. Posiblemente me diréis: pues eso depende del
resultado obtenido. No os equivocáis. Como ya hemos dicho antes, si $X_i = 1$
entonces la probabilidad es $p$ y si $X_i = 0$ la probabilidad es $1 - p$.
Vamos a juntar eso en una sola expresión:

$$P(X_i) = p^{X_i}(1 - p)^{1 - X_i}$$

En esa sola línea se resume la probabilidad de cada lanzamiento. Hemos
conseguido expresar la probabilidad de obtener un lanzamiento dado sin
importarnos realmente cuál es el resultado de dicho lanzamiento. Podemos verlo
como dos factores, por un lado $p^{X_i}$ y por otro lado $(1 - p)^{1 - X_i}$.
Cuando $X_i = 1$, entonces el segundo factor se neutraliza debido a que el
exponente pasa a valer 0 (cualquier número elevado a 0 es 1, lo que no modifica
la multiplicación). Cuando $X_i = 0$, es el primer factor el que se neutraliza.
Por lo tanto, al sustituir $X_i$ por su valor se obtiene exáctamente el mismo
valor de probabilidad que antes.

$$
\require{cancel}
\begin{align}
P(X_i = 1) &= p ^ 1 \cancelto{1}{(1 - p) ^ {1 - 1}} = p\\
P(X_i = 0) &= \cancelto{1}{p^{0}} (1 - p) ^ {1 - 0} = 1 - p
\end{align}
$$

Las probabilidades dependen del valor de $p$, es decir, están condicionadas al
valor de ese parámetro. Es por ello que muchas veces se utiliza la sintaxis
propia de las probabilidades condicionales $P(X_i\,\vert\,p)$. La forma de
escribirlo depende bastante del autor.


## Probabilidad conjunta

Ahora que sabemos cuál es la probabilidad de cada uno de los lanzamientos
podemos hallar la probabilidad de obtener todos los lanzamientos uno detrás de
otro, es decir $P(X\ \vert\ p)$. Sabemos que los lanzamientos son eventos
independientes, por lo que para obtener el valor de probabilidad de todos los
lanzamientos juntos basta con multiplicar la probabilidad de cada uno de los
lanzamientos (tal y como hicimos en los ejercicios de ejemplo de la [primera
parte][mle1]. Matemáticamente podemos expresar el valor de **probabilidad
conjunta** utilizando el productorio $\prod$ de la siguiente manera

$$P(X\ \vert\ p) = \prod_{i = 1}^{N} P(X_i\ \vert\ p) = \prod_{i = 1}^{N} p^{X_i}(1 - p)^{1 - X_i}$$

**Recapitulamos**: hemos encontrado la forma de expresar en una sola ecuación
la probabilidad de obtener un lanzamiento concreto sin importarnos del
resultado obtenido en dicho lanzamiento. Ahora hemos hallado la probabilidad de
obtener un conjunto de lanzamientos. Nos fijamos que esa expresión es muy
general, no nos importan ni saber cuál es el número de lanzamientos, ni saber
los resultados de dichos lanzamientos y tampoco el valor de $p$ asociado a la
moneda utilizada. Tal y como veníamos comentando en el anterior artículo, lo
que realmente nos interesa es, dado un conjunto de lanzamientos $X$, obtener el
valor del parámetro $p$ que maximice la probabilidad de obtener dicha $X$. Para
obtener ese valor debemos de maximizar $P(X\ \vert\ p)$.


## Función *Likelihood*

Vamos a definir una función que nos de el valor de probabilidad de $X$ en
función del valor del parámetro $p$. Al maximizar dicha función obtendremos el
valor de $p$ que mayor probabilidad obtene en esos datos. Esa función se conoce
como la **función *likelihood*** y se representa como

$$L(p;\ X) = P(X\ \vert\ p) = \prod_{i = 1}^{N} P(X_i\ \vert\ p).$$

Los dos puntos separan las variables de los parámetros fijos. Los valores $X_i$
no son conocidos pero son fijos, es decir, que nosotros queremos maximizar el
valor del parametro $p$ usando unos valores de $X_i$ que no cambiarán durante
el proceso (para más información mirar esta [pregunta de
*math.stackexchange*](http://math.stackexchange.com/questions/342268/what-does-the-semicolon-mean-in-a-function-definition)).
La forma de designar esta función varía bastante de un autor a otro. En muchos
textos en lugar de la letra $L$ se utiliza $\mathcal{L}$ para designar a la
función *likelihood*. Personalmente prefiero reservar $\mathcal{L}$ para los
multiplicadores de *Lagrange*, pero vamos, que no es algo relevante. Otros
simplemente escriben $L(p)$ dando por hecho la existencia de $X$.

Como deberías de saber para entender lo que viene a continuación, a la hora de
querer maximizar una función lo más común es utilizar la primera derivada e
igualarla a 0. Derivar $L(p;\ X)$ con ese productorio... complicado. Sería
ideal poder cambiar ese productorio por otra expresión mucho más sencilla de
derivar. Eso se consigue de una forma muy rápida, aplicando el logaritmo a la
función *likelihood*. La función *likelihood* devuelve una probabilidad, por lo
que se encuentra acotada entre 0 y 1. Vamos a recordar la forma de la **función
logaritmo**.

<script>
    window.addEventListener('load', function() {
        JXG.Options.text.useMathJax = true;
        var board = JXG.JSXGraph.initBoard('jxgbox1', {
            boundingbox: [-1, 2.0, 5.0, -2],
            showNavigation: false,
            axis: true,
            zoom: {
                factorX: 1.25,
                factorY: 1.25,
                wheel: true,
                needshift: false,
                eps: 0.1
            },
            pan: {
                needshift: false
            }
        });
        var graph = board.create('functiongraph', [function(x) {
            return Math.log(x);
        }]);
        board.create('text',[3, 1, function() { return '\\[\\ln\\ x\\]'; }], {
            fixed: true,
            fontSize: 20
        });
        board.fullUpdate();
    });
</script>

<p id="jxgbox1" style="margin-left: auto; margin-right: auto; max-width: 100%; max-height: 100vw; text-indent: 0px; width: 500px; height: 400px; overflow: hidden; position: relative;"></p>

Se observa que se trata de una función monótona creciente, es decir, que la
curva que representa la función nunca va para abajo. Para los más curiosos, el
"nunca va para abajo" se expresa matemáticamente con $\forall x \le y, f(x) \le
f(y)$ (para más información ver [funciones monótonas en
Wikipedia](https://es.wikipedia.org/wiki/Funci%C3%B3n_mon%C3%B3tona)). Esto
quiere decir que, si aplicamos el logaritmo a la función $L$, no cambiará el
máximo de la función. Dicha transformación nos permitirá derivar de forma más
sencilla y obtener el mismo máximo que si maximizáramos el productorio
original. Es importante darse cuenta de que los valores de la función
cambiarían (ya no estarían expresando la probabilidad de $X$), pero lo
importante es que el máximo es el mismo en las dos funciones. Tras aplicarle el
logaritmo, la función *likelihood* se suele designar con $\ell$ y se le llama
*log-likelihood*. Matemáticamente se define como

$$\ell(p;\ X) = \ln(L(p;\ X)) = \sum_{i = 1}^{N} \ln P(X_i\ \vert\ p).$$

No solo cambiamos el productorio por un sumatorio, sino que también eliminamos
el producto que encontrábamos al calcular la probabilidad de una sola moneda.

$$
\begin{align}
\ln P(X_i\ \vert\ p) &= \ln p^{X_i} + \ln (1 - p)^{1 - X_i}\\
&= X_i \ln p + (1 - X_i) \ln (1 - p)
\end{align}
$$

En esa última línea hemos hecho uso de la propiedad que dice $\ln a^b = b \ln
a$. La función completa quedaría de la siguiente manera:

$$
\ell(p;\ X) = \sum_{i = 1}^{N} \left[ X_i \ln p + (1 - X_i) \ln (1 - p) \right].
$$

Maximicemos pues la función $\ell(p;\ X)$ igualando a 0 la primera derivada, es
decir, $\dfrac{d \ell(p)}{d p} = 0$.

$$
\require{cancel}
\begin{align}
\dfrac{d \ell(p;\ X)}{d p} &= \sum_{i = 1}^{N} \left[ \dfrac{X_i}{p} + \dfrac{1 - X_i}{1 - p} \left(\dfrac{d (1 - p)}{d p}\right) \right] = \\
&= \sum_{i = 1}^{N} \left[ \dfrac{X_i}{p} + \dfrac{1 - X_i}{1 - p} (-1) \right] = \\
&= \sum_{i = 1}^{N} \left[ \dfrac{X_i}{p} - \dfrac{1 - X_i}{1 - p} \right] = \\
&= \sum_{i = 1}^{N} \left[ (1 - p) X_i - p (1 - X_i) \right] =\\
&= \sum_{i = 1}^{N} \left[ X_i - \cancel{X_i p} - p + \cancel{X_i p} \right] = \\
&= \sum_{i = 1}^{N} \left[ X_i - p \right] = \\
&= - N p + \sum_{i = 1}^{N} X_i = 0\\
\end{align}
$$

Por si alguien se ha perdido durante la derivación aclararé las 2 cosas que más
problemas pueden dar.

* $\dfrac{d \ln f(x)}{d x} = \dfrac{1}{f(x)} f'(x)$, siendo $f$ una función
cualquiera.

* $\sum_{i = 1}^{N} c = Nc$ siendo $c$ una constante cualquiera. En la
derivación el parámetro $p$ no cambia conforme cambiamos de lanzamiento $i$,
por lo que es una constante dentro de ese sumatorio.

Llegados a este punto solo queda despejar $p$ y obtenemos que

$$p = \dfrac{1}{N} \sum_{i = 1}^{N} X_i\text{.}$$

¿Os suena este resultado? Seguro que sí. Vamos a escribirlo utilizando palabras
más amigables.

$$p = \dfrac{\text{número de caras}}{\text{número de lanzamientos}}.$$

Se trata exáctamente de la misma expresión. El sumatorio cuenta el número de
caras puesto que $X_i = 1$ cuando el lanzamiento $i$ ha salido cara y $X_i = 0$
cuando ha sido cruz. El número de lanzamientos es $N$.

Debido a que el valor del parámetro $p$ es una estimación y no es su valor real
(no sabemos el valor real de la moneda que ha generado dichos lanzamientos) se
le suele poner un sombrerito encima $\hat{p}$. Por lo tanto finalmente tenemos
que $\hat{p} = \dfrac{1}{N} \sum_{i = 1}^{N} X_i\text{,}$ lo que traducido a
palabras significa que el valor de $p$ estimado con el MLE no es otra cosa que
el número de caras entre el número total de lanzamientos.


## ¿Qué hemos hecho?

A modo de resumen voy a exponer los pasos seguidos para obtener el resultado
final. En primer lugar hemos definido $X$ como una serie de lanzamientos de
una moneda. Hemos obtenido una expresión que nos permite hallar la probabilidad
de un lanzamiento dado, $P(X_i\ \vert\ p)$. Multiplicando el valor de
probabilidad de cada moneda obtenemos la probabilidad conjunta de todos los
lanzamientos, $P(X\ \vert\ p)$. Hemos creado una función, *likelihood
function*, que devuelve la probabilidad conjunta en función de $p$, $L(p;\
X)$. Con el objetivo de maximizar esa función le hemos aplicado el logaritmo
obteniendo así la función *log-likelihood*, $\ell(p;\ X)$. Igualamos la
primera derivada de esa función a $0$ y despejamos $p$ para obtener así la
estimación, es decir, $\hat{p}$.

A modo de práctica podrías intentar repetir tú solo el proceso y comprobar que
has llegado al mismo resultado. Deja pasar unos días para que se te olvide lo
que acabas de leer e inténtalo tú mismo a ver si lo sacas (estoy seguro de que
sí :).

Si encuentras cualquier fallo, ya sea hortográfico, algo mal explicado, algún
número que no está donde tiene que estar... lo que sea, déjame un comentario.
Cualquier duda que tengas también es bienvenida al tablón de comentarios.

Por cierto, lo de "hortográfico" era broma, solo quería comprobar si estabas
atento 😜.


## Créditos

* Las imágenes de las monedas son una modificación propia de varios ficheros
descargados desde [Freepik].

* La gráfica del logaritmo ha sido hecha con la ayuda de la librería
[JSXGraph].


<!-- REFERENCES AND STYLE -->

<script src="https://cdnjs.cloudflare.com/ajax/libs/jsxgraph/1.4.6/jsxgraphcore.js"></script>
<style>
.coin, .head, .tail {
    background-size: cover;
    display: inline-block;
    height: 2em;
    width: 2em;
    vertical-align: middle;
    margin-top: 1px;
}
.head {
    background-image: url("/assets/images/2018_10_18_coin_head.png");
}
.tail {
    background-image: url("/assets/images/2018_10_18_coin_tail.png");
}
.MathJax_Display > span.MathJax {
    overflow-y: hidden;
    overflow-x: auto;
    display: block;
    text-align: center;
    outline: 0;
}
</style>

[mle1]: /math/maximum-likelihood-estimation-1
[Freepik]: http://www.freepik.com
[JSXGraph]: http://jsxgraph.uni-bayreuth.de
