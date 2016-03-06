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

uniform mat4 uModelViewProjectionMatrix;
uniform mat3 uNormalMatrix;
uniform vec3 uEyePosition;
uniform vec3 uDirectionalLightDirection;

varying lowp vec2 vTexel;
varying lowp vec3 vPosition;
varying lowp vec3 vEyeSpaceNormalizedNormal;
varying lowp vec3 vEyePosition;
varying lowp vec3 vDirectionalLightDirection;

void main() {
    vTexel = aTexel;
    vDirectionalLightDirection = normalize(uDirectionalLightDirection);
    vEyePosition = uEyePosition;
    vEyeSpaceNormalizedNormal = normalize(uNormalMatrix * aNormal);
    vec4 position = uModelViewProjectionMatrix * aPosition;
    vPosition = vec3(position);
    gl_Position = position;
}
