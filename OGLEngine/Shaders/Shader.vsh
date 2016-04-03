//
//  Shader.vsh
//  OGLEngine
//
//  Created by Maciej Chmielewski on 24.02.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

attribute vec4 aPosition;
attribute vec2 aTexel;
attribute vec3 aNormal;

attribute vec3 aTbnMatrix1;
attribute vec3 aTbnMatrix2;
attribute vec3 aTbnMatrix3;


uniform mat4 uModelMatrix;
uniform mat4 uViewMatrix;
uniform mat4 uProjectionMatrix;

uniform mat3 uNormalMatrix;
uniform vec3 uEyePosition;
uniform vec3 uLightDirection;

varying lowp vec2 vTexel;
varying lowp vec3 vPosition;
varying lowp vec3 vEyeSpaceNormalizedNormal;
varying lowp vec3 vEyePosition;
varying lowp vec3 vDirectionalLightDirection;

void main() {
    vTexel = aTexel;
    
    
    mat3 tbnMatrix = mat3(aTbnMatrix1, aTbnMatrix2, aTbnMatrix3);
    vDirectionalLightDirection = normalize(uLightDirection);
    vDirectionalLightDirection = tbnMatrix * vDirectionalLightDirection;
    
    vEyePosition = uEyePosition;
    vEyeSpaceNormalizedNormal = normalize(uNormalMatrix * aNormal);
    
    mat4 viewProjectionMatrix = uProjectionMatrix * uViewMatrix;
    vec4 modelSpacePosition = uModelMatrix * aPosition;
    
    vPosition = vec3(modelSpacePosition);
    vec4 position = viewProjectionMatrix * modelSpacePosition;
    
    gl_Position = position;
}
