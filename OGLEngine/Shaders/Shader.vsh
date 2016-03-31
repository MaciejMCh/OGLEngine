//
//  Shader.vsh
//  OGLEngine
//
//  Created by Maciej Chmielewski on 24.02.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

attribute vec4 aPosition;
attribute vec2 aTexel;
attribute vec3 aNormal;

uniform mat4 uModelMatrix;
uniform mat4 uViewMatrix;
uniform mat4 uProjectionMatrix;

uniform mat3 uNormalMatrix;
uniform vec3 uEyePosition;
uniform vec3 uLightDirection;

varying lowp vec2 vTexel;
varying lowp vec3 vPosition;
varying lowp vec3 vEyeSpaceNormalizedNormal;
varying lowp vec3 vEyePosition;
varying lowp vec3 vDirectionalLightDirection;

struct SphericalVersor {
    float azimuthalAngle;
    float polarAngle;
};

SphericalVersor vec3ToSphericalVersor(vec3 vector) {
    float azimuthalAngle = acos(vector.z);
    float polarAngle = atan(vector.y / vector.x);
    return SphericalVersor(azimuthalAngle, polarAngle);
}

vec3 sphericalVersorToVec3(SphericalVersor sphericalVersor) {
    float x = sin(sphericalVersor.azimuthalAngle) * cos(sphericalVersor.polarAngle);
    float y = sin(sphericalVersor.azimuthalAngle) * sin(sphericalVersor.polarAngle);
    float z = cos(sphericalVersor.azimuthalAngle);
    return vec3(x, y, z);
}

vec3 toSphereSpaceOfVector(vec3 vector, vec3 spacingVector) {
    
    SphericalVersor upPointingNormalVersor = vec3ToSphericalVersor(vec3(0.0 ,0.0, 1.0));
    SphericalVersor versor = vec3ToSphericalVersor(vector);
    SphericalVersor spacingVersor = vec3ToSphericalVersor(spacingVector);
    
    float azimuthalAngleDiff = upPointingNormalVersor.azimuthalAngle - spacingVersor.azimuthalAngle;
    float polarAngleDiff = upPointingNormalVersor.polarAngle - spacingVersor.polarAngle;
    
    versor.azimuthalAngle = versor.azimuthalAngle + azimuthalAngleDiff;
    versor.polarAngle = versor.polarAngle + polarAngleDiff;
    
    return sphericalVersorToVec3(versor);
}

void main() {
    vTexel = aTexel;
    vDirectionalLightDirection = normalize(uLightDirection);
    vEyePosition = uEyePosition;
    vEyeSpaceNormalizedNormal = normalize(uNormalMatrix * aNormal);
    
    mat4 viewProjectionMatrix = uProjectionMatrix * uViewMatrix;
    vec4 modelSpacePosition = uModelMatrix * aPosition;
    
    vPosition = vec3(modelSpacePosition);
    vec4 position = viewProjectionMatrix * modelSpacePosition;
    
    gl_Position = position;
}
