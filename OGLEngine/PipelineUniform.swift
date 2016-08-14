//
//  Uniform.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 30.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

public protocol AnyGPUUniform: AnyVariable {
    var location: GLint! {get set}
    func passToGPU()
}

class GPUUniform<T: GLSLType> : Variable<T>, AnyGPUUniform {
    var location: GLint!
    var cpuVariableGetter: (() -> T.CPUCounterpart)!
    
    override init(name: String) {
        super.init(name: name)
    }
    
    func passToGPU() {
        assert(self.cpuVariableGetter != nil, self.name + " uniform has no assigned cpu counterpart getter.")
        T.passValueToGPU(self.cpuVariableGetter(), location: self.location)
    }
}

struct GPUUniforms {
    static let modelMatrix = GPUUniform<GLSLMat4>(name: "uModelMatrix")
    static let viewProjectionMatrix = GPUUniform<GLSLMat4>(name: "uViewProjectionMatrix")
    static let rotatedProjectionMatrix = GPUUniform<GLSLMat4>(name: "uRotatedProjectionMatrix")
    static let modelViewProjectionMatrix = GPUUniform<GLSLMat4>(name: "uModelViewProjectionMatrix")
    static let normalMatrix = GPUUniform<GLSLMat3>(name: "uNormalMatrix")
    static let tangentNormalMatrix = GPUUniform<GLSLMat3>(name: "uTangentNormalMatrix")
    static let eyePosition = GPUUniform<GLSLVec3>(name: "uEyePosition")
    static let position = GPUUniform<GLSLVec3>(name: "uPosition")
    static let lightDirection = GPUUniform<GLSLVec3>(name: "uLightDirection")
    static let lightVersor = GPUUniform<GLSLVec3>(name: "uLightVersor")
    static let lightHalfVector = GPUUniform<GLSLVec3>(name: "uLightHalfVector")
    static let colorMap = GPUUniform<GLSLTexture>(name: "uColorMap")
    static let normalMap = GPUUniform<GLSLTexture>(name: "uNormalMap")
    static let specularMap = GPUUniform<GLSLTexture>(name: "uSpecularMap")
    static let reflectionColorMap = GPUUniform<GLSLTexture>(name: "uReflectionColorMap")
    static let shininess = GPUUniform<GLSLFloat>(name: "uShininess")
    static let clippingPlane = GPUUniform<GLSLPlane>(name: "uClippingPlane")
    static let lightColor = GPUUniform<GLSLColor>(name: "uLightColor")
    static let planeSpaceModelMatrix = GPUUniform<GLSLMat4>(name: "uPlaneSpaceModelMatrix")
    static let planeSpaceViewProjectionMatrix = GPUUniform<GLSLMat4>(name: "uPlaneSpaceViewProjectionMatrix")
    static let specularPower = GPUUniform<GLSLFloat>(name: "uSpecularPower")
    static let specularWidth = GPUUniform<GLSLFloat>(name: "uSpecularWidth")
    static let ambiencePower = GPUUniform<GLSLFloat>(name: "uAmbiencePower")
    static let rayBoxColorMap = GPUUniform<GLSLTexture>(name: "uRayBoxColorMap")
    static let fresnelA = GPUUniform<GLSLFloat>(name: "uFresnelA")
    static let fresnelB = GPUUniform<GLSLFloat>(name: "uFresnelB")
    static let emissionColor = GPUUniform<GLSLColor>(name: "uEmissionColor")
    
    static let cubeTexture = GPUUniform<GLSLCubeTexture>(name: "uCubeTexture")
    
    static let index1 = GPUUniform<GLSLInt>(name: "uIndex1")
    static let index2 = GPUUniform<GLSLInt>(name: "uIndex2")
    
    
    struct CubeTextures {
        static let Current = GPUUniform<GLSLTexture>(name: "uCubeTextureCurrent")
        static let Top = GPUUniform<GLSLTexture>(name: "uCubeTextureTop")
        static let Left = GPUUniform<GLSLTexture>(name: "uCubeTextureLeft")
        static let Bottom = GPUUniform<GLSLTexture>(name: "uCubeTextureBottom")
        static let Right = GPUUniform<GLSLTexture>(name: "uCubeTextureRight")
    }
    static let sideTexturesTransformations = IntArrayVariable(name: "uSideTexturesTransformations", size: 4)
}

struct UniformsCollection {
    let collection: [AnyGPUUniform]
    
    func get<T>(uniform: GPUUniform<T>) -> GPUUniform<T>! {
        for element in collection {
            if element.name == uniform.name {
                return element as! GPUUniform<T>
            }
        }
        return nil
    }
}
