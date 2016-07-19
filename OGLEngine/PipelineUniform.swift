//
//  Uniform.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 30.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

class AnyGPUUniform: AnyVariable {
    var variable: AnyVariable
    var location: GLint!
    
    var name: String {
        return variable.name
    }
    
    init(variable: AnyVariable) {
        self.variable = variable
    }
    
    func passToGPU() {
        assert(false)
        // Why did you even instantiate it?
    }
}

//extension AnyGPUUniform: GPURepresentable {
//    var glslName: String {
//        get {
//            return self.variable.name!
//        }
//    }
//}

class GPUUniform<T: GLSLType> : AnyGPUUniform {
    var typedVariable: Variable<T>
    var cpuVariableGetter: (() -> T.CPUCounterpart)!
    
    init(variable: Variable<T>) {
        self.typedVariable = variable
        super.init(variable: variable)
    }
    
    override func passToGPU() {
        assert(self.cpuVariableGetter != nil, self.variable.name + " uniform has no assigned cpu counterpart getter.")
        T.passValueToGPU(self.cpuVariableGetter(), location: self.location)
    }
}

struct GPUUniforms {
    static let modelMatrix = Variable<GLSLMat4>(name: "uModelMatrix")
    static let viewProjectionMatrix = Variable<GLSLMat4>(name: "uViewProjectionMatrix")
    static let rotatedProjectionMatrix = Variable<GLSLMat4>(name: "uRotatedProjectionMatrix")
    static let modelViewProjectionMatrix = Variable<GLSLMat4>(name: "uModelViewProjectionMatrix")
    static let normalMatrix = Variable<GLSLMat3>(name: "uNormalMatrix")
    static let tangentNormalMatrix = Variable<GLSLMat3>(name: "uTangentNormalMatrix")
    static let eyePosition = Variable<GLSLVec3>(name: "uEyePosition")
    static let position = Variable<GLSLVec3>(name: "uPosition")
    static let lightDirection = Variable<GLSLVec3>(name: "uLightDirection")
    static let lightVersor = Variable<GLSLVec3>(name: "uLightVersor")
    static let lightHalfVector = Variable<GLSLVec3>(name: "uLightHalfVector")
    static let colorMap = Variable<GLSLTexture>(name: "uColorMap")
    static let normalMap = Variable<GLSLTexture>(name: "uNormalMap")
    static let specularMap = Variable<GLSLTexture>(name: "uSpecularMap")
    static let reflectionColorMap = Variable<GLSLTexture>(name: "uReflectionColorMap")
    static let shininess = Variable<GLSLFloat>(name: "uShininess")
    static let clippingPlane = Variable<GLSLPlane>(name: "uClippingPlane")
    static let lightColor = Variable<GLSLColor>(name: "uLightColor")
    static let planeSpaceModelMatrix = Variable<GLSLMat4>(name: "uPlaneSpaceModelMatrix")
    static let planeSpaceViewProjectionMatrix = Variable<GLSLMat4>(name: "uPlaneSpaceViewProjectionMatrix")
    static let specularPower = Variable<GLSLFloat>(name: "uSpecularPower")
    static let specularWidth = Variable<GLSLFloat>(name: "uSpecularWidth")
    static let ambiencePower = Variable<GLSLFloat>(name: "uAmbiencePower")
    static let rayBoxColorMap = Variable<GLSLTexture>(name: "uRayBoxColorMap")
}
