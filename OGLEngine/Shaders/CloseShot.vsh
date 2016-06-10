//
//  GPUShader.vsh
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
uniform mat4 uViewProjectionMatrix;
uniform mat3 uNormalMatrix;

uniform vec3 uEyePosition;
uniform vec3 uLightDirection;

uniform lowp float uTextureScale;

varying lowp vec2 vTexel;
varying lowp vec3 vViewVector;
varying lowp vec3 vDirectionalLightDirection;
varying lowp mat3 vNormalMatrix;

void main() {
    vTexel = aTexel * uTextureScale;
    
    mat3 tangentMatrix = mat3(aTangentMatrixCol1, aTangentMatrixCol2, aTangentMatrixCol3);
    vDirectionalLightDirection = normalize(uLightDirection);
    vDirectionalLightDirection = tangentMatrix * vDirectionalLightDirection;
    
    vNormalMatrix = uNormalMatrix;
    vec4 modelSpacePosition = uModelMatrix * aPosition;
    
    vViewVector = tangentMatrix * (uEyePosition - vec3(modelSpacePosition));
    
    vec4 position = uViewProjectionMatrix * modelSpacePosition;
    
    gl_Position = position;
}
