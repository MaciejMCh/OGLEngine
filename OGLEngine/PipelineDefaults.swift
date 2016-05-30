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
    static func glPosition() -> TypedGPUVariable<GLSLVec4> {
        return TypedGPUVariable<GLSLVec4>(name: "gl_Position")
    }
    
    static func glFragColor() -> TypedGPUVariable<GLSLColor> {
        return TypedGPUVariable<GLSLColor>(name: "gl_FragColor")
    }
}

struct MediumShotInterpolation: Interpolation {
    let vTexel = TypedGPUVariable<GLSLVec2>(name: "vTexel")
    let vLighDirection = TypedGPUVariable<GLSLVec3>(name: "vLighDirection")
    let vLighHalfVector = TypedGPUVariable<GLSLVec3>(name: "vLighHalfVector")
    let vNormal = TypedGPUVariable<GLSLVec3>(name: "vNormal")
    let vLightColor = TypedGPUVariable<GLSLColor>(name: "vLightColor")
    let vShininess = TypedGPUVariable<GLSLFloat>(name: "vShininess")
    
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
        uColorMap: TypedGPUVariable<GLSLTexture>,
        vTexel: TypedGPUVariable<GLSLVec2>,
        vLighDirection: TypedGPUVariable<GLSLVec3>,
        vLighHalfVector: TypedGPUVariable<GLSLVec3>,
        vNormal: TypedGPUVariable<GLSLVec3>,
        vLightColor: TypedGPUVariable<GLSLColor>,
        vShininess: TypedGPUVariable<GLSLFloat>
        ) -> GPUScope {
        
        let bodyScope = GPUScope()
        let declarationsScope = GPUScope()
        let normalizedNormal = TypedGPUVariable<GLSLVec3>(name: "normalizedNormal")
        let colorFromMap = TypedGPUVariable<GLSLColor>(name: "colorFromMap")
        
        declarationsScope ⥥ uColorMap
        declarationsScope ⟿↘ vTexel
        declarationsScope ⟿↘ vNormal
        declarationsScope ⟿↘ vLighDirection
        declarationsScope ⟿↘ vLighHalfVector
        declarationsScope ⟿↘ vShininess
        declarationsScope ⟿↘ vLightColor
        declarationsScope ✍ GPUFunctionBody(function: ShaderFunction(scope: bodyScope), childScope: bodyScope)
        
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
        
        return declarationsScope
    }
    
    static func MediumShotVertex(
        glPosition: TypedGPUVariable<GLSLVec4>,
        
        aPosition: TypedGPUVariable<GLSLVec4>,
        aTexel: TypedGPUVariable<GLSLVec2>,
        aNormal: TypedGPUVariable<GLSLVec3>,
        
        vTexel: TypedGPUVariable<GLSLVec2>,
        vLighDirection: TypedGPUVariable<GLSLVec3>,
        vLighHalfVector: TypedGPUVariable<GLSLVec3>,
        vNormal: TypedGPUVariable<GLSLVec3>,
        vShininess: TypedGPUVariable<GLSLFloat>,
        vLightColor: TypedGPUVariable<GLSLColor>,
        
        uLighDirection: TypedGPUVariable<GLSLVec3>,
        uLighHalfVector: TypedGPUVariable<GLSLVec3>,
        uNormalMatrix: TypedGPUVariable<GLSLMat3>,
        uModelViewProjectionMatrix: TypedGPUVariable<GLSLMat4>,
        uTextureScale: TypedGPUVariable<GLSLFloat>,
        uShininess: TypedGPUVariable<GLSLFloat>,
        uLightColor: TypedGPUVariable<GLSLColor>
        ) -> GPUScope {
        let bodyScope = GPUScope()
        let declarationsScope = GPUScope()
        let scaledTexel = TypedGPUVariable<GLSLVec2>(name: "scaledTexel")
        
        declarationsScope ⥤ aPosition
        declarationsScope ⥤ aTexel
        declarationsScope ⥤ aNormal
        declarationsScope ⥥ uTextureScale
        declarationsScope ⥥ uLighDirection
        declarationsScope ⥥ uLighHalfVector
        declarationsScope ⥥ uNormalMatrix
        declarationsScope ⥥ uModelViewProjectionMatrix
        declarationsScope ⥥ uShininess
        declarationsScope ⥥ uLightColor
        declarationsScope ⟿↘ vLighDirection
        declarationsScope ⟿↘ vLighHalfVector
        declarationsScope ⟿↘ vNormal
        declarationsScope ⟿↘ vTexel
        declarationsScope ⟿↘ vShininess
        declarationsScope ⟿↘ vLightColor
        declarationsScope ✍ GPUFunctionBody(function: ShaderFunction(scope: bodyScope), childScope: bodyScope)
        
        bodyScope ↳ scaledTexel
        bodyScope ✍ scaledTexel ⬅ aTexel * uTextureScale
        bodyScope ✍ vTexel ⬅ scaledTexel
        bodyScope ✍ vShininess ⬅ uShininess
        bodyScope ✍ vLightColor ⬅ uLightColor
        bodyScope ✍ vLighDirection ⬅ uLighDirection * (TypedGPUVariable<GLSLFloat>(value: -1.0))
        bodyScope ✍ vLighHalfVector ⬅ uLighHalfVector
        bodyScope ✍ vNormal ⬅ uNormalMatrix * aNormal
        bodyScope ✍ vNormal ⬅ ^vNormal
        bodyScope ✍ glPosition ⬅ uModelViewProjectionMatrix * aPosition
        
        return declarationsScope
    }
    
    static func PhongFactorsScope(
        normalVector: TypedGPUVariable<GLSLVec3>,
        lightVector: TypedGPUVariable<GLSLVec3>,
        halfVector: TypedGPUVariable<GLSLVec3>,
        ndl: TypedGPUVariable<GLSLFloat>,
        ndh: TypedGPUVariable<GLSLFloat>
        ) -> GPUScope {
        let scope = GPUScope()
        
        scope ✍ ndl ⬅ normalVector ⋅ lightVector
        scope ✍ ndh ⬅ normalVector ⋅ halfVector
        
        return scope
    }
    
    static func PhongReflectionColorScope(
        normalVector: TypedGPUVariable<GLSLVec3> = TypedGPUVariable<GLSLVec3>(name: "normalVector"),
        lightVector: TypedGPUVariable<GLSLVec3> = TypedGPUVariable<GLSLVec3>(name: "lightVector"),
        halfVector: TypedGPUVariable<GLSLVec3> = TypedGPUVariable<GLSLVec3>(name: "halfVector"),
        fullDiffuseColor: TypedGPUVariable<GLSLColor> = TypedGPUVariable<GLSLColor>(name: "fullDiffuseColor"),
        lightColor: TypedGPUVariable<GLSLColor> = TypedGPUVariable<GLSLColor>(name: "lightColor"),
        shininess: TypedGPUVariable<GLSLFloat> = TypedGPUVariable<GLSLFloat>(name: "shininess"),
        phongColor: TypedGPUVariable<GLSLColor> = TypedGPUVariable<GLSLColor>(name: "phongColor")
        ) -> GPUScope {
        
        let scope = GPUScope()
        let ndl = TypedGPUVariable<GLSLFloat>(name: "ndl")
        let ndh = TypedGPUVariable<GLSLFloat>(name: "ndh")
        let reflectionPower = TypedGPUVariable<GLSLFloat>(name: "reflectionPower")
        let phongFactorsScope = DefaultScopes.PhongFactorsScope(normalVector, lightVector: lightVector, halfVector: halfVector, ndl: ndl, ndh: ndh)
        let diffuseColor = TypedGPUVariable<GLSLColor>(name: "diffuseColor")
        let specularColor = TypedGPUVariable<GLSLColor>(name: "specularColor")
        
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

extension TypedGPUVariable {
    convenience init(glslEnum: GLSLEnum) {
        self.init(name: glslEnum.gpuDomainName())
    }
    
    convenience init(glslRepresentable: GLSLRepresentable) {
        self.init(name: glslRepresentable.glslName)
    }
}

struct DefaultVertexShaders {
    static func MediumShot(attributes: GLSLVariableCollection<GPUAttribute>,
                           uniforms: GLSLVariableCollection<AnyGPUUniform>,
                           interpolation: MediumShotInterpolation) -> VertexShader {
        
        let scope = DefaultScopes.MediumShotVertex(
            OpenGLDefaultVariables.glPosition(),
            aPosition: TypedGPUVariable<GLSLVec4>(glslRepresentable: attributes.get(Attributes.position)),
            aTexel: TypedGPUVariable<GLSLVec2>(glslRepresentable: attributes.get(Attributes.texel)),
            aNormal: TypedGPUVariable<GLSLVec3>(glslRepresentable: attributes.get(Attributes.normal)),
            vTexel: interpolation.vTexel,
            vLighDirection: interpolation.vLighDirection,
            vLighHalfVector: interpolation.vLighHalfVector,
            vNormal: interpolation.vNormal,
            vShininess: interpolation.vShininess,
            vLightColor: interpolation.vLightColor,
            uLighDirection: TypedGPUVariable<GLSLVec3>(glslRepresentable: uniforms.get(Uniforms.lightDirection)),
            uLighHalfVector: TypedGPUVariable<GLSLVec3>(glslRepresentable: uniforms.get(Uniforms.lightHalfVector)),
            uNormalMatrix: TypedGPUVariable<GLSLMat3>(glslRepresentable: uniforms.get(Uniforms.normalMatrix)),
            uModelViewProjectionMatrix: TypedGPUVariable<GLSLMat4>(glslRepresentable: uniforms.get(Uniforms.modelViewProjectionMatrix)),
            uTextureScale: TypedGPUVariable<GLSLFloat>(glslRepresentable: uniforms.get(Uniforms.textureScale)),
            uShininess: TypedGPUVariable<GLSLFloat>(glslRepresentable: uniforms.get(Uniforms.shininess)),
            uLightColor: TypedGPUVariable<GLSLColor>(glslRepresentable: uniforms.get(Uniforms.lightColor)))
        
        return VertexShader(name: "MediumShot", attributes: attributes, uniforms: uniforms, interpolation: interpolation, function: ShaderFunction(scope: scope))
    }
}

struct DefaultFragmentShaders {
    static func MediumShot(uniforms: GLSLVariableCollection<AnyGPUUniform>, interpolation: MediumShotInterpolation) -> FragmentShader {
        return FragmentShader(name: "MediumShot",
                              uniforms: uniforms,
                              interpolation: interpolation,
                              function: ShaderFunction(scope: DefaultScopes.MediumShotFragment(
                                uniforms.get(Uniforms.colorMap).variable as! TypedGPUVariable<GLSLTexture>,
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
        
        let attributes = GLSLVariableCollection<GPUAttribute>(collection: [
            Attributes.position,
            Attributes.texel,
            Attributes.normal
            ])
        let uniforms = GLSLVariableCollection<AnyGPUUniform>(collection: [
            GPUUniform(variable: Uniforms.lightDirection),
            GPUUniform(variable: Uniforms.lightHalfVector),
            GPUUniform(variable: Uniforms.normalMatrix),
            GPUUniform(variable: Uniforms.modelViewProjectionMatrix),
            GPUUniform(variable: Uniforms.textureScale),
            GPUUniform(variable: Uniforms.shininess),
            GPUUniform(variable: Uniforms.lightColor),
            GPUUniform(variable: Uniforms.colorMap)
            ])
        let interpolation = MediumShotInterpolation()
        
        let vertexShader = DefaultVertexShaders.MediumShot(attributes, uniforms: uniforms, interpolation: interpolation)
        let fragmentShader = DefaultFragmentShaders.MediumShot(uniforms, interpolation: interpolation)
        return GPUPipeline(vertexShader: vertexShader, fragmentShader: fragmentShader)
    }
}
