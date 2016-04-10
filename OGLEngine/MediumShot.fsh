
uniform sampler2D uColorMap;

varying lowp vec2 vTexel;
varying lowp vec3 vNormal;
varying lowp vec3 vLightDirection;
varying lowp vec3 vLightHalfVector;

void main() {
    lowp float NdotL = max(0.0, dot(vNormal, -vLightDirection));
    gl_FragColor = NdotL * texture2D(uColorMap, vTexel * 5.0);
}