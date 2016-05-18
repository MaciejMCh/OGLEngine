
uniform sampler2D uReflectionColorMap;

varying lowp vec2 vTexel;
varying lowp vec4 vClipSpace;

void main() {
    lowp vec2 ndc = (vClipSpace.xy / vClipSpace.w) / 2.0 + 0.5;
    lowp vec4 reflectionColor = texture2D(uReflectionColorMap, vec2(ndc.x, ndc.y));
    lowp vec4 surfaceColor = vec4(0.0, 0.1, 0.1, 1.0);
    gl_FragColor = reflectionColor + surfaceColor;
}