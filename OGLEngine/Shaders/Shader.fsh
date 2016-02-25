//
//  Shader.fsh
//  OGLEngine
//
//  Created by Maciej Chmielewski on 24.02.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

uniform sampler2D uTexture;
varying lowp vec2 vTexel;

void main() {
    gl_FragColor = texture2D(uTexture, vTexel);
}
