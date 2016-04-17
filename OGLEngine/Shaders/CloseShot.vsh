//
//  Shader.vsh
//  OGLEngine
//
//  Created by Maciej Chmielewski on 24.02.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

attribute vec4 aPosition;
attribute vec2 aTexel;

attribute vec3 aTangentMatrixCol1;
attribute vec3 aTangentMatrixCol2;
attribute vec3 aTangentMatrixCol3;

uniform mat4 uModelMatrix;
uniform mat4 uViewMatrix;
uniform mat4 uProjectionMatrix;

uniform vec3 uEyePosition;
uniform vec3 uLightDirection;

varying lowp vec2 vTexel;
varying lowp vec3 vViewVector;
varying lowp vec3 vDirectionalLightDirection;

void main() {
    vTexel = aTexel;
    
    mat3 tangentMatrix = mat3(aTangentMatrixCol1, aTangentMatrixCol2, aTangentMatrixCol3);
    vDirectionalLightDirection = normalize(uLightDirection);
    vDirectionalLightDirection = tangentMatrix * vDirectionalLightDirection;
//    vDirectionalLightDirection = uNormalMatrix * vDirectionalLightDirection;
    
    mat4 viewProjectionMatrix = uProjectionMatrix * uViewMatrix;
    vec4 modelSpacePosition = uModelMatrix * aPosition;
    
    vViewVector = tangentMatrix * (uEyePosition - vec3(modelSpacePosition));
//    vViewVector = uNormalMatrix * vViewVector;
    
    vec4 position = viewProjectionMatrix * modelSpacePosition;
    
    gl_Position = position;
}
