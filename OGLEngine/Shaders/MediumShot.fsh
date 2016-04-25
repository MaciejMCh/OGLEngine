
uniform sampler2D uColorMap;

varying lowp vec2 vTexel;
varying lowp vec3 vNormal;
varying lowp vec3 vLightDirection;
varying lowp vec3 vLightHalfVector;

void main() {
    lowp vec3 normalizedNormal = normalize(vNormal);
    lowp float NdotL = max(0.0, dot(normalizedNormal, -vLightDirection));
    lowp float NdotH = max(dot(normalizedNormal, vLightHalfVector),0.0);
    lowp vec4 specular = vec4(1.0 , 1.0 , 1.0 , 1.0) * pow(NdotH,100.0);
    gl_FragColor = NdotL * texture2D(uColorMap, vTexel) + specular;
}