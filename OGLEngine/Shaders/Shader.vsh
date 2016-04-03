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
    
//    float polarAngle = 0.0;
//    if (vector.x == 0.0) {
//        polarAngle = 1.57079632679;
//    } else {
    float polarAngle = atan(vector.y, vector.x);
//    float polarAngle = atan(1.0, 1.0);
//    }
    return SphericalVersor(azimuthalAngle, polarAngle);
}

vec3 sphericalVersorToVec3(SphericalVersor sphericalVersor) {
    float x = sin(sphericalVersor.azimuthalAngle) * cos(sphericalVersor.polarAngle);
    float y = sin(sphericalVersor.azimuthalAngle) * sin(sphericalVersor.polarAngle);
    float z = cos(sphericalVersor.azimuthalAngle);
    return vec3(x, y, z);
}

mat3 rotationMatrix(float m_radians, float x, float y, float z)
{
    vec3 v = normalize(vec3(x, y, z));
    float m_cos = cos(m_radians);
    float m_cosp = 1.0 - m_cos;
    float m_sin = sin(m_radians);
    
    mat3 m = mat3( m_cos + m_cosp * v.v.x * v.v.x,
        m_cosp * v.v.x * v.v.y + v.v.z * m_sin,
        m_cosp * v.v.x * v.v.z - v.v.y * m_sin,
        
        m_cosp * v.v.x * v.v.y - v.v.z * m_sin,
        m_cos + m_cosp * v.v.y * v.v.y,
        m_cosp * v.v.y * v.v.z + v.v.x * m_sin,
        
        m_cosp * v.v.x * v.v.z + v.v.y * m_sin,
        m_cosp * v.v.y * v.v.z - v.v.x * m_sin,
        m_cos + m_cosp * v.v.z * v.v.z );
    
    return m;
}
vec3 toSphereSpaceOfVector(vec3 vector, vec3 spacingVector) {
    vec3 v1 = spacingVector;
    vec3 v2 = vec3(0, 0, 1);
    vec3 axis = cross(v1, v2);
    float dotp = dot(v1, v2);
    
    if (dotp == 1.0) {
        return vector;
    }
    
    if (dotp == -1.0) {
        return vector * -1.0;
    }
    
//    if ((axis.x == 0.0) && (axis.y == 0.0) && (axis.z == 0.0)) {
//        return vector * dotp;
//    }
    float angleInradians = acos(dotp);
    mat3 rot = rotationMatrix(angleInradians, axis.x, axis.y, axis.z);
    return rot * vector;
}

void main() {
    vTexel = aTexel;
//    vEyeSpaceNormalizedNormal = normalize(uNormalMatrix * aNormal);
    vEyeSpaceNormalizedNormal = aNormal;
    vDirectionalLightDirection = normalize(uLightDirection);
    vDirectionalLightDirection = toSphereSpaceOfVector(vDirectionalLightDirection, vEyeSpaceNormalizedNormal);
    vEyePosition = uEyePosition;
    
    mat4 viewProjectionMatrix = uProjectionMatrix * uViewMatrix;
    vec4 modelSpacePosition = uModelMatrix * aPosition;
    
    vPosition = vec3(modelSpacePosition);
    vec4 position = viewProjectionMatrix * modelSpacePosition;
    
    gl_Position = position;
}
