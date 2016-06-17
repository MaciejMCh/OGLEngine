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
            GPUUniform(variable: GPUUniforms.textureScale),
            GPUUniform(variable: GPUUniforms.colorMap),
            GPUUniform(variable: GPUUniforms.normalMap),
            GPUUniform(variable: GPUUniforms.lightColor),
            GPUUniform(variable: GPUUniforms.shininess)
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
                                                  uTextureScale: uniforms.get(GPUUniforms.textureScale),
                                                  uLightColor: uniforms.get(GPUUniforms.lightColor),
                                                  uShininess: uniforms.get(GPUUniforms.shininess),
                                                  vTBNMatrix: interpolation.vTBNMatrix,
                                                  vTexel: interpolation.vTexel,
                                                  vLightVersor: interpolation.vLightVersor,
                                                  vHalfVersor: interpolation.vHalfVersor,
                                                  vLightColor: interpolation.vLightColor,
                                                  vShininess: interpolation.vShininess)
        return GPUVertexShader(name: "CloseShot", attributes: attributes, uniforms: uniforms, interpolation: interpolation, function: MainGPUFunction(scope: scope))
    }
}

struct CloseShotInterpolation: GPUInterpolation {
    
    let vTexel: GPUVariable<GLSLVec2> = GPUVariable<GLSLVec2>(name: "vTexel")
    let vHalfVersor: GPUVariable<GLSLVec3> = GPUVariable<GLSLVec3>(name: "vHalfVersor")
    let vLightVersor: GPUVariable<GLSLVec3> = GPUVariable<GLSLVec3>(name: "vLightVersor")
    let vTBNMatrix: GPUVariable<GLSLMat3> = GPUVariable<GLSLMat3>(name: "vTBNMatrix")
    let vLightColor: GPUVariable<GLSLColor> = GPUVariable<GLSLColor>(name: "vLightColor")
    let vShininess: GPUVariable<GLSLFloat> = GPUVariable<GLSLFloat>(name: "vShininess")
    
    func varyings() -> [GPUVarying] {
        return [GPUVarying(variable: vTexel, precision: .Low),
                GPUVarying(variable: vLightVersor, precision: .Low),
                GPUVarying(variable: vLightColor, precision: .Low),
                GPUVarying(variable: vShininess, precision: .Low)]
    }
}

extension DefaultFragmentShaders {
    static func CloseShot(uniforms: GPUVariableCollection<AnyGPUUniform>,
                          interpolation: CloseShotInterpolation) -> GPUFragmentShader {
        let scope = DefaultScopes.CloseShotFragment(OpenGLDefaultVariables.glFragColor(),
                                                    uColorMap: uniforms.get(GPUUniforms.colorMap),
                                                    uNormalMap: uniforms.get(GPUUniforms.normalMap),
                                                    vTBNMatrix: interpolation.vTBNMatrix,
                                                    vTexel: interpolation.vTexel,
                                                    vLightVersor: interpolation.vLightVersor,
                                                    vHalfVersor: interpolation.vHalfVersor,
                                                    vLightColor: interpolation.vLightColor,
                                                    vShininess: interpolation.vShininess)
        return GPUFragmentShader(name: "CloseShot", uniforms: uniforms, interpolation: interpolation, function: MainGPUFunction(scope: scope))
    }
}

extension DefaultScopes {
    static func CloseShotVertex(
        glPosition: GPUVariable<GLSLVec4>,
        aPosition: GPUVariable<GLSLVec4>,
        aTexel: GPUVariable<GLSLVec2>,
        aNormal: GPUVariable<GLSLVec3>,
        aTangent: GPUVariable<GLSLVec3>,
        uModelMatrix: GPUVariable<GLSLMat4>,
        uViewProjectionMatrix: GPUVariable<GLSLMat4>,
        uNormalMatrix: GPUVariable<GLSLMat3>,
        uLightVersor: GPUVariable<GLSLVec3>,
        uEyePosition: GPUVariable<GLSLVec3>,
        uTextureScale: GPUVariable<GLSLFloat>,
        uLightColor: GPUVariable<GLSLColor>,
        uShininess: GPUVariable<GLSLFloat>,
        vTBNMatrix: GPUVariable<GLSLMat3>,
        vTexel: GPUVariable<GLSLVec2>,
        vLightVersor: GPUVariable<GLSLVec3>,
        vHalfVersor: GPUVariable<GLSLVec3>,
        vLightColor: GPUVariable<GLSLColor>,
        vShininess: GPUVariable<GLSLFloat>
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
        globalScope ⥥ uTextureScale
        globalScope ⥥ uLightColor
        globalScope ⥥ uShininess
        globalScope ⟿↘ vTexel
        globalScope ⟿↘ vLightVersor
        globalScope ⟿↘ vHalfVersor
        globalScope ⟿↘ vTBNMatrix
        globalScope ⟿↘ vLightColor
        globalScope ⟿↘ vShininess
        globalScope ↳ MainGPUFunction(scope: mainScope)
        
        mainScope ↳ worldSpacePosition
        mainScope ✍ worldSpacePosition ⬅ uModelMatrix * aPosition
        mainScope ✍ glPosition ⬅ uViewProjectionMatrix * worldSpacePosition
        mainScope ✍ vTexel ⬅ aTexel * uTextureScale
        mainScope ✍ vLightVersor ⬅ uLightVersor
        mainScope ✍ vLightColor ⬅ uLightColor
        mainScope ✍ vShininess ⬅ uShininess
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
        vTBNMatrix: GPUVariable<GLSLMat3>,
        vTexel: GPUVariable<GLSLVec2>,
        vLightVersor: GPUVariable<GLSLVec3>,
        vHalfVersor: GPUVariable<GLSLVec3>,
        vLightColor: GPUVariable<GLSLColor>,
        vShininess: GPUVariable<GLSLFloat>
        ) -> GPUScope {
        
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        let halfVersor = GPUVariable<GLSLVec3>(name: "halfVersor")
        let lightVersor = GPUVariable<GLSLVec3>(name: "lightVersor")
        let fixedNormal = GPUVariable<GLSLVec3>(name: "fixedNormal")
        let fullDiffuseColor = GPUVariable<GLSLColor>(name: "fullDiffuseColor")
        let lightColor = GPUVariable<GLSLColor>(name: "lightColor")
        let shininess = GPUVariable<GLSLFloat>(name: "shininess")
        let normalMapSample = GPUVariable<GLSLColor>(name: "normalMapSample")
        let phongScope = DefaultScopes.PhongReflectionColorScope(
            fixedNormal,
            lightVector: lightVersor,
            halfVector: halfVersor,
            fullDiffuseColor: fullDiffuseColor,
            lightColor: lightColor,
            shininess: shininess,
            phongColor: glFragColor)
        
        globalScope ⟿↘ vTexel
        globalScope ⟿↘ vLightVersor
        globalScope ⟿↘ vHalfVersor
        globalScope ⟿↘ vTBNMatrix
        globalScope ⟿↘ vLightColor
        globalScope ⟿↘ vShininess
        globalScope ⥥ uColorMap
        globalScope ⥥ uNormalMap
        globalScope ↳ MainGPUFunction(scope: mainScope)
        
        mainScope ↳↘ lightVersor
        mainScope ✍ lightVersor ⬅ ^vLightVersor
        mainScope ↳↘ halfVersor
        mainScope ✍ halfVersor ⬅ ^vHalfVersor
        mainScope ↳↘ fullDiffuseColor
        mainScope ✍ fullDiffuseColor ⬅ uColorMap ☒ vTexel
        mainScope ↳↘ lightColor
        mainScope ✍ lightColor ⬅ vLightColor
        mainScope ↳↘ shininess
        mainScope ✍ shininess ⬅ vShininess
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