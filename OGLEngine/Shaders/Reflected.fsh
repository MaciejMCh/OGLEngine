//
//  Shader.fsh
//  OGLEngine
//
//  Created by Maciej Chmielewski on 24.02.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

uniform sampler2D uColorMap;

varying lowp vec2 vTexel;
varying lowp vec4 vModelSpacePosition;

void main() {
    if (vModelSpacePosition.z < 0.5) {
        discard;
    }
    gl_FragColor = texture2D(uColorMap, vTexel);
}
