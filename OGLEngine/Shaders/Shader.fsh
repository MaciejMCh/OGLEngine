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
varying lowp vec3 vDirectionalLightHalfVector;
varying lowp vec3 vDirectionalLightDirection;

void main() {
    // Diffuse light
    lowp float diffuse = max(0.0, dot(vDirectionalLightDirection, vEyeSpaceNormalizedNormal));
    
    // Specular light
    lowp vec4 specular = vec4(0.0, 0.0, 0.0, 1.0);
    if (diffuse > 0.0) {
        lowp float NdotHV = max(dot(vDirectionalLightHalfVector, vEyeSpaceNormalizedNormal),0.0);
        specular = vec4(1.0 , 1.0 , 1.0 , 1.0) * pow(NdotHV,100.0);
    }
    
    gl_FragColor = texture2D(uTexture, vTexel) * diffuse + specular;
}
