---
excerpt: >
    Entendiendo el simple concepto que está detrás de la Estimación por
    Máxima Verosimilitud (Maximum Likelihood Estimation).
    Contiene ejemplos interactivos.
date: 2019-10-18 19:39:00 +0900
tags: [Statistics]
comments: true
jsxgraph: true
---


# 🇪🇸 Maximum Likelihood Estimation - Parte 1

Si habéis llegado a este artículo de forma intencionada es muy posible que las
palabras ***Maximum Likelihood Estimation*** os digan algo. Este artículo va
dedicado a aquellas personas a las que esas palabras les dicen algo, pero algo
que no entienden.

En esta primera parte voy a explicar de forma sencilla y visual el conocido
concepto de *Maximum Likelihood Estimation*, a menudo abreviado con las siglas
**MLE**. En español el término es traducido como **Estimación por Máxima
Verosimilitud** (EMV), pero prefiero referirme a él con el término inglés
debido a que es como se puede encontrar en la gran mayoría de las publicaciones
científicas.

En la [segunda parte][mle2] veremos un ejemplo de aplicación del MLE.


<!-- ============================================================ -->

## Monedas

Cuando uno empieza a estudiar estadística, en lo primero que repara es en lo
importante que son las monedas. No creo que haya nadie que haya estudiado
estadística sin encontrarse con algún ejemplo o ejercicio en el que se lancen
monedas. En esta explicación nos apoyaremos nuevamente en ellas.

<figure markdown>
  ![Coin Heads](/assets/images/2018_10_18_coin_head.png){ width="70" }
  ![Coin Tail](/assets/images/2018_10_18_coin_tail.png){ width="70" }
  <figcaption>Cara y cruz</figcaption>
</figure>

Una **moneda normal** y corriente (que no está trucada), al ser lanzada existe
la misma probabilidad de que caiga cara o de que caiga cruz. Eso lo
expresaremos matemáticamente como:

<p style="text-align: center" markdown>
$P($<span class="head"></span>$) = P($<span class="tail"></span>$) = 0.5$
</p>

Sin embargo, existen otras monedas en las que la probabilidad de que caiga cara
es diferente a la probabilidad de que caiga cruz. Hablamos entonces de
**monedas trucadas**. En estos casos vamos a designar a la probabilidad de que
la moneda caiga cara con la letra $p$. Por lo tanto, la probabilidad de que
salga cruz es $1 - p$ (si no es cara, entonces es cruz).

<p style="text-indent: 0px; margin-left: 42.5%;" markdown>
$P($<span class="head"></span>$) = p$
<br />
$P($<span class="tail"></span>$) = 1 - p$
</p>

La expresión de encima de estas líneas funciona para cualquiera que sea el
valor de $p \in [0, 1]$. Como seguro os habréis dado cuenta, cuando $p = 0.5$
nos encontramos ante una moneda normal o no trucada. Este hecho hace de esta
expresión una expresión mucho más general, es decir, sirve para cualquier tipo
de moneda.


## Independencia de sucesos

Es imprescindible darse cuenta de que si hacemos varios lanzamientos de
monedas, son todos sucesos independientes entre sí. Si lanzas una moneda y cae
cara ¿condiciona ese hecho a que en el siguiente lanzamiento vuelva a salir
cara? La respuesta es no. Veamos ahora unos ejemplos de cómo se calcula la
probabilidad de varios lanzamientos.

**¿Cuál es la probabilidad de obtener <span class="tail"></span> , <span
class="head"></span> tras 2 lanzamientos con una moneda normal?**

Al tratarse de sucesos independientes entre sí, tenemos que

<p style="text-align: center;" markdown>
$P($<span class="tail"></span> , <span class="head"></span>$)
= P($<span class="tail"></span>$) \cdot P($<span class="head"></span>$)
= 0.5 \cdot 0.5
= 0.25$.
</p>

Es interesante darse cuenta que en este tipo de ejercicios no nos importa el
orden de las monedas, puesto que:

<p style="text-align: center;" markdown>
$P($<span class="tail"></span>, <span class="head"></span>$)
= P($<span class="tail"></span>$) \cdot P($<span class="head"></span>$)
= P($<span class="head"></span>$) \cdot P($<span class="tail"></span>$)
= P($<span class="head"></span>, <span class="tail"></span>$)$.
</p>

**¿Cuál es la probabilidad de obtener esa misma secuencia sea cual sea la
moneda utilizada?**

Tanto si consideramos que la moneda está trucada como que no, obtenemos que

<p style="text-align: center;" markdown>
$P($<span class="tail"></span> , <span class="head"></span>$)
= P($ <span class="tail"></span>$) \cdot P($<span class="head"></span>$)
= (1 - p) \cdot p.$
</p>

Si sustituimos $p$ por $0.5$ obtenemos exáctamente el mismo valor de antes, el
valor para una moneda normal: $(1 - 0.5) \cdot 0.5 = 0.5 \cdot 0.5 = 0.25$.

**¿Cuál es la probabilidad de obtener <span class="head"></span> , <span
class="head"></span> , <span class="head"></span> si $p = 0.1$?**

<p style="text-align: center;" markdown>
$P($<span class="head"></span>, <span class="head"></span>, <span class="head"></span>$)
= P($<span class="head"></span>$) \cdot P($<span class="head"></span>$) \cdot P($<span class="head"></span>$)
= P($<span class="head"></span>$)^3
= 0.1^3
= 0.001$
</p>

**¿Cuál es la probabilidad de obtener <span class="head"></span> , <span
class="head"></span> , <span class="head"></span> si $p = 0.9$?**

<p style="text-align: center;" markdown>
$P($<span class="head"></span>, <span class="head"></span>, <span class="head"></span>$)
= P($<span class="head"></span>$)^3
= 0.9^3
= 0.729$
</p>

Sé lo que estáis pensando, "¡qué preguntas más tontas me está haciendo!". Pues
sí, son ejercicios muy fáciles, pero quiero que os fijéis bien en las dos
últimas preguntas y me digáis qué valor de $p$ consigue una probabilidad más
alta. Con $p = 0.1$ se consigue $0.001$ y con $p = 0.9$ se consigue
$0.729$. ¿Hay algún otro valor de $p$ que consiga un valor más alto de
probabilidad para obtener 3 caras? La respuesta es sí, con $p = 1$ se
consigue una probabilidad de $1$.

Si calculamos la probabilidad de obtener 3 caras en función del parámetro $p$
obtenemos

<p style="text-align: center;" markdown>
$P($<span class="head"></span> , <span class="head"></span> , <span class="head"></span>$)
= P($<span class="head"></span>$)^3
= p^3$.
</p>

Ahora que tenemos esa expresión, vamos a representarla en una gráfica. Puesto
que $p$ es una probabilidad, el valor de ese parámetro se encuentra dentro del
intervalo $p \in [0, 1]$. Sobre la línea he marcado 3 puntos, los valores de
$p$ que ya hemos calculado. Comprobamos claramente que el valor de probabilidad
más alto se obtiene cuando $p = 1$, lo que confirma nuestro anterior cálculo.
Por comentar algo más de la gráfica, diremos que según ella no es posible
obtener 3 caras cuando $p = 0$ puesto que la función vale 0 al inicio. Esto
tiene mucho sentido puesto que no es posible obtener 3 caras al lanzar 3 veces
una moneda en la que nunca sale cara.

<script>
    window.addEventListener('load', function(){
        JXG.Options.text.useMathJax = true;
        var board = JXG.JSXGraph.initBoard('jxgbox1', {
            boundingbox: [-0.1, 1.1, 1.1, -0.1],
            showNavigation: false,
            axis: true
        });
        var graph = board.create('functiongraph', [function(p){
            var n_caras = 3;
            var n_cruces = 0;
            var max = n_caras / (n_caras + n_cruces);
            return Math.pow(p, n_caras) * Math.pow(1 - p, n_cruces);
        }, 0, 1]);
        var p1 = board.create('point', [0.1, 0.001], {
            label: true,
            fixed: true,
            name: "\\[p = 0.1\\]",
            label: {
                position: 'top',
                offset: [-10, 20]
            }
        });
        var p2 = board.create('point', [0.9, 0.729], {
            label: false,
            fixed: true,
            name: "\\[p = 0.9\\]",
            label: {
                position: 'top',
                offset: [-10, 20]
            }
        });
        var p3 = board.create('point', [1, 1], {
            label: false,
            fixed: true,
            name: "\\[p = 1\\]",
            label: {
                position: 'top',
                offset: [-10, 20]
            }
        });
        board.create('text', [1.00, 0.06, function() { return '\\[p\\]'; }], {fixed: true});
        board.fullUpdate();
    });
</script>

<p id="jxgbox1" style="margin-left: auto; margin-right: auto; max-width: 100%; max-height: 100vw; text-indent: 0px; width: 500px; height: 400px; overflow: hidden; position: relative;">
</p>


## Otro ejemplo

Vamos a observar otro ejemplo distinto en el que tras **tirar 10 veces una
misma moneda** obtenemos 8 caras y 2 cruces (recuerda que el orden no nos
importa en absoluto, cualquier combinación con 8 caras y 2 cruces tiene el
mismo valor de probabilidad). A diferencia de antes, ahora en los resultados
obtenidos encontramos tanto caras como cruces. ¿Cuál dirías que es el valor de
$p$ de dicha moneda? Posiblemente hayas realizado el cálculo $p = \frac{8
\text{ caras}}{10 \text{ lanzamientos}} = 0.8$. Pues lo cierto es que entre
cualquier posible valor de $p$, el $0.8$ es el valor más creíble, más
verosímil, más plausible, más *likelihood*... llámalo como quieras.

Si volvemos a representar la probabilidad en función de $p$ obtenemos la
siguiente gráfica:

<script>
  window.addEventListener('load', function(){
    JXG.Options.text.useMathJax = true;
    var board = JXG.JSXGraph.initBoard('jxgbox2', {
        boundingbox: [-0.1, 1.1, 1.1, -0.1],
        showNavigation: false,
        axis: false,
        offsetX: 1
    });
    var yaxis = board.create('axis', [[0, 0], [0, 1]], {
        ticks: {
            insertTicks: true,
            drawLabels: false,
            minorTicks: 0
        }
    });
    var xaxis = board.create('axis', [[0, 0], [1, 0]], {
        ticks: {
            drawZero: true,
            minorTicks: 0,
            drawLabels: false
        }
    });
    var xticks = board.create('ticks',
        [xaxis, [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1]],
        {
            drawLabels: true,
            label : {
                offset: [-2.5, -17.4]
            }
        });
    var n_caras = 8;
    var n_cruces = 2;
    var max = n_caras / (n_caras + n_cruces);
    var max_value = Math.pow(max, n_caras) * Math.pow(1 - max, n_cruces);
    var graph = board.create('functiongraph', [function (p) {
        return Math.pow(p, n_caras) * Math.pow(1 - p, n_cruces) / max_value;
    }, 0, 1]);
    var p3 = board.create('point', [max, 1], {
        showInfobox: false,
        label: false,
        fixed: true,
        name: "(" + max + ", " + max_value.toExponential(2) + ")"
    });
    board.create('text',[0.1, 0.7, function() { return String.raw`\[p ^ {n_{caras}} \cdot (1 - p) ^ {n_{cruces}}\]`; }], {
        fontSize: 24,
        highlightStrokeOpacity: 1,
        highlightFillOpacity: 1
    });
    board.create('text',[0.1, 0.5, function() { return String.raw`\[n_{caras} = 8\]`; }], {
        fontSize: 24,
        highlightStrokeOpacity: 1,
        highlightFillOpacity: 1
    });
    board.create('text',[0.1, 0.3, function() { return String.raw`\[n_{cruces} = 2\]`; }], {
        fontSize: 24,
        highlightStrokeOpacity: 1,
        highlightFillOpacity: 1
    });
    board.create('text',[1.06, -0.03, function() { return '\\[p\\]'; }], {fixed: true});
    board.fullUpdate();
  });
</script>

<p id="jxgbox2" style="margin-left: auto; margin-right: auto; max-width: 100%; max-height: 100vw; text-indent: 0px; width: 500px; height: 400px; overflow: hidden; position: relative;"></p>

El valor $p = 0.8$ es el más verosímil, pero al fin y al cabo, en 10
lanzamientos de una moneda normal ($p = 0.5$) puede pasar que nos salgan 8
caras. Es raro, pero puede pasar. Digamos que **cambiamos el número de
lanzamientos** por **100** y obtenemos 80 caras y 20 cruces, ¿cuál dirías que
es el valor de $p$ ahora? Al igual que antes, $p = \frac{80}{100} = 0.8$. Si
representamos gráficamente la probabilidad en función de $p$ obtenemos algo muy
similar a la última gráfica, solo que ahora el pico es mucho más estrecho, lo
que podemos interpretar como que es menos probable que tirando una moneda
normal se obtengan esos resultados. Antes decíamos que era raro obtener 8 caras
de 10 lanzamientos con una moneda normal, ahora decimos que es muy muy muy muy
raro, por no decir imposible, obtener 80 caras de 100 lanzamientos con una
moneda normal (comprueba la altura de la curva de la siguiente gráfica en $p =
0.5$ con la de la gráfica anterior).

<script>
  window.addEventListener('load', function(){
    var board = JXG.JSXGraph.initBoard('jxgbox3', {
        boundingbox: [-0.1, 1.1, 1.1, -0.1],
        showNavigation: false,
        axis: false,
        offsetX: 1
    });
    var yaxis = board.create('axis', [[0, 0], [0, 1]], {
        ticks: {
            insertTicks: true,
            drawLabels: false,
            minorTicks: 0
        }
    });
    var xaxis = board.create('axis', [[0, 0], [1, 0]], {
        ticks: {
            drawZero: true,
            minorTicks: 0,
            drawLabels: false
        }
    });
    var xticks = board.create('ticks',
        [xaxis, [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1]],
        {
            drawLabels: true,
            label : {
                offset: [-2.5, -17.4]
            }
        });
    var n_caras = 80;
    var n_cruces = 20;
    var max = n_caras / (n_caras + n_cruces);
    var max_value = Math.pow(max, n_caras) * Math.pow(1 - max, n_cruces);
    var graph = board.create('functiongraph', [function (p) {
        return Math.pow(p, n_caras) * Math.pow(1 - p, n_cruces) / max_value;
    }, 0, 1]);
    var p3 = board.create('point', [max, 1], {
        showInfobox: false,
        label: false,
        fixed: true,
        name: "(" + max + ", " + max_value.toExponential(2) + ")"
    });
    board.create('text',[0.1, 0.7, function() { return String.raw`\[p ^ {n_{caras}} \cdot (1 - p) ^ {n_{cruces}}\]`; }], {
        fontSize: 24,
        highlightStrokeOpacity: 1,
        highlightFillOpacity: 1
    });
    board.create('text',[0.1, 0.5, function() { return String.raw`\[n_{caras} = 80\]`; }], {
        fontSize: 24,
        highlightStrokeOpacity: 1,
        highlightFillOpacity: 1
    });
    board.create('text',[0.1, 0.3, function() { return String.raw`\[n_{cruces} = 20\]`; }], {
        fontSize: 24,
        highlightStrokeOpacity: 1,
        highlightFillOpacity: 1
    });
    board.create('text',[1.06, -0.03, function() { return '\\[p\\]'; }], {fixed: true});
    board.fullUpdate();
  });
</script>

<p id="jxgbox3" style="margin-left: auto; margin-right: auto; max-width: 100%; max-height: 100vw; text-indent: 0px; width: 500px; height: 400px; overflow: hidden; position: relative;"></p>

Como habéis podido observar, el **valor de $p$** que consigue la **probabilidad
más alta** de una secuencia de lanzamientos se puede obtener con

$$\dfrac{\text{# caras}}{\text{# lanzamientos}}$$

¿De dónde sale esa fórmula? Esa división que puede resultar muy natural y que
usamos a menudo sin plantearnos de dónde ha salido, se obtiene gracias al MLE
(en la segunda parte de este artículo veremos cómo se llega a ella). Por lo
tanto, MLE nos permite obtener el valor de un parámetro (en nuestro caso $p$)
para que tengan lugar de forma más probable un conjunto de observaciones
(resultados de los lanzamientos de una moneda). Muchos problemas de estadística
nos dicen: tenemos una moneda con $P($<span class="head"></span>$) = p$, ¿cuál
es la probabilidad de obtener $X$ secuencia de lanzamientos con ella?. MLE se
utiliza para dar respuesta a otra pregunta ligeramente distinta: teniendo una
secuencia de lanzamientos $X$, ¿cuál es el valor de $p$ que maximiza la
probabilidad de obtener dicha secuencia?


## Pruébalo tú mismo

Os he preparado un pequeño **gráfico interactivo** que os ayudará a comprender
las *likelihood functions*. En la parte superior del gráfico hay un par de
barras deslizantes que puedes cambiar a tu antojo. La primera de ellas
corresponde al número de veces que la moneda lanzada ha caído cara y la segunda
de ellas al número de veces que ha caído cruz. La función representada no es
más que la probabilidad en función de $p$ de obtener una serie de lanzamientos
con ese número de caras y cruces. Un punto rojo indica el máximo de la curva.

<script>
  window.addEventListener('load', function(){
    var board = JXG.JSXGraph.initBoard('jxgbox4', {
        boundingbox: [-0.1, 1.3, 1.1, -0.1],
        showNavigation: false,
        axis: false
    });
    var yaxis = board.create('axis', [[0, 0], [0, 1]], {
        ticks: {
            insertTicks: true,
            drawLabels: false,
            minorTicks: 0
        }
    });
    var xaxis = board.create('axis', [[0, 0], [1, 0]], {
        ticks: {
            drawZero: true,
            minorTicks: 0,
            drawLabels: false
        }
    });
    var xticks = board.create('ticks',
        [xaxis, [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1]],
        {
            fixed: true,
            drawLabels: true,
            label : {
                offset: [-2.5, -17.4]
            }
        });
    var slider_caras = board.create('slider', [[0.1,1.2],[0.7,1.2],[0, 5, 10]], {
        //name: String.raw`\[n_{caras}\]`,
        name: 'n_{caras}',
        snapWidth: 1,
        precision: 0
    });
    var slider_cruces = board.create('slider', [[0.1,1.1],[0.7,1.1],[0, 5, 10]], {
        //name: String.raw`\[n_{cruces}\]`,
        name: 'n_{cruces}',
        snapWidth: 1,
        precision: 0
    });
    var p3 = board.create('point', [0.5, 1], {
        showInfobox: false,
        fixed: true,
        label: {
            position: 'top',
            offsets: [-50, 10]
        }
    });
    var graph = board.create('functiongraph', [function(p){
        var n_caras = slider_caras.Value();
        var n_cruces = slider_cruces.Value();
        var max = n_caras / (n_caras + n_cruces);
        var max_value = Math.pow(max, n_caras) * Math.pow(1 - max, n_cruces);
        if (p == 0) {  // Importante para actualizar el punto máximo solo una vez y no cada punto de la curva.
          p3.setName("(" + max.toFixed(2) + ", " + max_value.toExponential(2) + ")");
          p3.setPosition(JXG.COORDS_BY_USER, [max, 1]);
        }
        return Math.pow(p, n_caras) * Math.pow(1 - p, n_cruces) / max_value;
    }, 0, 1]);
    board.fullUpdate();
  });
</script>

<p id="jxgbox4" style="margin-left: auto; margin-right: auto; max-width: 100%; max-height: 100vw; text-indent: 0px; width: 500px; height: 400px; overflow: hidden; position: relative;"></p>


## Algunas observaciones

Antes de terminar me gustaría aclarar algunas cosas que quizás respondan a
dudas que te hayan surgido conforme leías el artículo. Puede que estés pensando
si el área que se encuentra bajo la curva (integral) de la función *likelihood*
debe de sumar 1. Eso no ocurre prácticamente nunca. En el ejemplo interactivo,
parece que la función siempre tenga su máximo a la misma altura, eso es debido
a que se ha llevado a cabo un proceso de normalización con la idea de poder
observar perfectamente la curva entera sin tener que hacer zoom en la figura.
Cuanto mayor es el número de lanzamientos, la altura máxima de la curva
disminuye a valores realmente bajos (con 10 caras y 10 cruces el máximo es del
orden de $10^{-6}$). En la práctica, el valor de la función no importa, sólo
nos importa dónde se encuentra el máximo. Es por dicha razón por las que no se
muestran las unidades del eje $y$.

¿Has jugado ya con el ejemplo interactivo?  Si no lo has hecho te recomiendo
por lo menos llevar a cabo alguna de estas pruebas.

* Pon a 0 las dos barras deslizantes. Después selecciona una de ellas y ve
aumentándola poco a poco. ¿Qué observas?

* Pon a 0 las dos barras deslizantes. Después incrementa al mismo tiempo ambas
barras. ¿Qué observas?

* Fíjate también en el valor de probabilidad del punto máximo (la coordenada
$y$ del punto rojo) ¿Qué le pasa conforme aumenta el número total de
lanzamientos?


## Para saber más

Creo que con lo visto en este artículo ha quedado claro cuál es el cometido del
MLE. Para explicarlo no hemos hecho uso de expresiones matemáticas complejas,
solo estadística básica. En la [segunda parte][mle2] de este artículo
introduciremos notación matemática y veremos en acción esta técnica de
estimación de parámetros. El ejemplo será la derivación matemática necesaria
para llegar a obtener porqué el valor de $p$ que más probabilidad consigue en
cualquier secuencia de lanzamientos es $\frac{\text{# caras}}{\text{#
lanzamientos}}$. ¡Nos vemos en la segunda parte!


## Créditos

* Las imágenes de las monedas son una modificación propia de varios ficheros
descargados desde [Freepik].

* Las gráficas interactivas han sido hechas con la ayuda de la librería
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
</style>

[mle2]: /math/maximum-likelihood-estimation-2
[Freepik]: http://www.freepik.com
[JSXGraph]: http://jsxgraph.uni-bayreuth.de
