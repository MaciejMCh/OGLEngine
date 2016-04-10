
attribute vec4 aPosition;
attribute vec2 aTexel;
attribute vec3 aNormal;

uniform mat4 uModelViewProjectionMatrix;
uniform mat3 uNormalMatrix;
uniform vec3 uLightDirection;
uniform vec3 uLightHalfVector;

varying lowp vec2 vTexel;
varying lowp vec3 vLightDirection;
varying lowp vec3 vLightHalfVector;




uniform mat4 uModelMatrix;
uniform mat4 uViewMatrix;
uniform mat4 uProjectionMatrix;


void main() {
    vTexel = aTexel;
    vLightDirection = uLightDirection;
    vLightHalfVector = uLightHalfVector;
    
    vec3 vNormal = uNormalMatrix * aNormal;
    
    
    vec4 asd = uModelViewProjectionMatrix * aPosition;
    
    
    mat4 viewProjectionMatrix = uProjectionMatrix * uViewMatrix;
    vec4 modelSpacePosition = uModelMatrix * aPosition;
    
//    vViewVector = tangentMatrix * (uEyePosition - vec3(modelSpacePosition));

    
//    vec4 position = uProjectionMatrix * uViewMatrix * aPosition;
//    vec4 position = uProjectionMatrix * uViewMatrix * uModelMatrix * aPosition;
    vec4 position = uModelViewProjectionMatrix * aPosition;
    
    gl_Position = position;
    
    
    
    
}