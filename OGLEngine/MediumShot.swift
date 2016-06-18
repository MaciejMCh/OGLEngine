//
//  MediumShot.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 31.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

extension DefaultPipelines {
    static func MediumShot() -> GPUPipeline {
        let attributes = GPUVariableCollection<AnyGPUAttribute>(collection: [
            GPUAttributes.position,
            GPUAttributes.texel,
            GPUAttributes.normal
            ])
        let uniforms = GPUVariableCollection<AnyGPUUniform>(collection: [
            GPUUniform(variable: GPUUniforms.lightDirection),
            GPUUniform(variable: GPUUniforms.lightHalfVector),
            GPUUniform(variable: GPUUniforms.normalMatrix),
            GPUUniform(variable: GPUUniforms.modelViewProjectionMatrix),
            GPUUniform(variable: GPUUniforms.textureScale),
            GPUUniform(variable: GPUUniforms.shininess),
            GPUUniform(variable: GPUUniforms.lightColor),
            GPUUniform(variable: GPUUniforms.colorMap)
            ])
        let interpolation = MediumShotInterpolation()
        
        let vertexShader = DefaultVertexShaders.MediumShot(attributes, uniforms: uniforms, interpolation: interpolation)
        let fragmentShader = DefaultFragmentShaders.MediumShot(uniforms, interpolation: interpolation)
        return GPUPipeline(vertexShader: vertexShader, fragmentShader: fragmentShader)
    }
}

extension DefaultVertexShaders {
    static func MediumShot(attributes: GPUVariableCollection<AnyGPUAttribute>,
                           uniforms: GPUVariableCollection<AnyGPUUniform>,
                           interpolation: MediumShotInterpolation) -> GPUVertexShader {
        
        let scope = DefaultScopes.MediumShotVertex(
            OpenGLDefaultVariables.glPosition(),
            aPosition: attributes.get(GPUAttributes.position),
            aTexel: attributes.get(GPUAttributes.texel),
            aNormal: attributes.get(GPUAttributes.normal),
            vTexel: interpolation.vTexel,
            vLighDirection: interpolation.vLighDirection,
            vLighHalfVector: interpolation.vLighHalfVector,
            vNormal: interpolation.vNormal,
            vShininess: interpolation.vShininess,
            vLightColor: interpolation.vLightColor,
            uLighDirection: uniforms.get(GPUUniforms.lightDirection),
            uLighHalfVector: uniforms.get(GPUUniforms.lightHalfVector),
            uNormalMatrix: uniforms.get(GPUUniforms.normalMatrix),
            uModelViewProjectionMatrix: uniforms.get(GPUUniforms.modelViewProjectionMatrix),
            uTextureScale: uniforms.get(GPUUniforms.textureScale),
            uShininess: uniforms.get(GPUUniforms.shininess),
            uLightColor: uniforms.get(GPUUniforms.lightColor))
        
        return GPUVertexShader(name: "MediumShot", attributes: attributes, uniforms: uniforms, interpolation: interpolation, function: MainGPUFunction(scope: scope))
    }
}

struct MediumShotInterpolation: GPUInterpolation {
    let vTexel = GPUVariable<GLSLVec2>(name: "vTexel")
    let vLighDirection = GPUVariable<GLSLVec3>(name: "vLighDirection")
    let vLighHalfVector = GPUVariable<GLSLVec3>(name: "vLighHalfVector")
    let vNormal = GPUVariable<GLSLVec3>(name: "vNormal")
    let vLightColor = GPUVariable<GLSLColor>(name: "vLightColor")
    let vShininess = GPUVariable<GLSLFloat>(name: "vShininess")
    
    func varyings() -> [GPUVarying] {
        return [
            GPUVarying(variable: vTexel, precision: .Low),
            GPUVarying(variable: vLighDirection, precision: .Low),
            GPUVarying(variable: vLighHalfVector, precision: .Low),
            GPUVarying(variable: vNormal, precision: .Low),
            GPUVarying(variable: vLightColor, precision: .Low),
            GPUVarying(variable: vShininess, precision: .Low),
        ]
    }
}

extension DefaultFragmentShaders {
    static func MediumShot(uniforms: GPUVariableCollection<AnyGPUUniform>, interpolation: MediumShotInterpolation) -> GPUFragmentShader {
        return GPUFragmentShader(name: "MediumShot",
                                 uniforms: uniforms,
                                 interpolation: interpolation,
                                 function: MainGPUFunction(scope: DefaultScopes.MediumShotFragment(
                                    uniforms.get(GPUUniforms.colorMap),
                                    vTexel: interpolation.vTexel,
                                    vLighDirection: interpolation.vLighDirection,
                                    vLighHalfVector: interpolation.vLighHalfVector,
                                    vNormal: interpolation.vNormal,
                                    vLightColor: interpolation.vLightColor,
                                    vShininess: interpolation.vShininess)))
    }
}

extension DefaultScopes {
    static func MediumShotFragment(
        uColorMap: GPUVariable<GLSLTexture>,
        vTexel: GPUVariable<GLSLVec2>,
        vLighDirection: GPUVariable<GLSLVec3>,
        vLighHalfVector: GPUVariable<GLSLVec3>,
        vNormal: GPUVariable<GLSLVec3>,
        vLightColor: GPUVariable<GLSLColor>,
        vShininess: GPUVariable<GLSLFloat>
        ) -> GPUScope {
        
        let globalScope = GPUScope()
        let bodyScope = GPUScope()
        let mainFunction = MainGPUFunction(scope: bodyScope)
        let normalizedNormal = GPUVariable<GLSLVec3>(name: "normalizedNormal")
        let colorFromMap = GPUVariable<GLSLColor>(name: "colorFromMap")
        
        globalScope ⥥ uColorMap
        globalScope ⟿↘ vTexel
        globalScope ⟿↘ vNormal
        globalScope ⟿↘ vLighDirection
        globalScope ⟿↘ vLighHalfVector
        globalScope ⟿↘ vShininess
        globalScope ⟿↘ vLightColor
        globalScope ↳ mainFunction
        
        let phongScope = DefaultScopes.PhongReflectionColorScope(normalizedNormal,
                                                                 lightVector: vLighDirection,
                                                                 halfVector: vLighHalfVector,
                                                                 fullDiffuseColor: colorFromMap,
                                                                 lightColor: vLightColor,
                                                                 shininess: vShininess,
                                                                 phongColor: OpenGLDefaultVariables.glFragColor())
        bodyScope ↳↘ normalizedNormal
        bodyScope ✍ normalizedNormal ⬅ ^vNormal
        bodyScope ↳↘ colorFromMap
        bodyScope ✍ colorFromMap ⬅ uColorMap ☒ vTexel
        bodyScope ⎘ phongScope
        
        return globalScope
    }
    
    static func MediumShotVertex(
        glPosition: GPUVariable<GLSLVec4>,
        
        aPosition: GPUVariable<GLSLVec3>,
        aTexel: GPUVariable<GLSLVec2>,
        aNormal: GPUVariable<GLSLVec3>,
        
        vTexel: GPUVariable<GLSLVec2>,
        vLighDirection: GPUVariable<GLSLVec3>,
        vLighHalfVector: GPUVariable<GLSLVec3>,
        vNormal: GPUVariable<GLSLVec3>,
        vShininess: GPUVariable<GLSLFloat>,
        vLightColor: GPUVariable<GLSLColor>,
        
        uLighDirection: GPUVariable<GLSLVec3>,
        uLighHalfVector: GPUVariable<GLSLVec3>,
        uNormalMatrix: GPUVariable<GLSLMat3>,
        uModelViewProjectionMatrix: GPUVariable<GLSLMat4>,
        uTextureScale: GPUVariable<GLSLFloat>,
        uShininess: GPUVariable<GLSLFloat>,
        uLightColor: GPUVariable<GLSLColor>
        ) -> GPUScope {
        let bodyScope = GPUScope()
        let globalScope = GPUScope()
        let scaledTexel = GPUVariable<GLSLVec2>(name: "scaledTexel")
        let mainFunction = MainGPUFunction(scope: bodyScope)
        
        globalScope ⥤ aPosition
        globalScope ⥤ aTexel
        globalScope ⥤ aNormal
        globalScope ⥥ uTextureScale
        globalScope ⥥ uLighDirection
        globalScope ⥥ uLighHalfVector
        globalScope ⥥ uNormalMatrix
        globalScope ⥥ uModelViewProjectionMatrix
        globalScope ⥥ uShininess
        globalScope ⥥ uLightColor
        globalScope ⟿↘ vLighDirection
        globalScope ⟿↘ vLighHalfVector
        globalScope ⟿↘ vNormal
        globalScope ⟿↘ vTexel
        globalScope ⟿↘ vShininess
        globalScope ⟿↘ vLightColor
        globalScope ↳ mainFunction
        
        bodyScope ↳ scaledTexel
        bodyScope ✍ scaledTexel ⬅ aTexel * uTextureScale
        bodyScope ✍ vTexel ⬅ scaledTexel
        bodyScope ✍ vShininess ⬅ uShininess
        bodyScope ✍ vLightColor ⬅ uLightColor
        bodyScope ✍ vLighDirection ⬅ uLighDirection * (GPUVariable<GLSLFloat>(value: -1.0))
        bodyScope ✍ vLighHalfVector ⬅ uLighHalfVector
        bodyScope ✍ vNormal ⬅ uNormalMatrix * aNormal
        bodyScope ✍ vNormal ⬅ ^vNormal
        bodyScope ✍ glPosition ⬅ uModelViewProjectionMatrix * aPosition
        
        return globalScope
    }
}