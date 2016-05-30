//
//  GPUDefaultVariables.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 28.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

struct GPUAttribute {
    let variable: AnyGPUVariable
    let location: GLuint
}

struct Attributes {
    static let position = GPUAttribute(variable: TypedGPUVariable<GLSLVec4>(name: "aPosition"), location: 0)
    static let texel = GPUAttribute(variable: TypedGPUVariable<GLSLVec2>(name: "aTexel"), location: 1)
    static let normal = GPUAttribute(variable: TypedGPUVariable<GLSLVec3>(name: "aNormal"), location: 2)
    static let tbn = GPUAttribute(variable: TypedGPUVariable<GLSLMat3>(name: "aTBN"), location: 3)
    
    static func get(variable: AnyGPUVariable) -> GPUAttribute! {
        switch variable.name! {
        case "aPosition": return position
        case "aTexel": return texel
        case "aNormal": return normal
        case "aTBN": return tbn
        default: return nil
        }
    }
}

protocol BaseGPUUniform {
    associatedtype S
}

class AnyGPUUniform: BaseGPUUniform {
    typealias S = Any
    var variable: TypedGPUVariable<S>
    var location: GLint
    
    init(variable: TypedGPUVariable<S>, location: GLint) {
        self.variable = variable
        self.location = location
    }
}

class GPUUniform<T: GLSLType> : AnyGPUUniform {
    typealias S = T
    var cpuVariableGetter: (() -> T.CPUCounterpart)!
    
    func passToGPU() {
        T.passValueToGPU(self.cpuVariableGetter(), location: self.location)
    }
}

struct GPUPipelineImplementation {
    let uniforms: [AnyGPUUniform]
    
    func get<T>(variable: TypedGPUVariable<T>) -> GPUUniform<T>! {
        for uniform in uniforms {
            if uniform.variable.name! == variable.name! {
                return uniform as! GPUUniform<T>
            }
        }
        return nil
    }
}

struct Uniforms {
    let modelMatrix = TypedGPUVariable<GLSLMat4>(name: "uModelMatrix")
    let viewMatrix = TypedGPUVariable<GLSLMat4>(name: "uViewMatrix")
    let projectionMatrix = TypedGPUVariable<GLSLMat4>(name: "uProjectionMatrix")
    let modelViewProjectionMatrix = TypedGPUVariable<GLSLMat4>(name: "uModelViewProjectionMatrix")
    let normalMatrix = TypedGPUVariable<GLSLMat3>(name: "uNormalMatrix")
    let eyePosition = TypedGPUVariable<GLSLVec3>(name: "uEyePosition")
    let position = TypedGPUVariable<GLSLVec3>(name: "uPosition")
    let lightDirection = TypedGPUVariable<GLSLVec3>(name: "uLightDirection")
    let lightHalfVector = TypedGPUVariable<GLSLVec3>(name: "uLightHalfVector")
    let colorMap = TypedGPUVariable<GLSLTexture>(name: "uColorMap")
    let normalMap = TypedGPUVariable<GLSLTexture>(name: "uNormalMap")
    let textureScale = TypedGPUVariable<GLSLFloat>(name: "uTextureScale")
    let reflectionColorMap = TypedGPUVariable<GLSLTexture>(name: "uReflectionColorMap")
    let clippingPlane = TypedGPUVariable<GLSLPlane>(name: "uClippingPlane")
}