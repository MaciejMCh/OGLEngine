
attribute vec4 aPosition;
attribute vec2 aTexel;
attribute vec3 aNormal;

uniform mat4 uModelViewProjectionMatrix;
uniform mat3 uNormalMatrix;
uniform vec3 uLightDirection;
uniform vec3 uLightHalfVector;
uniform float uTextureScale;

varying lowp vec2 vTexel;
varying lowp vec3 vNormal;
varying lowp vec3 vLightDirection;
varying lowp vec3 vLightHalfVector;

void main() {
    vTexel = aTexel * uTextureScale;
    vLightDirection = uLightDirection;
    vLightHalfVector = uLightHalfVector;
    vNormal = normalize(uNormalMatrix * aNormal);
    vec4 position = uModelViewProjectionMatrix * aPosition;
    
    gl_Position = position;
}