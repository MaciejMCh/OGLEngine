//
//  GPUTypes.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 24.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import GLKit
import UIKit

public protocol GLSLType {
    associatedtype CPUCounterpart
    static func passValueToGPU(value: CPUCounterpart, location: GLint)
    static func primitiveFace(primitive: CPUCounterpart) -> String
}

extension GLSLType {
    public static func passValueToGPU(value: CPUCounterpart, location: GLint) {
        assert(false) // You are trying to pass value of type which passing function is not implemented
    }
    
    public static func primitiveFace(primitive: CPUCounterpart) -> String {
        assert(false) // You are trying to pass value of type which passing function is not implemented
        return ""
    }
}

public typealias Color = (r: Float, g: Float, b: Float, a: Float)
public struct GLSLColor: GLSLType {
    public typealias CPUCounterpart = Color
    
    public static func passValueToGPU(value: CPUCounterpart, location: GLint) {
        GPUPassFunctions.vec4Pass(GLKVector4Make(value.r, value.g, value.b, value.a), location: location)
    }
    
    public static func primitiveFace(primitive: CPUCounterpart) -> String {
        return "vec4(\(primitive.r), \(primitive.g), \(primitive.b), \(primitive.a))"
    }
}

public struct GLSLVoid: GLSLType {
    public typealias CPUCounterpart = Void
}

public struct GLSLVec4: GLSLType {
    public typealias CPUCounterpart = GLKVector4
    
    public static func primitiveFace(primitive: CPUCounterpart) -> String {
        return "vec4(\(primitive.x), \(primitive.y), \(primitive.z), \(primitive.w))"
    }
}

public struct GLSLVec3: GLSLType {
    public typealias CPUCounterpart = GLKVector3
    
    public static func passValueToGPU(value: CPUCounterpart, location: GLint) {
        GPUPassFunctions.vec3Pass(value, location: location)
    }
    
    public static func primitiveFace(primitive: CPUCounterpart) -> String {
        return "vec3(\(primitive.x), \(primitive.y), \(primitive.z))"
    }
}

public struct GLSLVec2: GLSLType {
    public typealias CPUCounterpart = GLKVector2
    
    public static func primitiveFace(primitive: CPUCounterpart) -> String {
        return "vec2(\(primitive.x), \(primitive.y))"
    }
}

public struct GLSLMat3: GLSLType {
    public typealias CPUCounterpart = GLKMatrix3
    
    public static func passValueToGPU(value: CPUCounterpart, location: GLint) {
        GPUPassFunctions.mat3Pass(value, location: location)
    }
}

public struct GLSLMat4: GLSLType {
    public typealias CPUCounterpart = GLKMatrix4
    
    public static func passValueToGPU(value: CPUCounterpart, location: GLint) {
        GPUPassFunctions.mat4Pass(value, location: location)
    }
}

public struct GLSLInt: GLSLType {
    public typealias CPUCounterpart = Int
    
    public static func primitiveFace(primitive: CPUCounterpart) -> String {
        return "\(primitive)"
    }
}

public struct GLSLTexture: GLSLType {
    public typealias CPUCounterpart = (texture: Texture, index: GLint)
    
    public static func passValueToGPU(value: CPUCounterpart, location: GLint) {
        GPUPassFunctions.texturePass(value.texture, index: value.index, location: location)
    }
}

public struct GLSLCubeTexture: GLSLType {
    public typealias CPUCounterpart = (texture: CubeTexture, index: GLint)
    
    public static func passValueToGPU(value: CPUCounterpart, location: GLint) {
        GPUPassFunctions.cubeTexturePass(value.texture, index: value.index, location: location)
    }
}

public struct GLSLFloat: GLSLType {
    public typealias CPUCounterpart = Float
    
    public static func passValueToGPU(value: CPUCounterpart, location: GLint) {
        GPUPassFunctions.floatPass(value, location: location)
    }
    
    public static func primitiveFace(primitive: CPUCounterpart) -> String {
        return "\(primitive)"
    }
}

public struct GLSLBool: GLSLType {
    public typealias CPUCounterpart = Bool
    public static func passValueToGPU(value: CPUCounterpart, location: GLint) {
        assert(false, "Just don't")
    }
}

public struct GLSLPlane: GLSLType {
    public typealias CPUCounterpart = (A: Float, B: Float, C: Float, D: Float)
}

public struct GLSLVectorGraphics: GLSLType {
    public typealias CPUCounterpart = VectorGraphics
}
