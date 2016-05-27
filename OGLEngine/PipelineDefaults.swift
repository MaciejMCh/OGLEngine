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
        
        let scope = GPUScope()
        let normalizedNormal = TypedGPUVariable<GLSLVec3>(name: "normalizedNormal")
        let colorFromMap = TypedGPUVariable<GLSLColor>(name: "colorFromMap")
        let phongScope = DefaultScopes.PhongReflectionColorScope(normalizedNormal,
                                                                 lightVector: vLighDirection,
                                                                 halfVector: vLighHalfVector,
                                                                 fullDiffuseColor: colorFromMap,
                                                                 lightColor: vLightColor,
                                                                 shininess: vShininess,
                                                                 phongColor: OpenGLDefaultVariables.glFragColor())
        
        scope ✍ normalizedNormal ⬅ ^vNormal
        scope ✍ colorFromMap ⬅ uColorMap ☒ vTexel
        scope ⎘ phongScope
        
        return scope
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
        
        uLighDirection: TypedGPUVariable<GLSLVec3>,
        uLighHalfVector: TypedGPUVariable<GLSLVec3>,
        uNormalMatrix: TypedGPUVariable<GLSLMat3>,
        uModelViewProjectionMatrix: TypedGPUVariable<GLSLMat4>,
        uTextureScale: TypedGPUVariable<GLSLFloat>
        ) -> GPUScope {
        let scope = GPUScope()
        let scaledTexel = TypedGPUVariable<GLSLVec2>(name: "scaledTexel")
        
        scope ↳ scaledTexel
        scope ✍ scaledTexel ⬅ aTexel * uTextureScale
        scope ✍ vTexel ⬅ scaledTexel
        scope ✍ vLighDirection ⬅ uLighDirection
        scope ✍ vLighHalfVector ⬅ uLighHalfVector
        scope ✍ vNormal ⬅ uNormalMatrix * aNormal
        scope ✍ vNormal ⬅ ^vNormal
        scope ✍ glPosition ⬅ uModelViewProjectionMatrix * aPosition
        
        return scope
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
        
        scope ⎘ phongFactorsScope
        scope ✍ diffuseColor ⬅ fullDiffuseColor * ndl
        scope ✍ reflectionPower ⬅ (ndh ^ shininess)
        scope ✍ specularColor ⬅ lightColor * reflectionPower
        scope ✍ phongColor ⬅ diffuseColor ✖ specularColor
        
        return scope
    }
    
}

struct EnumCollection<T> {
    let collection: [T]
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
}

extension TypedGPUVariable {
    convenience init(glslEnum: GLSLEnum) {
        self.init(name: glslEnum.gpuDomainName())
    }
}

struct DefaultVertexShaders {
    static func MediumShot(attributes: EnumCollection<Attribute>,
                           uniforms: EnumCollection<Uniform>,
                           interpolation: MediumShotInterpolation) -> VertexShader {
        
        let scope = DefaultScopes.MediumShotVertex(
            OpenGLDefaultVariables.glPosition(),
            aPosition: TypedGPUVariable<GLSLVec4>(glslEnum: attributes.get(.Position)),
            aTexel: TypedGPUVariable<GLSLVec2>(glslEnum: attributes.get(.Texel)),
            aNormal: TypedGPUVariable<GLSLVec3>(glslEnum: attributes.get(.Normal)),
            vTexel: interpolation.vTexel,
            vLighDirection: interpolation.vLighDirection,
            vLighHalfVector: interpolation.vLighHalfVector,
            vNormal: interpolation.vNormal,
            uLighDirection: TypedGPUVariable<GLSLVec3>(glslEnum: uniforms.get(.LightDirection)),
            uLighHalfVector: TypedGPUVariable<GLSLVec3>(glslEnum: uniforms.get(.LightHalfVector)),
            uNormalMatrix: TypedGPUVariable<GLSLMat3>(glslEnum: uniforms.get(.NormalMatrix)),
            uModelViewProjectionMatrix: TypedGPUVariable<GLSLMat4>(glslEnum: uniforms.get(.ModelViewProjectionMatrix)),
            uTextureScale: TypedGPUVariable<GLSLFloat>(glslEnum: uniforms.get(.TextureScale)))
        
        return VertexShader(name: "MediumShot", attributes: attributes.collection, uniforms: uniforms.collection, interpolation: interpolation, function: ShaderFunction(scope: scope))
    }
}

struct DefaultFragmentShaders {
    static func MediumShot(uniforms: EnumCollection<Uniform>, interpolation: MediumShotInterpolation) -> FragmentShader {   
        return FragmentShader(name: "MediumShot",
                              uniforms: uniforms.collection,
                              interpolation: interpolation,
                              function: ShaderFunction(scope: DefaultScopes.MediumShotFragment(
                                TypedGPUVariable<GLSLTexture>(glslEnum: uniforms.get(.ColorMap)),
                                vTexel: interpolation.vTexel,
                                vLighDirection: interpolation.vLighDirection,
                                vLighHalfVector: interpolation.vLighHalfVector,
                                vNormal: interpolation.vNormal,
                                vLightColor: interpolation.vLightColor,
                                vShininess: interpolation.vShininess)))
    }
}
public struct DefaultPipelines {
    static func MediumShot(attributes: [Attribute],
                           uniforms: [Uniform],
                           interpolation: MediumShotInterpolation) -> GPUPipeline {
        let vertexShader = DefaultVertexShaders.MediumShot(EnumCollection<Attribute>(collection: attributes),
                                                           uniforms: EnumCollection<Uniform>(collection: uniforms),
                                                           interpolation: interpolation)
        let fragmentShader = DefaultFragmentShaders.MediumShot(EnumCollection<Uniform>(collection: uniforms),
                                                               interpolation: interpolation)
        return GPUPipeline(vertexShader: vertexShader,
                           fragmentShader: fragmentShader)
    }
}
