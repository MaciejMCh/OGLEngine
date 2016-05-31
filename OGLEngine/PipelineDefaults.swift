//
//  PipelineDefaults.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 22.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

public struct OpenGLDefaultVariables {
    static func glPosition() -> GPUVariable<GLSLVec4> {
        return GPUVariable<GLSLVec4>(name: "gl_Position")
    }
    
    static func glFragColor() -> GPUVariable<GLSLColor> {
        return GPUVariable<GLSLColor>(name: "gl_FragColor")
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

public struct DefaultScopes {
    
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
        
        aPosition: GPUVariable<GLSLVec4>,
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
    
    static func PhongFactorsScope(
        normalVector: GPUVariable<GLSLVec3>,
        lightVector: GPUVariable<GLSLVec3>,
        halfVector: GPUVariable<GLSLVec3>,
        ndl: GPUVariable<GLSLFloat>,
        ndh: GPUVariable<GLSLFloat>
        ) -> GPUScope {
        let scope = GPUScope()
        
        scope ✍ ndl ⬅ normalVector ⋅ lightVector
        scope ✍ ndh ⬅ normalVector ⋅ halfVector
        
        return scope
    }
    
    static func PhongReflectionColorScope(
        normalVector: GPUVariable<GLSLVec3> = GPUVariable<GLSLVec3>(name: "normalVector"),
        lightVector: GPUVariable<GLSLVec3> = GPUVariable<GLSLVec3>(name: "lightVector"),
        halfVector: GPUVariable<GLSLVec3> = GPUVariable<GLSLVec3>(name: "halfVector"),
        fullDiffuseColor: GPUVariable<GLSLColor> = GPUVariable<GLSLColor>(name: "fullDiffuseColor"),
        lightColor: GPUVariable<GLSLColor> = GPUVariable<GLSLColor>(name: "lightColor"),
        shininess: GPUVariable<GLSLFloat> = GPUVariable<GLSLFloat>(name: "shininess"),
        phongColor: GPUVariable<GLSLColor> = GPUVariable<GLSLColor>(name: "phongColor")
        ) -> GPUScope {
        
        let scope = GPUScope()
        let ndl = GPUVariable<GLSLFloat>(name: "ndl")
        let ndh = GPUVariable<GLSLFloat>(name: "ndh")
        let reflectionPower = GPUVariable<GLSLFloat>(name: "reflectionPower")
        let phongFactorsScope = DefaultScopes.PhongFactorsScope(normalVector, lightVector: lightVector, halfVector: halfVector, ndl: ndl, ndh: ndh)
        let diffuseColor = GPUVariable<GLSLColor>(name: "diffuseColor")
        let specularColor = GPUVariable<GLSLColor>(name: "specularColor")
        
        scope ↳↘ ndl
        scope ↳↘ ndh
        scope ↳↘ reflectionPower
        scope ↳↘ diffuseColor
        scope ↳↘ specularColor
        scope ⎘ phongFactorsScope
        scope ✍ diffuseColor ⬅ fullDiffuseColor * ndl
        scope ✍ reflectionPower ⬅ (ndh ^ shininess)
        scope ✍ specularColor ⬅ lightColor * reflectionPower
        scope ✍ phongColor ⬅ diffuseColor ✖ specularColor
        
        return scope
    }
    
}

struct EnumCollection<T> {
    private(set) var collection: [T]
}

extension EnumCollection where T: GLSLEnum {
    func get(element: T) -> T! {
        for iteratingElement in self.collection {
            if (iteratingElement.gpuDomainName() == element.gpuDomainName()) {
                return element
            }
        }
        return nil
    }
    mutating func exclude(elementsToExclude: [T]) {
        self.collection = self.collection.filter{!elementsToExclude.map{$0.gpuDomainName()}.contains($0.gpuDomainName())}
    }
}

extension GPUVariable {
    convenience init(glslEnum: GLSLEnum) {
        self.init(name: glslEnum.gpuDomainName())
    }
    
    convenience init(glslRepresentable: GPURepresentable) {
        self.init(name: glslRepresentable.glslName)
    }
}

struct DefaultVertexShaders {
    static func MediumShot(attributes: GPUVariableCollection<GPUAttribute>,
                           uniforms: GPUVariableCollection<AnyGPUUniform>,
                           interpolation: MediumShotInterpolation) -> GPUVertexShader {
        
        let scope = DefaultScopes.MediumShotVertex(
            OpenGLDefaultVariables.glPosition(),
            aPosition: GPUVariable<GLSLVec4>(glslRepresentable: attributes.get(GPUAttributes.position)),
            aTexel: GPUVariable<GLSLVec2>(glslRepresentable: attributes.get(GPUAttributes.texel)),
            aNormal: GPUVariable<GLSLVec3>(glslRepresentable: attributes.get(GPUAttributes.normal)),
            vTexel: interpolation.vTexel,
            vLighDirection: interpolation.vLighDirection,
            vLighHalfVector: interpolation.vLighHalfVector,
            vNormal: interpolation.vNormal,
            vShininess: interpolation.vShininess,
            vLightColor: interpolation.vLightColor,
            uLighDirection: GPUVariable<GLSLVec3>(glslRepresentable: uniforms.get(GPUUniforms.lightDirection)),
            uLighHalfVector: GPUVariable<GLSLVec3>(glslRepresentable: uniforms.get(GPUUniforms.lightHalfVector)),
            uNormalMatrix: GPUVariable<GLSLMat3>(glslRepresentable: uniforms.get(GPUUniforms.normalMatrix)),
            uModelViewProjectionMatrix: GPUVariable<GLSLMat4>(glslRepresentable: uniforms.get(GPUUniforms.modelViewProjectionMatrix)),
            uTextureScale: GPUVariable<GLSLFloat>(glslRepresentable: uniforms.get(GPUUniforms.textureScale)),
            uShininess: GPUVariable<GLSLFloat>(glslRepresentable: uniforms.get(GPUUniforms.shininess)),
            uLightColor: GPUVariable<GLSLColor>(glslRepresentable: uniforms.get(GPUUniforms.lightColor)))
        
        return GPUVertexShader(name: "MediumShot", attributes: attributes, uniforms: uniforms, interpolation: interpolation, function: MainGPUFunction(scope: scope))
    }
}

struct DefaultFragmentShaders {
    static func MediumShot(uniforms: GPUVariableCollection<AnyGPUUniform>, interpolation: MediumShotInterpolation) -> GPUFragmentShader {
        return GPUFragmentShader(name: "MediumShot",
                              uniforms: uniforms,
                              interpolation: interpolation,
                              function: MainGPUFunction(scope: DefaultScopes.MediumShotFragment(
                                uniforms.get(GPUUniforms.colorMap).variable as! GPUVariable<GLSLTexture>,
                                vTexel: interpolation.vTexel,
                                vLighDirection: interpolation.vLighDirection,
                                vLighHalfVector: interpolation.vLighHalfVector,
                                vNormal: interpolation.vNormal,
                                vLightColor: interpolation.vLightColor,
                                vShininess: interpolation.vShininess)))
    }
}
public struct DefaultPipelines {
    static func MediumShot() -> GPUPipeline {
        
        let attributes = GPUVariableCollection<GPUAttribute>(collection: [
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
