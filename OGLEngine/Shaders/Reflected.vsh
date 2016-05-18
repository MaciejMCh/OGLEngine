//
//  Shader.vsh
//  OGLEngine
//
//  Created by Maciej Chmielewski on 24.02.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

attribute vec4 aPosition;
attribute vec2 aTexel;
attribute vec2 aNormal;

uniform mat4 uModelMatrix;
uniform mat4 uViewMatrix;
uniform mat4 uProjectionMatrix;
uniform lowp float uTextureScale;

varying lowp vec2 vTexel;
varying lowp vec4 vModelSpacePosition;

void main() {
    vTexel = aTexel * uTextureScale;
    mat4 viewProjectionMatrix = uProjectionMatrix * uViewMatrix;
    vec4 modelSpacePosition = uModelMatrix * aPosition;
    vec4 position = viewProjectionMatrix * modelSpacePosition;
    vModelSpacePosition = modelSpacePosition;
    gl_Position = position;
}
