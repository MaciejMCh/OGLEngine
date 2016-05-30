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
    typealias CPUCounterpart = UIColor
}

public struct GLSLVoid: GLSLType {
    typealias CPUCounterpart = Void
}

public struct GLSLVec4: GLSLType {
    typealias CPUCounterpart = GLKVector4
}

public struct GLSLVec3: GLSLType {
    typealias CPUCounterpart = GLKVector3
    
    func passValueToGPU(value: CPUCounterpart, location: GLint) {
        GPUPassFunctions.vec3Pass(value, location: location)
    }
}

public struct GLSLVec2: GLSLType {
    typealias CPUCounterpart = GLKVector2
}

public struct GLSLMat3: GLSLType {
    typealias CPUCounterpart = GLKMatrix3
}

public struct GLSLMat4: GLSLType {
    typealias CPUCounterpart = GLKMatrix4
}

public struct GLSLInt: GLSLType {
    typealias CPUCounterpart = Int
}

public struct GLSLTexture: GLSLType {
    typealias CPUCounterpart = Texture
}

public struct GLSLFloat: GLSLType {
    typealias CPUCounterpart = Float
    
    func passValueToGPU(value: CPUCounterpart, location: GLint) {
        GPUPassFunctions.floatPass(value, location: location)
    }
}

public struct GLSLPlane: GLSLType {
    typealias CPUCounterpart = (A: Float, B: Float, C: Float, D: Float)
}