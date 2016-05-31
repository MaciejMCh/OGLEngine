//
//  GPUShader.fsh
//  OGLEngine
//
//  Created by Maciej Chmielewski on 24.02.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

uniform sampler2D uColorMap;
uniform sampler2D uNormalMap;

varying lowp vec2 vTexel;
varying lowp vec3 vViewVector;
varying lowp vec3 vDirectionalLightDirection;
varying lowp mat3 vNormalMatrix;

void main() {
    lowp vec3 normalChangeVector = vec3(texture2D(uNormalMap, vTexel));
    normalChangeVector = normalize(normalChangeVector * 2.0 - vec3(1.0, 1.0, 1.0));
    
    // Calculate vectors
    lowp vec3 lightVector = -vDirectionalLightDirection;
    lowp vec3 viewVector = normalize(vViewVector);
    lowp vec3 halfVector = normalize(lightVector + viewVector);
    lowp vec3 normalVector = vNormalMatrix * normalChangeVector;
    
    // Diffuse light
    lowp float NdotL = max(0.0, dot(normalVector, lightVector));
    
    // Specular light
    lowp float NdotH = max(dot(normalVector, halfVector),0.0);
    lowp vec4 specular = vec4(1.0 , 1.0 , 1.0 , 1.0) * pow(NdotH,100.0);
    
    gl_FragColor = texture2D(uColorMap, vTexel) * NdotL + specular;
}
