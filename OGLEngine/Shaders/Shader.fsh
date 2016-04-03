//
//  Shader.fsh
//  OGLEngine
//
//  Created by Maciej Chmielewski on 24.02.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

uniform sampler2D uColorMap;
uniform sampler2D uNormalMap;
varying lowp vec2 vTexel;
varying lowp vec3 vEyeSpaceNormalizedNormal;
varying lowp vec3 vEyePosition;
varying lowp vec3 vDirectionalLightDirection;
varying lowp vec3 vPosition;

void main() {
    lowp vec3 normalChangeVector = vec3(texture2D(uNormalMap, vTexel * 5.0));
    normalChangeVector = normalChangeVector * 2.0;
    normalChangeVector = normalChangeVector - vec3(1.0, 1.0, 1.0);
    
    
    // Calculate vectors
    lowp vec3 lightVector = vDirectionalLightDirection;
    lowp vec3 viewVector = normalize(vEyePosition - vPosition);
    lowp vec3 halfVector = normalize(lightVector + viewVector);
    lowp vec3 normalVector = normalChangeVector;
//    lowp vec3 normalVector = vEyeSpaceNormalizedNormal;
    
    // Diffuse light
    lowp float NdotL = max(0.0, dot(normalVector, lightVector));
    
    // Specular light
    lowp float NdotH = max(dot(normalVector, halfVector),0.0);
    lowp vec4 specular = vec4(1.0 , 1.0 , 1.0 , 1.0) * pow(NdotH,100.0);
    
//    gl_FragColor = vec4((vDirectionalLightDirection + vec3(1.0, 1.0, 1.0)) * 2.0, 1.0);
//    gl_FragColor = vec4((vDirectionalLightDirection * 0.5) + vec3(1.0, 1.0, 1.0), 1.0);
//    gl_FragColor = vec4((vEyeSpaceNormalizedNormal * 0.5) + vec3(1.0, 1.0, 1.0), 1.0);
    
    highp vec3 zzz = vDirectionalLightDirection;
//    zzz = zzz * 0.5;
    
//    zzz = zzz + vec3(0.5, 0.5, 0.5);
    
//    zzz = zzz * 2.0;
    
//    zzz = vec3(zzz.x * 1.0, zzz.y * 1.0, zzz.z * 1.0);
//    zzz = vec3(0.0, 0.0, 1.0);
    zzz = zzz + vec3(1.0, 1.0, 1.0);
    
    zzz = zzz * 0.5;
//    zzz = vec3(zzz.x * 0.5, zzz.y * 0.5, zzz.z * 0.5);
    gl_FragColor = vec4(zzz, 1.0);
    
//    gl_FragColor = vec4(vEyeSpaceNormalizedNormal, 1.0);
//    gl_FragColor = texture2D(uNormalMap, vTexel);
//    gl_FragColor = vec4(vec3(texture2D(uNormalMap, vTexel * 5.0)), 1.0);
//    gl_FragColor = texture2D(uColorMap, vTexel) * NdotL;// + specular;
}
