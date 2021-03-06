//
//  CloseShot.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 01.06.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

extension DefaultPipelines {
    static func CloseShot() -> GPUPipeline {
        
        let attributes = GPUVariableCollection<AnyGPUAttribute>(collection: [
            GPUAttributes.position,
            GPUAttributes.texel,
            GPUAttributes.normal,
            GPUAttributes.tangent
            ])
        let uniforms = GPUVariableCollection<AnyGPUUniform>(collection: [
            GPUUniform(variable: GPUUniforms.modelMatrix),
            GPUUniform(variable: GPUUniforms.viewProjectionMatrix),
            GPUUniform(variable: GPUUniforms.normalMatrix),
            GPUUniform(variable: GPUUniforms.eyePosition),
            GPUUniform(variable: GPUUniforms.lightVersor),
            GPUUniform(variable: GPUUniforms.colorMap),
            GPUUniform(variable: GPUUniforms.normalMap),
            GPUUniform(variable: GPUUniforms.specularMap),
            GPUUniform(variable: GPUUniforms.lightColor),
            GPUUniform(variable: GPUUniforms.specularPower),
            GPUUniform(variable: GPUUniforms.specularWidth),
            GPUUniform(variable: GPUUniforms.ambiencePower)
            ])
        let interpolation = CloseShotInterpolation()
        let vertexShader = DefaultVertexShaders.CloseShot(attributes, uniforms: uniforms, interpolation: interpolation)
        let fragmentShader = DefaultFragmentShaders.CloseShot(uniforms, interpolation: interpolation)
        return GPUPipeline(vertexShader: vertexShader, fragmentShader: fragmentShader)
    }
}

extension DefaultVertexShaders {
    static func CloseShot(attributes: GPUVariableCollection<AnyGPUAttribute>,
                          uniforms: GPUVariableCollection<AnyGPUUniform>,
                          interpolation: CloseShotInterpolation) -> GPUVertexShader {
        let scope = DefaultScopes.CloseShotVertex(OpenGLDefaultVariables.glPosition(),
                                                  aPosition: attributes.get(GPUAttributes.position),
                                                  aTexel: attributes.get(GPUAttributes.texel),
                                                  aNormal: attributes.get(GPUAttributes.normal),
                                                  aTangent: attributes.get(GPUAttributes.tangent),
                                                  uModelMatrix: uniforms.get(GPUUniforms.modelMatrix),
                                                  uViewProjectionMatrix: uniforms.get(GPUUniforms.viewProjectionMatrix),
                                                  uNormalMatrix: uniforms.get(GPUUniforms.normalMatrix),
                                                  uLightVersor: uniforms.get(GPUUniforms.lightVersor),
                                                  uEyePosition: uniforms.get(GPUUniforms.eyePosition),
                                                  uLightColor: uniforms.get(GPUUniforms.lightColor),
                                                  uSpecularPower: uniforms.get(GPUUniforms.specularPower),
                                                  uSpecularWidth: uniforms.get(GPUUniforms.specularWidth),
                                                  uAmbiencePower: uniforms.get(GPUUniforms.ambiencePower),
                                                  vTBNMatrix: interpolation.vTBNMatrix,
                                                  vTexel: interpolation.vTexel,
                                                  vLightVersor: interpolation.vLightVersor,
                                                  vHalfVersor: interpolation.vHalfVersor,
                                                  vLightColor: interpolation.vLightColor,
                                                  vSpecularPower: interpolation.vSpecularPower,
                                                  vSpecularWidth: interpolation.vSpecularWidth,
                                                  vAmbiencePower: interpolation.vAmbientLightPower
        )
        return GPUVertexShader(name: "CloseShot", attributes: attributes, uniforms: uniforms, interpolation: interpolation, function: MainGPUFunction(scope: scope))
    }
}

struct CloseShotInterpolation: GPUInterpolation {
    
    let vTexel: GPUVariable<GLSLVec2> = GPUVariable<GLSLVec2>(name: "vTexel")
    let vHalfVersor: GPUVariable<GLSLVec3> = GPUVariable<GLSLVec3>(name: "vHalfVersor")
    let vLightVersor: GPUVariable<GLSLVec3> = GPUVariable<GLSLVec3>(name: "vLightVersor")
    let vTBNMatrix: GPUVariable<GLSLMat3> = GPUVariable<GLSLMat3>(name: "vTBNMatrix")
    let vLightColor: GPUVariable<GLSLColor> = GPUVariable<GLSLColor>(name: "vLightColor")
    let vSpecularPower: GPUVariable<GLSLFloat> = GPUVariable<GLSLFloat>(name: "vReflectionPower")
    let vSpecularWidth: GPUVariable<GLSLFloat> = GPUVariable<GLSLFloat>(name: "vReflectionWidth")
    let vAmbientLightPower: GPUVariable<GLSLFloat> = GPUVariable<GLSLFloat>(name: "vAmbientLightPower")
    
    
    func varyings() -> [GPUVarying] {
        return [GPUVarying(variable: vTexel, precision: .Low),
                GPUVarying(variable: vLightVersor, precision: .Low),
                GPUVarying(variable: vLightColor, precision: .Low),
                GPUVarying(variable: vSpecularPower, precision: .Low),
                GPUVarying(variable: vSpecularWidth, precision: .Low),
                GPUVarying(variable: vAmbientLightPower, precision: .Low)
        ]
    }
}

extension DefaultFragmentShaders {
    static func CloseShot(uniforms: GPUVariableCollection<AnyGPUUniform>,
                          interpolation: CloseShotInterpolation) -> GPUFragmentShader {
        let scope = DefaultScopes.CloseShotFragment(OpenGLDefaultVariables.glFragColor(),
                                                    uColorMap: uniforms.get(GPUUniforms.colorMap),
                                                    uNormalMap: uniforms.get(GPUUniforms.normalMap),
                                                    uSpecularMap: uniforms.get(GPUUniforms.specularMap),
                                                    vTBNMatrix: interpolation.vTBNMatrix,
                                                    vTexel: interpolation.vTexel,
                                                    vLightVersor: interpolation.vLightVersor,
                                                    vHalfVersor: interpolation.vHalfVersor,
                                                    vLightColor: interpolation.vLightColor,
                                                    vSpecularPower: interpolation.vSpecularPower,
                                                    vSpecularWidth: interpolation.vSpecularWidth,
                                                    vAmbiencePower: interpolation.vAmbientLightPower
        )
        return GPUFragmentShader(name: "CloseShot", uniforms: uniforms, interpolation: interpolation, function: MainGPUFunction(scope: scope))
    }
}

extension DefaultScopes {
    static func CloseShotVertex(
        glPosition: GPUVariable<GLSLVec4>,
        aPosition: GPUVariable<GLSLVec3>,
        aTexel: GPUVariable<GLSLVec2>,
        aNormal: GPUVariable<GLSLVec3>,
        aTangent: GPUVariable<GLSLVec3>,
        uModelMatrix: GPUVariable<GLSLMat4>,
        uViewProjectionMatrix: GPUVariable<GLSLMat4>,
        uNormalMatrix: GPUVariable<GLSLMat3>,
        uLightVersor: GPUVariable<GLSLVec3>,
        uEyePosition: GPUVariable<GLSLVec3>,
        uLightColor: GPUVariable<GLSLColor>,
        uSpecularPower: GPUVariable<GLSLFloat>,
        uSpecularWidth: GPUVariable<GLSLFloat>,
        uAmbiencePower: GPUVariable<GLSLFloat>,
        vTBNMatrix: GPUVariable<GLSLMat3>,
        vTexel: GPUVariable<GLSLVec2>,
        vLightVersor: GPUVariable<GLSLVec3>,
        vHalfVersor: GPUVariable<GLSLVec3>,
        vLightColor: GPUVariable<GLSLColor>,
        vSpecularPower: GPUVariable<GLSLFloat>,
        vSpecularWidth: GPUVariable<GLSLFloat>,
        vAmbiencePower: GPUVariable<GLSLFloat>
        ) -> GPUScope {
        
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        let worldSpacePosition = GPUVariable<GLSLVec4>(name: "worldSpacePosition")
        let tbnScope = DefaultScopes.FragmentTBNMatrixScope(aNormal, aTangent: aTangent, uNormalMatrix: uNormalMatrix, vTBNMatrix: vTBNMatrix)
        let viewVersor = GPUVariable<GLSLVec3>(name: "viewVector")
        let positionVector = GPUVariable<GLSLVec3>(name: "positionVector")
        let halfVersorScope = DefaultScopes.PhongHalfVersor(vLightVersor, modelPosition: positionVector, eyePosition: uEyePosition, viewVersor: viewVersor, halfVersor: vHalfVersor)
        
        globalScope ⥤ aPosition
        globalScope ⥤ aTexel
        globalScope ⥤ aNormal
        globalScope ⥤ aTangent
        globalScope ⥥ uModelMatrix
        globalScope ⥥ uViewProjectionMatrix
        globalScope ⥥ uNormalMatrix
        globalScope ⥥ uLightVersor
        globalScope ⥥ uEyePosition
        globalScope ⥥ uLightColor
        globalScope ⥥ uSpecularPower
        globalScope ⥥ uSpecularWidth
        globalScope ⥥ uAmbiencePower
        globalScope ⟿↘ vTexel
        globalScope ⟿↘ vLightVersor
        globalScope ⟿↘ vHalfVersor
        globalScope ⟿↘ vTBNMatrix
        globalScope ⟿↘ vLightColor
        globalScope ⟿↘ vSpecularPower
        globalScope ⟿↘ vSpecularWidth
        globalScope ⟿↘ vAmbiencePower
        globalScope ↳ MainGPUFunction(scope: mainScope)
        
        mainScope ✍ vSpecularPower ⬅ uSpecularPower
        mainScope ✍ vSpecularWidth ⬅ uSpecularWidth
        mainScope ✍ vAmbiencePower ⬅ uAmbiencePower
        mainScope ↳ worldSpacePosition
        mainScope ✍ worldSpacePosition ⬅ uModelMatrix * aPosition
        mainScope ✍ glPosition ⬅ uViewProjectionMatrix * worldSpacePosition
        mainScope ✍ vTexel ⬅ aTexel
        mainScope ✍ vLightVersor ⬅ uLightVersor
        mainScope ✍ vLightColor ⬅ uLightColor
        mainScope ↳ positionVector
        mainScope ✍ positionVector ⬅ GPUEvaluation(function: GPUFunction(signature: "vec3", input: [worldSpacePosition]))
        mainScope ⎘ tbnScope
        mainScope ↳ viewVersor
        mainScope ⎘ halfVersorScope
        
        return globalScope
    }
    
    static func CloseShotFragment(
        glFragColor: GPUVariable<GLSLColor>,
        uColorMap: GPUVariable<GLSLTexture>,
        uNormalMap: GPUVariable<GLSLTexture>,
        uSpecularMap: GPUVariable<GLSLTexture>,
        vTBNMatrix: GPUVariable<GLSLMat3>,
        vTexel: GPUVariable<GLSLVec2>,
        vLightVersor: GPUVariable<GLSLVec3>,
        vHalfVersor: GPUVariable<GLSLVec3>,
        vLightColor: GPUVariable<GLSLColor>,
        vSpecularPower: GPUVariable<GLSLFloat>,
        vSpecularWidth: GPUVariable<GLSLFloat>,
        vAmbiencePower: GPUVariable<GLSLFloat>
        ) -> GPUScope {
        
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        let halfVersor = GPUVariable<GLSLVec3>(name: "halfVersor")
        let lightVersor = GPUVariable<GLSLVec3>(name: "lightVersor")
        let fixedNormal = GPUVariable<GLSLVec3>(name: "fixedNormal")
        let fullDiffuseColor = GPUVariable<GLSLColor>(name: "fullDiffuseColor")
        let lightColor = GPUVariable<GLSLColor>(name: "lightColor")
        let specularSample = GPUVariable<GLSLFloat>(name: "specularSample")
        let normalMapSample = GPUVariable<GLSLColor>(name: "normalMapSample")
        let phongScope = DefaultScopes.AdvancedPhongReflectionColorScope(
            fixedNormal,
            lightVector: lightVersor,
            halfVector: halfVersor,
            fullDiffuseColor: fullDiffuseColor,
            lightColor: lightColor,
            specularSample: specularSample,
            specularPower: vSpecularPower,
            specularWidth: vSpecularWidth,
            ambiencePower: vAmbiencePower,
            phongColor: glFragColor)
        
        globalScope ⟿↘ vTexel
        globalScope ⟿↘ vLightVersor
        globalScope ⟿↘ vHalfVersor
        globalScope ⟿↘ vTBNMatrix
        globalScope ⟿↘ vLightColor
        globalScope ⟿↘ vSpecularPower
        globalScope ⟿↘ vSpecularWidth
        globalScope ⟿↘ vAmbiencePower
        globalScope ⥥ uColorMap
        globalScope ⥥ uNormalMap
        globalScope ⥥ uSpecularMap
        globalScope ↳ MainGPUFunction(scope: mainScope)
        
        mainScope ↳↘ lightVersor
        mainScope ✍ lightVersor ⬅ ^vLightVersor
        mainScope ↳↘ halfVersor
        mainScope ✍ halfVersor ⬅ ^vHalfVersor
        mainScope ↳↘ fullDiffuseColor
        mainScope ✍ fullDiffuseColor ⬅ uColorMap ☒ vTexel
        mainScope ↳↘ lightColor
        mainScope ✍ lightColor ⬅ vLightColor
        mainScope ↳↘ specularSample
        mainScope ✍ specularSample ⬅ uSpecularMap ☒ vTexel
        mainScope ↳↘ normalMapSample
        mainScope ✍ normalMapSample ⬅ uNormalMap ☒ vTexel
        mainScope ↳↘ fixedNormal
        mainScope ✍ fixedNormal ⬅ ⤺normalMapSample
        mainScope ✍ fixedNormal ⬅ ^fixedNormal
        mainScope ✍ fixedNormal ⬅ vTBNMatrix * fixedNormal
        mainScope ✍ fixedNormal ⬅ ^fixedNormal
        mainScope ⎘ phongScope
        
        return globalScope
    }
    
}