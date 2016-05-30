//
//  Uniform.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 30.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

class AnyGPUUniform {
    var variable: AnyGPUVariable
    var location: GLint!
    
    init(variable: AnyGPUVariable) {
        self.variable = variable
    }
    
    func passToGPU() {
        
    }
}

extension AnyGPUUniform: GLSLRepresentable {
    var glslName: String {
        get {
            return self.variable.name!
        }
    }
}

class GPUUniform<T: GLSLType> : AnyGPUUniform {
    var typedVariable: TypedGPUVariable<T>
    var cpuVariableGetter: (() -> T.CPUCounterpart)!
    
    init(variable: TypedGPUVariable<T>) {
        self.typedVariable = variable
        super.init(variable: variable)
    }
    
    override func passToGPU() {
        T.passValueToGPU(self.cpuVariableGetter(), location: self.location)
    }
}

struct Uniforms {
    static let modelMatrix = TypedGPUVariable<GLSLMat4>(name: "uModelMatrix")
    static let viewMatrix = TypedGPUVariable<GLSLMat4>(name: "uViewMatrix")
    static let projectionMatrix = TypedGPUVariable<GLSLMat4>(name: "uProjectionMatrix")
    static let modelViewProjectionMatrix = TypedGPUVariable<GLSLMat4>(name: "uModelViewProjectionMatrix")
    static let normalMatrix = TypedGPUVariable<GLSLMat3>(name: "uNormalMatrix")
    static let eyePosition = TypedGPUVariable<GLSLVec3>(name: "uEyePosition")
    static let position = TypedGPUVariable<GLSLVec3>(name: "uPosition")
    static let lightDirection = TypedGPUVariable<GLSLVec3>(name: "uLightDirection")
    static let lightHalfVector = TypedGPUVariable<GLSLVec3>(name: "uLightHalfVector")
    static let colorMap = TypedGPUVariable<GLSLTexture>(name: "uColorMap")
    static let normalMap = TypedGPUVariable<GLSLTexture>(name: "uNormalMap")
    static let reflectionColorMap = TypedGPUVariable<GLSLTexture>(name: "uReflectionColorMap")
    static let textureScale = TypedGPUVariable<GLSLFloat>(name: "uTextureScale")
    static let shininess = TypedGPUVariable<GLSLFloat>(name: "uShininess")
    static let clippingPlane = TypedGPUVariable<GLSLPlane>(name: "uClippingPlane")
    static let lightColor = TypedGPUVariable<GLSLColor>(name: "uLightColor")
}























protocol Un {
    var variable: AnyGPUVariable {get}
}

class BaseUn: Un {
    var typedVariable: TypedGPUVariable<GLSLFloat>
    
    var variable: AnyGPUVariable {
        get {
            return self.typedVariable
        }
    }
    
    init(variable: TypedGPUVariable<GLSLFloat>) {
        self.typedVariable = variable
    }
}
























