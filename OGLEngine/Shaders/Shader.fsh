//
//  Shader.fsh
//  OGLEngine
//
//  Created by Maciej Chmielewski on 24.02.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

uniform sampler2D uTexture;
varying lowp vec2 vTexel;
varying lowp vec3 vEyeSpaceNormalizedNormal;

void main() {
    gl_FragColor = texture2D(uTexture, vTexel) * max(0.0, dot(vec3(0.0, 0.0, 1.0), vEyeSpaceNormalizedNormal));
}
