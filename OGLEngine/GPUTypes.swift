//
//  GPUTypes.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 24.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import GLKit
import UIKit

protocol GLSLType {
    associatedtype CPUCounterpart
    static func passValueToGPU(value: CPUCounterpart, location: GLint)
}

extension GLSLType {
    static func passValueToGPU(value: CPUCounterpart, location: GLint) {
        assert(false) // You are trying to pass value of type which passing function is not implemented
    }
}

public struct GLSLColor: GLSLType {
    typealias CPUCounterpart = (r: Float, g: Float, b: Float, a: Float)
    
    static func passValueToGPU(value: CPUCounterpart, location: GLint) {
        GPUPassFunctions.vec4Pass(GLKVector4Make(value.r, value.g, value.b, value.a), location: location)
    }
}

public struct GLSLVoid: GLSLType {
    typealias CPUCounterpart = Void
}

public struct GLSLVec4: GLSLType {
    typealias CPUCounterpart = GLKVector4
}

public struct GLSLVec3: GLSLType {
    typealias CPUCounterpart = GLKVector3
    
    static func passValueToGPU(value: CPUCounterpart, location: GLint) {
        GPUPassFunctions.vec3Pass(value, location: location)
    }
}

public struct GLSLVec2: GLSLType {
    typealias CPUCounterpart = GLKVector2
}

public struct GLSLMat3: GLSLType {
    typealias CPUCounterpart = GLKMatrix3
    
    static func passValueToGPU(value: CPUCounterpart, location: GLint) {
        GPUPassFunctions.mat3Pass(value, location: location)
    }
}

public struct GLSLMat4: GLSLType {
    typealias CPUCounterpart = GLKMatrix4
    
    static func passValueToGPU(value: CPUCounterpart, location: GLint) {
        GPUPassFunctions.mat4Pass(value, location: location)
    }
}

public struct GLSLInt: GLSLType {
    typealias CPUCounterpart = Int
}

public struct GLSLTexture: GLSLType {
    typealias CPUCounterpart = Texture
    
    static func passValueToGPU(value: CPUCounterpart, location: GLint) {
        GPUPassFunctions.texturePass(value, location: location)
    }
}

public struct GLSLFloat: GLSLType {
    typealias CPUCounterpart = Float
    
    static func passValueToGPU(value: CPUCounterpart, location: GLint) {
        GPUPassFunctions.floatPass(value, location: location)
    }
}

public struct GLSLPlane: GLSLType {
    typealias CPUCounterpart = (A: Float, B: Float, C: Float, D: Float)
}