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
        assert(false)
        // Why did you even instantiate it?
    }
}

extension AnyGPUUniform: GPURepresentable {
    var glslName: String {
        get {
            return self.variable.name!
        }
    }
}

class GPUUniform<T: GLSLType> : AnyGPUUniform {
    var typedVariable: GPUVariable<T>
    var cpuVariableGetter: (() -> T.CPUCounterpart)!
    
    init(variable: GPUVariable<T>) {
        self.typedVariable = variable
        super.init(variable: variable)
    }
    
    override func passToGPU() {
        assert(self.cpuVariableGetter != nil, self.variable.name! + " uniform has no assigned cpu counterpart getter.")
        T.passValueToGPU(self.cpuVariableGetter(), location: self.location)
    }
}

struct GPUUniforms {
    static let modelMatrix = GPUVariable<GLSLMat4>(name: "uModelMatrix")
    static let viewProjectionMatrix = GPUVariable<GLSLMat4>(name: "uViewProjectionMatrix")
    static let rotatedProjectionMatrix = GPUVariable<GLSLMat4>(name: "uRotatedProjectionMatrix")
    static let modelViewProjectionMatrix = GPUVariable<GLSLMat4>(name: "uModelViewProjectionMatrix")
    static let normalMatrix = GPUVariable<GLSLMat3>(name: "uNormalMatrix")
    static let tangentNormalMatrix = GPUVariable<GLSLMat3>(name: "uTangentNormalMatrix")
    static let eyePosition = GPUVariable<GLSLVec3>(name: "uEyePosition")
    static let position = GPUVariable<GLSLVec3>(name: "uPosition")
    static let lightDirection = GPUVariable<GLSLVec3>(name: "uLightDirection")
    static let lightVersor = GPUVariable<GLSLVec3>(name: "uLightVersor")
    static let lightHalfVector = GPUVariable<GLSLVec3>(name: "uLightHalfVector")
    static let colorMap = GPUVariable<GLSLTexture>(name: "uColorMap")
    static let normalMap = GPUVariable<GLSLTexture>(name: "uNormalMap")
    static let specularMap = GPUVariable<GLSLTexture>(name: "uSpecularMap")
    static let reflectionColorMap = GPUVariable<GLSLTexture>(name: "uReflectionColorMap")
    static let shininess = GPUVariable<GLSLFloat>(name: "uShininess")
    static let clippingPlane = GPUVariable<GLSLPlane>(name: "uClippingPlane")
    static let lightColor = GPUVariable<GLSLColor>(name: "uLightColor")
    static let planeSpaceModelMatrix = GPUVariable<GLSLMat4>(name: "uPlaneSpaceModelMatrix")
    static let planeSpaceViewProjectionMatrix = GPUVariable<GLSLMat4>(name: "uPlaneSpaceViewProjectionMatrix")
    static let specularPower = GPUVariable<GLSLFloat>(name: "uSpecularPower")
    static let specularWidth = GPUVariable<GLSLFloat>(name: "uSpecularWidth")
    static let ambiencePower = GPUVariable<GLSLFloat>(name: "uAmbiencePower")
    
    
}
