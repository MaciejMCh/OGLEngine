
uniform sampler2D uColorMap;

varying lowp vec2 vTexel;
varying lowp vec3 vLightDirection;
varying lowp vec3 vLightHalfVector;

void main() {
    gl_FragColor = texture2D(uColorMap, vTexel * 5.0);
}