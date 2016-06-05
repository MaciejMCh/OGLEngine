//
//  CloseShot.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 01.06.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

extension DefaultPipelines {
    static func CloseShot() -> GPUPipeline {
        
        let attributes = GPUVariableCollection<AnyGPUAttribute>(collection: [
            GPUAttributes.position,
            GPUAttributes.texel,
            GPUAttributes.tbnCol1,
            GPUAttributes.tbnCol2,
            GPUAttributes.tbnCol3
            ])
        let uniforms = GPUVariableCollection<AnyGPUUniform>(collection: [
            GPUUniform(variable: GPUUniforms.modelMatrix),
            GPUUniform(variable: GPUUniforms.viewMatrix),
            GPUUniform(variable: GPUUniforms.projectionMatrix),
            GPUUniform(variable: GPUUniforms.normalMatrix),
            GPUUniform(variable: GPUUniforms.eyePosition),
            GPUUniform(variable: GPUUniforms.lightDirection),
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
                                                  uLightColor: uniforms.get(GPUUniforms.lightColor),
                                                  uShininess: uniforms.get(GPUUniforms.shininess),
                                                  vTexel: interpolation.vTexel,
                                                  vViewVector: interpolation.vViewVector,
                                                  vLightVector: interpolation.vLightVector,
                                                  vLightColor: interpolation.vLightColor,
                                                  vShininess: interpolation.vShininess)
        return GPUVertexShader(name: "CloseShot", attributes: attributes, uniforms: uniforms, interpolation: interpolation, function: MainGPUFunction(scope: scope))
    }
}

struct CloseShotInterpolation: GPUInterpolation {
    
    let vTexel: GPUVariable<GLSLVec2> = GPUVariable<GLSLVec2>(name: "vTexel")
    let vViewVector: GPUVariable<GLSLVec3> = GPUVariable<GLSLVec3>(name: "vViewVector")
    let vLightVector: GPUVariable<GLSLVec3> = GPUVariable<GLSLVec3>(name: "vLightVector")
    let vLightColor: GPUVariable<GLSLColor> = GPUVariable<GLSLColor>(name: "vLightColor")
    let vShininess: GPUVariable<GLSLFloat> = GPUVariable<GLSLFloat>(name: "vShininess")
    
    func varyings() -> [GPUVarying] {
        return [GPUVarying(variable: vTexel, precision: .Low),
                GPUVarying(variable: vViewVector, precision: .Low),
                GPUVarying(variable: vLightVector, precision: .Low),
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
                                                    vTexel: interpolation.vTexel,
                                                    vViewVector: interpolation.vViewVector,
                                                    vLightVector: interpolation.vLightVector,
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
        uLightColor: GPUVariable<GLSLColor>,
        uShininess: GPUVariable<GLSLFloat>,
        vTexel: GPUVariable<GLSLVec2>,
        vViewVector: GPUVariable<GLSLVec3>,
        vLightVector: GPUVariable<GLSLVec3>,
        vLightColor: GPUVariable<GLSLColor>,
        vShininess: GPUVariable<GLSLFloat>
        ) -> GPUScope {
        
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        let tbnMatrix = GPUVariable<GLSLMat3>(name: "tbnMatrix")
        let worldSpacePosition = GPUVariable<GLSLVec4>(name: "worldSpacePosition")
        let worldSpacePositionVector = GPUVariable<GLSLVec3>(name: "worldSpacePositionVector")
        let viewProjectionMatrix = GPUVariable<GLSLMat4>(name: "viewProjectionMatrix")
        
        mainScope ✍ vLightColor ⬅ uLightColor
        mainScope ✍ vShininess ⬅ uShininess
        mainScope ✍ vTexel ⬅ aTexel * uTextureScale
        mainScope ↳ tbnMatrix
        mainScope ✍ tbnMatrix ⬅ GPUEvaluation(function: GPUFunction<GLSLMat3>(signature: "mat3", input: [aTbnMatrixCol1, aTbnMatrixCol2, aTbnMatrixCol3]))
        mainScope ✍ vLightVector ⬅ uLightDirection * GPUVariable<GLSLFloat>(value: -1.0)
//        mainScope ✍ vLightVector ⬅ uNormalMatrix * vLightVector
        mainScope ✍ vLightVector ⬅ tbnMatrix * vLightVector
        mainScope ↳ worldSpacePosition
        mainScope ✍ worldSpacePosition ⬅ uModelMatrix * aPosition
        mainScope ↳ worldSpacePositionVector
        mainScope ✍ worldSpacePositionVector ⬅ GPUEvaluation(function: GPUFunction<GLSLVec3>(signature: "vec3", input: [worldSpacePosition]))
        mainScope ✍ vViewVector ⬅ (uEyePosition - worldSpacePositionVector)
//        mainScope ✍ vViewVector ⬅ uNormalMatrix * vViewVector
        mainScope ✍ vViewVector ⬅ tbnMatrix * vViewVector
        mainScope ↳ viewProjectionMatrix
        mainScope ✍ viewProjectionMatrix ⬅ uProjectionMatrix * uViewMatrix
        mainScope ✍ glPosition ⬅ viewProjectionMatrix * worldSpacePosition
        
        globalScope ⥤ aPosition
        globalScope ⥤ aTexel
        globalScope ⥤ aTbnMatrixCol1
        globalScope ⥤ aTbnMatrixCol2
        globalScope ⥤ aTbnMatrixCol3
        globalScope ⥥ uModelMatrix
        globalScope ⥥ uViewMatrix
        globalScope ⥥ uProjectionMatrix
        globalScope ⥥ uNormalMatrix
        globalScope ⥥ uEyePosition
        globalScope ⥥ uLightDirection
        globalScope ⥥ uTextureScale
        globalScope ⥥ uLightColor
        globalScope ⥥ uShininess
        globalScope ⟿↘ vTexel
        globalScope ⟿↘ vViewVector
        globalScope ⟿↘ vLightVector
        globalScope ⟿↘ vLightColor
        globalScope ⟿↘ vShininess
        globalScope ↳ MainGPUFunction(scope: mainScope)
        
        return globalScope
    }
    
    static func CloseShotFragment(
        glFragColor: GPUVariable<GLSLColor>,
        uColorMap: GPUVariable<GLSLTexture>,
        uNormalMap: GPUVariable<GLSLTexture>,
        vTexel: GPUVariable<GLSLVec2>,
        vViewVector: GPUVariable<GLSLVec3>,
        vLightVector: GPUVariable<GLSLVec3>,
        vLightColor: GPUVariable<GLSLColor>,
        vShininess: GPUVariable<GLSLFloat>
        ) -> GPUScope {
        
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        let normalMapSample = GPUVariable<GLSLColor>(name: "normalMapSample")
        let normalVersor = GPUVariable<GLSLVec3>(name: "normalVersor")
        let viewVersor = GPUVariable<GLSLVec3>(name: "viewVersor")
        let lightVersor = GPUVariable<GLSLVec3>(name: "lightVersor")
        let halfVector = GPUVariable<GLSLVec3>(name: "halfVector")
        let colorFromMap = GPUVariable<GLSLColor>(name: "colorFromMap")
        let phongScope = DefaultScopes.PhongReflectionColorScope(normalVersor,
                                                                 lightVector: lightVersor,
                                                                 halfVector: halfVector,
                                                                 fullDiffuseColor: colorFromMap,
                                                                 lightColor: vLightColor,
                                                                 shininess: vShininess,
                                                                 phongColor: glFragColor)
        
        globalScope ⥥ uNormalMap
        globalScope ⥥ uColorMap
        globalScope ⟿↘ vTexel
        globalScope ⟿↘ vViewVector
        globalScope ⟿↘ vLightVector
        globalScope ⟿↘ vLightColor
        globalScope ⟿↘ vShininess
        
        globalScope ↳ MainGPUFunction(scope: mainScope)
        
        mainScope ↳↘ normalMapSample
        mainScope ✍ normalMapSample ⬅ uNormalMap ☒ vTexel
        mainScope ↳↘ normalVersor
        mainScope ✍ normalVersor ⬅ ⤺normalMapSample
        mainScope ↳↘ viewVersor
        mainScope ✍ viewVersor ⬅ ^vViewVector
        mainScope ↳↘ lightVersor
        mainScope ✍ lightVersor ⬅ ^vLightVector
        mainScope ↳↘ halfVector
        mainScope ✍ halfVector ⬅ (lightVersor + viewVersor)
        mainScope ✍ halfVector ⬅ ^halfVector
        mainScope ↳↘ colorFromMap
        mainScope ✍ colorFromMap ⬅ uColorMap ☒ vTexel
        mainScope ⎘ phongScope
        
        return globalScope
    }
    
}