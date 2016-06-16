//
//  GPUShader.fsh
//  OGLEngine
//
//  Created by Maciej Chmielewski on 24.02.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

uniform sampler2D uColorMap;

varying lowp vec2 vTexel;
varying lowp float vZPosition;

void main() {
    if (vZPosition < 0.0) {
        discard;
    }
    gl_FragColor = texture2D(uColorMap, vTexel);
}
