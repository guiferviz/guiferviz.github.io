---
template: overrides/index.html
---

hola 
<script>
    window.addEventListener("load", function () {
        var sketch = function( p ) {
            // Taken from https://p5js.org/es/reference/#/p5/createShader
            let varying = `
                precision highp float;
                varying vec2 vPos;
            `;

            let vs = varying + `
                attribute vec3 aPosition;
                void main() {
                    vPos = (gl_Position = vec4(aPosition,1.0)).xy;
                }
            `;

            let fs = varying + `
                uniform vec2 p;
                uniform float r;
                const int I = 150;
                void main() {
                    vec2 c = p + vPos * r, z = c;
                    float n = 0.0;
                    for (int i = I; i > 0; i --) {
                        if (z.x*z.x+z.y*z.y > 4.0) {
                            n = float(i)/float(I);
                            break;
                        }
                        z = vec2(z.x*z.x-z.y*z.y, 2.0*z.x*z.y) + c;
                    }
                    gl_FragColor = vec4(
                        0.5-cos(n*17.0)/2.0,
                        0.5-cos(n*13.0)/2.0,
                        0.5-cos(n*19.0)/2.0,
                        1.0
                    );
                }
            `;

            let shader, logo, shaderTexture;
            let width = 1080/2;
            let height = 720/3;

            p.preload = function () {
                logo = p.loadImage("assets/images/logo_white.png");
            };

            p.setup = function () {
                p.createCanvas(width, height, p.WEBGL);

                p.smooth();

                shaderTexture = p.createGraphics(width, height, p.WEBGL);
                shader = shaderTexture.createShader(vs, fs);
                shaderTexture.shader(shader);
                shaderTexture.noStroke();
                shader.setUniform("p", [-0.74364388703, 0.13182590421]);
            };

            p.draw = function () {
                let r = 2.5 * p.exp(-6.5 * (1 + p.sin(p.millis() / 3000)));
                shader.setUniform("r", r);
                shaderTexture.quad(-1, -1, 1, -1, 1, 1, -1, 1);

                p.push();
                p.texture(shaderTexture);
                p.rect(-width/2, -height/2, width, height);
                p.pop();

                p.push();
                p.scale(0.3*2.5/r);
                p.image(logo, width*0.1, 0);
                p.pop();
            };
        };

        var myp5 = new p5(sketch, "my-container");
    });
</script>
