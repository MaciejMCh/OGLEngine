
uniform sampler2D uColorMap;

varying lowp vec2 vTexel;
varying lowp vec3 vLightDirection;
varying lowp vec3 vLightHalfVector;

void main() {
    lowp vec4 color = texture2D(uColorMap, vTexel * 5.0);
    gl_FragColor = vec4(1.0, 0.0, 1.0, 1.0);
}