//
//  Shader.fsh
//  OGLEngine
//
//  Created by Maciej Chmielewski on 24.02.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

uniform sampler2D uTexture;
uniform sampler2D uNormalMap;
varying lowp vec2 vTexel;
varying lowp vec3 vEyeSpaceNormalizedNormal;
varying lowp vec3 vEyePosition;
varying lowp vec3 vDirectionalLightDirection;
varying lowp vec3 vPosition;

void main() {
    lowp vec3 normalChangeVector = vec3(texture2D(uNormalMap, vTexel));
    normalChangeVector = normalize(normalChangeVector * 2.0 - 1.0); 
    
    // Calculate vectors
    lowp vec3 lightVector = -vDirectionalLightDirection;
    lowp vec3 viewVector = normalize(vEyePosition - vPosition);
    lowp vec3 halfVector = normalize(lightVector + viewVector);
    lowp vec3 normalVector = normalize(vEyeSpaceNormalizedNormal + normalize(normalChangeVector));
    
    // Diffuse light
    lowp float NdotL = max(0.0, dot(normalVector, lightVector));
    
    // Specular light
    lowp float NdotH = max(dot(normalVector, halfVector),0.0);
    lowp vec4 specular = vec4(1.0 , 1.0 , 1.0 , 1.0) * pow(NdotH,100.0);
    
    gl_FragColor = texture2D(uTexture, vTexel) * NdotL + specular;
}
