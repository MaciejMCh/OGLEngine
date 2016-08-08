//
//  GPUPassFunctions.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 10.04.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

struct GPUPassFunctions {
    static func vec3Pass(vec3: GLKVector3, location: GLint) {
        var vec3 = vec3
        withUnsafePointer(&vec3, {
            glUniform3fv(location, 1, UnsafePointer($0))
        })
    }
    
    static func vec4Pass(vec4: GLKVector4, location: GLint) {
        var vec4 = vec4
        withUnsafePointer(&vec4, {
            glUniform4fv(location, 1, UnsafePointer($0))
        })
    }
    
    static func mat3Pass(mat3: GLKMatrix3, location: GLint) {
        var mat3 = mat3
        withUnsafePointer(&mat3, {
            glUniformMatrix3fv(location, 1, 0, UnsafePointer($0))
        })
    }
    
    static func mat4Pass(mat4: GLKMatrix4, location: GLint) {
        var mat4 = mat4
        withUnsafePointer(&mat4, {
            glUniformMatrix4fv(location, 1, 0, UnsafePointer($0))
        })
    }
    
    static func floatPass(float: GLfloat, location: GLint) {
        glUniform1f(location, float)
    }
    
    static func texturePass(texture: Texture, index: GLint, location: GLint) {
        glActiveTexture(GLenum(GL_TEXTURE0 + index));
        glBindTexture(GLenum(GL_TEXTURE_2D), texture.glName);
        glUniform1i(location, 0 + index);
    }
    
    static func cubeTexturePass(texture: CubeTexture, index: GLint, location: GLint) {
        glActiveTexture(GLenum(GL_TEXTURE0 + index));
        glBindTexture(GLenum(GL_TEXTURE_CUBE_MAP), texture.glName);
        glUniform1i(location, 0 + index);
    }
}