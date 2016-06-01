//
//  CloseShot.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 01.06.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

extension DefaultVertexShaders {
    static func CloseShot(attributes: GPUVariableCollection<AnyGPUAttribute>,
                          uniforms: GPUVariableCollection<AnyGPUUniform>,
                          interpolation: CloseShotInterpolation) {
        let scope = DefaultScopes.CloseShotVertex(attributes.get(GPUAttributes.position),
                                                  aTexel: attributes.get(GPUAttributes.texel),
                                                  aTbnMatrixCol1: attributes.get(GPUAttributes.tbnCol1),
                                                  aTbnMatrixCol2: attributes.get(GPUAttributes.tbnCol2),
                                                  aTbnMatrixCol3: attributes.get(GPUAttributes.tbnCol3),
                                                  uModelMatrix: uniforms.get(GPUUniforms.modelMatrix),
                                                  uViewMatrix: uniforms.get(GPUUniforms.viewMatrix),
                                                  uProjectionMatrix: uniforms.get(GPUUniforms.projectionMatrix),
                                                  uNormalMatrix: uniforms.get(GPUUniforms.normalMatrix),
                                                  uEyePosition: uniforms.get(GPUUniforms.eyePosition),
                                                  uLightDirection: uniforms.get(GPUUniforms.lightDirection),
                                                  uTextureScale: uniforms.get(GPUUniforms.textureScale),
                                                  vTexel: interpolation.vTexel,
                                                  vViewVector: interpolation.vViewVector,
                                                  vLightVector: interpolation.vLightVector)
    }
}

struct CloseShotInterpolation: GPUInterpolation {
    
    let vTexel: GPUVariable<GLSLVec2>
    let vViewVector: GPUVariable<GLSLVec3>
    let vLightVector: GPUVariable<GLSLVec3>
    
    func varyings() -> [GPUVarying] {
        return [GPUVarying(variable: vTexel, precision: .Low),
                GPUVarying(variable: vViewVector, precision: .Low),
                GPUVarying(variable: vLightVector, precision: .Low),]
    }
}


extension DefaultScopes {
    static func CloseShotVertex(
        aPosition: GPUVariable<GLSLVec4>,
        aTexel: GPUVariable<GLSLVec2>,
        aTbnMatrixCol1: GPUVariable<GLSLVec3>,
        aTbnMatrixCol2: GPUVariable<GLSLVec3>,
        aTbnMatrixCol3: GPUVariable<GLSLVec3>,
        uModelMatrix: GPUVariable<GLSLMat4>,
        uViewMatrix: GPUVariable<GLSLMat4>,
        uProjectionMatrix: GPUVariable<GLSLMat4>,
        uNormalMatrix: GPUVariable<GLSLMat3>,
        uEyePosition: GPUVariable<GLSLVec3>,
        uLightDirection: GPUVariable<GLSLVec3>,
        uTextureScale: GPUVariable<GLSLFloat>,
        vTexel: GPUVariable<GLSLVec2>,
        vViewVector: GPUVariable<GLSLVec3>,
        vLightVector: GPUVariable<GLSLVec3>
        ) -> GPUScope {
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        
        let tbnMatrix = GPUVariable<GLSLMat3>(name: "tbnMatrix")
        
        mainScope ↳ tbnMatrix
        mainScope ✍ tbnMatrix ⬅ GPUEvaluation(function: GPUFunction<GLSLMat3>(signature: "mat3", input: [aTbnMatrixCol1, aTbnMatrixCol2, aTbnMatrixCol3]))
        
        return globalScope
    }
    
    static func CloseShotFragment(
        
        ) -> GPUScope {
        let globalScope = GPUScope()
        
        
        
        return globalScope
    }
    
}