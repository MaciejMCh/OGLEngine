//
//  Shader.vsh
//  OGLEngine
//
//  Created by Maciej Chmielewski on 24.02.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

attribute vec4 aPosition;
attribute vec2 aTexel;

uniform mat4 uModelViewProjectionMatrix;

varying lowp vec2 vTexel;

void main() {
    vTexel = aTexel;
    gl_Position = uModelViewProjectionMatrix * aPosition;
}
