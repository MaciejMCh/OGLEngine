
uniform sampler2D uReflectionColorMap;

varying lowp vec2 vTexel;

void main() {
    lowp vec4 reflectionColor = texture2D(uReflectionColorMap, vTexel);
    lowp vec4 surfaceColor = vec4(0.0, 0.1, 0.1, 1.0);
    gl_FragColor = reflectionColor + surfaceColor;
}