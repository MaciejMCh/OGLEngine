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
    static func vec3Pass(var vec3: GLKVector3, location: GLint) {
        withUnsafePointer(&vec3, {
            glUniform3fv(location, 1, UnsafePointer($0))
        })
    }
    
    static func vec4Pass(var vec4: GLKVector4, location: GLint) {
        withUnsafePointer(&vec4, {
            glUniform4fv(location, 1, UnsafePointer($0))
        })
    }
    
    static func mat3Pass(var mat3: GLKMatrix3, location: GLint) {
        withUnsafePointer(&mat3, {
            glUniformMatrix3fv(location, 1, 0, UnsafePointer($0))
        })
    }
    
    static func mat4Pass(var mat4: GLKMatrix4, location: GLint) {
        withUnsafePointer(&mat4, {
            glUniformMatrix4fv(location, 1, 0, UnsafePointer($0))
        })
    }
    
    static func floatPass(float: GLfloat, location: GLint) {
        glUniform1f(location, float)
    }
    
    static func texturePass(texture: Texture, location: GLint) {
        glActiveTexture(GLenum(GL_TEXTURE0));
        glBindTexture(GLenum(GL_TEXTURE_2D), texture.glName)
        glUniform1i(location, 0);
    }
}