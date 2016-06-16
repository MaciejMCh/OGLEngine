//
//  GPUShader.vsh
//  OGLEngine
//
//  Created by Maciej Chmielewski on 24.02.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

attribute vec4 aPosition;
attribute vec2 aTexel;
attribute vec2 aNormal;

uniform mat4 uModelMatrix;
uniform mat4 uModelMatrix2;
uniform mat4 uViewProjectionMatrix;
uniform lowp float uTextureScale;

varying lowp vec2 vTexel;
varying lowp vec4 vModelSpacePosition;

void main() {
    vTexel = aTexel * uTextureScale;
    vec4 modelSpacePosition = uModelMatrix * aPosition;
    modelSpacePosition = uModelMatrix2 * modelSpacePosition;
    vec4 position = uViewProjectionMatrix * modelSpacePosition;
    vModelSpacePosition = modelSpacePosition;
    gl_Position = position;
}
