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
        
        let attributes = GPUAttributesCollection(collection: [
            GPUAttributes.position,
            GPUAttributes.texel,
            GPUAttributes.normal,
            GPUAttributes.tangent
            ])
        let uniforms = UniformsCollection(collection: [
            GPUUniforms.modelMatrix,
            GPUUniforms.viewProjectionMatrix,
            GPUUniforms.normalMatrix,
            GPUUniforms.eyePosition,
            GPUUniforms.lightVersor,
            GPUUniforms.colorMap,
            GPUUniforms.normalMap,
            GPUUniforms.specularMap,
            GPUUniforms.lightColor,
            GPUUniforms.specularPower,
            GPUUniforms.specularWidth,
            GPUUniforms.ambiencePower
            ])
        let interpolation = CloseShotInterpolation()
        let vertexShader = DefaultVertexShaders.CloseShot(attributes, uniforms: uniforms, interpolation: interpolation)
        let fragmentShader = DefaultFragmentShaders.CloseShot(uniforms, interpolation: interpolation)
        return GPUPipeline(vertexShader: vertexShader, fragmentShader: fragmentShader)
    }
}

extension DefaultVertexShaders {
    static func CloseShot(attributes: GPUAttributesCollection,
                          uniforms: UniformsCollection,
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
    
    let vTexel: Variable<GLSLVec2> = Variable<GLSLVec2>(name: "vTexel")
    let vHalfVersor: Variable<GLSLVec3> = Variable<GLSLVec3>(name: "vHalfVersor")
    let vLightVersor: Variable<GLSLVec3> = Variable<GLSLVec3>(name: "vLightVersor")
    let vTBNMatrix: Variable<GLSLMat3> = Variable<GLSLMat3>(name: "vTBNMatrix")
    let vLightColor: Variable<GLSLColor> = Variable<GLSLColor>(name: "vLightColor")
    let vSpecularPower: Variable<GLSLFloat> = Variable<GLSLFloat>(name: "vReflectionPower")
    let vSpecularWidth: Variable<GLSLFloat> = Variable<GLSLFloat>(name: "vReflectionWidth")
    let vAmbientLightPower: Variable<GLSLFloat> = Variable<GLSLFloat>(name: "vAmbientLightPower")
    
    
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
    static func CloseShot(uniforms: UniformsCollection,
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
        glPosition: Variable<GLSLVec4>,
        aPosition: Variable<GLSLVec3>,
        aTexel: Variable<GLSLVec2>,
        aNormal: Variable<GLSLVec3>,
        aTangent: Variable<GLSLVec3>,
        uModelMatrix: Variable<GLSLMat4>,
        uViewProjectionMatrix: Variable<GLSLMat4>,
        uNormalMatrix: Variable<GLSLMat3>,
        uLightVersor: Variable<GLSLVec3>,
        uEyePosition: Variable<GLSLVec3>,
        uLightColor: Variable<GLSLColor>,
        uSpecularPower: Variable<GLSLFloat>,
        uSpecularWidth: Variable<GLSLFloat>,
        uAmbiencePower: Variable<GLSLFloat>,
        vTBNMatrix: Variable<GLSLMat3>,
        vTexel: Variable<GLSLVec2>,
        vLightVersor: Variable<GLSLVec3>,
        vHalfVersor: Variable<GLSLVec3>,
        vLightColor: Variable<GLSLColor>,
        vSpecularPower: Variable<GLSLFloat>,
        vSpecularWidth: Variable<GLSLFloat>,
        vAmbiencePower: Variable<GLSLFloat>
        ) -> GPUScope {
        
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        let worldSpacePosition = Variable<GLSLVec4>(name: "worldSpacePosition")
        let tbnScope = DefaultScopes.FragmentTBNMatrixScope(aNormal, aTangent: aTangent, uNormalMatrix: uNormalMatrix, vTBNMatrix: vTBNMatrix)
        let viewVersor = Variable<GLSLVec3>(name: "viewVector")
        let positionVector = Variable<GLSLVec3>(name: "positionVector")
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
        mainScope ✍ positionVector ⬅ VecInits.vec3(worldSpacePosition)
        mainScope ⎘ tbnScope
        mainScope ↳ viewVersor
        mainScope ⎘ halfVersorScope
        
        return globalScope
    }
    
    static func CloseShotFragment(
        glFragColor: Variable<GLSLColor>,
        uColorMap: Variable<GLSLTexture>,
        uNormalMap: Variable<GLSLTexture>,
        uSpecularMap: Variable<GLSLTexture>,
        vTBNMatrix: Variable<GLSLMat3>,
        vTexel: Variable<GLSLVec2>,
        vLightVersor: Variable<GLSLVec3>,
        vHalfVersor: Variable<GLSLVec3>,
        vLightColor: Variable<GLSLColor>,
        vSpecularPower: Variable<GLSLFloat>,
        vSpecularWidth: Variable<GLSLFloat>,
        vAmbiencePower: Variable<GLSLFloat>
        ) -> GPUScope {
        
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        let halfVersor = Variable<GLSLVec3>(name: "halfVersor")
        let lightVersor = Variable<GLSLVec3>(name: "lightVersor")
        let fixedNormal = Variable<GLSLVec3>(name: "fixedNormal")
        let fullDiffuseColor = Variable<GLSLColor>(name: "fullDiffuseColor")
        let lightColor = Variable<GLSLColor>(name: "lightColor")
        let specularSample = Variable<GLSLFloat>(name: "specularSample")
        let normalMapSample = Variable<GLSLColor>(name: "normalMapSample")
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