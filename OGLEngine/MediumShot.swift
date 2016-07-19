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
            uShininess: uniforms.get(GPUUniforms.shininess),
            uLightColor: uniforms.get(GPUUniforms.lightColor))
        
        return GPUVertexShader(name: "MediumShot", attributes: attributes, uniforms: uniforms, interpolation: interpolation, function: MainGPUFunction(scope: scope))
    }
}

struct MediumShotInterpolation: GPUInterpolation {
    let vTexel = Variable<GLSLVec2>(name: "vTexel")
    let vLighDirection = Variable<GLSLVec3>(name: "vLighDirection")
    let vLighHalfVector = Variable<GLSLVec3>(name: "vLighHalfVector")
    let vNormal = Variable<GLSLVec3>(name: "vNormal")
    let vLightColor = Variable<GLSLColor>(name: "vLightColor")
    let vShininess = Variable<GLSLFloat>(name: "vShininess")
    
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
        uColorMap: Variable<GLSLTexture>,
        vTexel: Variable<GLSLVec2>,
        vLighDirection: Variable<GLSLVec3>,
        vLighHalfVector: Variable<GLSLVec3>,
        vNormal: Variable<GLSLVec3>,
        vLightColor: Variable<GLSLColor>,
        vShininess: Variable<GLSLFloat>
        ) -> GPUScope {
        
        let globalScope = GPUScope()
        let bodyScope = GPUScope()
        let mainFunction = MainGPUFunction(scope: bodyScope)
        let normalizedNormal = Variable<GLSLVec3>(name: "normalizedNormal")
        let colorFromMap = Variable<GLSLColor>(name: "colorFromMap")
        
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
        glPosition: Variable<GLSLVec4>,
        
        aPosition: Variable<GLSLVec3>,
        aTexel: Variable<GLSLVec2>,
        aNormal: Variable<GLSLVec3>,
        
        vTexel: Variable<GLSLVec2>,
        vLighDirection: Variable<GLSLVec3>,
        vLighHalfVector: Variable<GLSLVec3>,
        vNormal: Variable<GLSLVec3>,
        vShininess: Variable<GLSLFloat>,
        vLightColor: Variable<GLSLColor>,
        
        uLighDirection: Variable<GLSLVec3>,
        uLighHalfVector: Variable<GLSLVec3>,
        uNormalMatrix: Variable<GLSLMat3>,
        uModelViewProjectionMatrix: Variable<GLSLMat4>,
        uShininess: Variable<GLSLFloat>,
        uLightColor: Variable<GLSLColor>
        ) -> GPUScope {
        let bodyScope = GPUScope()
        let globalScope = GPUScope()
        let scaledTexel = Variable<GLSLVec2>(name: "scaledTexel")
        let mainFunction = MainGPUFunction(scope: bodyScope)
        
        globalScope ⥤ aPosition
        globalScope ⥤ aTexel
        globalScope ⥤ aNormal
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
        bodyScope ✍ scaledTexel ⬅ aTexel
        bodyScope ✍ vTexel ⬅ scaledTexel
        bodyScope ✍ vShininess ⬅ uShininess
        bodyScope ✍ vLightColor ⬅ uLightColor
        bodyScope ✍ vLighDirection ⬅ uLighDirection * (Primitive<GLSLFloat>(value: -1.0))
        bodyScope ✍ vLighHalfVector ⬅ uLighHalfVector
        bodyScope ✍ vNormal ⬅ uNormalMatrix * aNormal
        bodyScope ✍ vNormal ⬅ ^vNormal
        bodyScope ✍ glPosition ⬅ uModelViewProjectionMatrix * aPosition
        
        return globalScope
    }
}