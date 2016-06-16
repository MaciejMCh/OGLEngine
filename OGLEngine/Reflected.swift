//
//  Reflected.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 16.06.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

extension DefaultPipelines {
    static func Reflected() -> GPUPipeline {
        let attributes = GPUVariableCollection<AnyGPUAttribute>(collection: [
            GPUAttributes.position,
            GPUAttributes.texel,
            GPUAttributes.normal
            ])
        let uniforms = GPUVariableCollection<AnyGPUUniform>(collection: [
            GPUUniform(variable: GPUUniforms.planeSpaceModelMatrix),
            GPUUniform(variable: GPUUniforms.planeSpaceViewProjectionMatrix),
            GPUUniform(variable: GPUUniforms.textureScale),
            GPUUniform(variable: GPUUniforms.colorMap)
            ])
        let interpolation = ReflectedInterpolation()
        let vertexShader = DefaultVertexShaders.Reflected(attributes: attributes, uniforms: uniforms, interpolation: interpolation)
        let fragmentShader = DefaultFragmentShaders.Reflected(uniforms, interpolation: interpolation)
        return GPUPipeline(vertexShader: vertexShader, fragmentShader: fragmentShader)
    }
}

extension DefaultFragmentShaders {
    static func Reflected(uniforms: GPUVariableCollection<AnyGPUUniform>, interpolation: ReflectedInterpolation) -> GPUFragmentShader {
        return GPUFragmentShader(
            name: "Reflected",
            uniforms: uniforms,
            interpolation: interpolation,
            function: MainGPUFunction(scope: DefaultScopes.ReflectedFragment(
                glFragColor: OpenGLDefaultVariables.glFragColor(),
                uColorMap: uniforms.get(GPUUniforms.colorMap),
                vTexel: interpolation.vTexel,
                vPlaneDistance: interpolation.vPlaneDistance)))
    }
}

extension DefaultVertexShaders {
    static func Reflected(
        attributes attributes: GPUVariableCollection<AnyGPUAttribute>,
        uniforms: GPUVariableCollection<AnyGPUUniform>,
        interpolation: ReflectedInterpolation) -> GPUVertexShader {
        return GPUVertexShader(
            name: "Reflected",
            attributes: attributes,
            uniforms: uniforms,
            interpolation: interpolation,
            function: MainGPUFunction(scope: DefaultScopes.ReflectedVertex(
                glPosition: OpenGLDefaultVariables.glPosition(),
                aPosition: attributes.get(GPUAttributes.position),
                aTexel: attributes.get(GPUAttributes.texel),
                aNormal: attributes.get(GPUAttributes.normal),
                uPlaneSpaceModelMatrix: uniforms.get(GPUUniforms.planeSpaceModelMatrix),
                uPlaneSpaceViewProjectionMatrix: uniforms.get(GPUUniforms.planeSpaceViewProjectionMatrix),
                uTextureScale: uniforms.get(GPUUniforms.textureScale),
                vTexel: interpolation.vTexel,
                vPlaneDistance: interpolation.vPlaneDistance)))
    }
}

struct ReflectedInterpolation: GPUInterpolation {
    let vTexel: GPUVariable<GLSLVec2> = GPUVariable<GLSLVec2>(name: "vTexel")
    let vPlaneDistance: GPUVariable<GLSLFloat> = GPUVariable<GLSLFloat>(name: "vPlaneDistance")
    
    func varyings() -> [GPUVarying] {
        return [
            GPUVarying(variable: vTexel, precision: .Low),
            GPUVarying(variable: vPlaneDistance, precision: .Low)
        ]
    }
}

extension DefaultScopes {
    static func ReflectedVertex(
        glPosition glPosition: GPUVariable<GLSLVec4>,
        aPosition: GPUVariable<GLSLVec4>,
        aTexel: GPUVariable<GLSLVec2>,
        aNormal: GPUVariable<GLSLVec3>,
        uPlaneSpaceModelMatrix: GPUVariable<GLSLMat4>,
        uPlaneSpaceViewProjectionMatrix: GPUVariable<GLSLMat4>,
        uTextureScale: GPUVariable<GLSLFloat>,
        vTexel: GPUVariable<GLSLVec2>,
        vPlaneDistance: GPUVariable<GLSLFloat>
        ) -> GPUScope {
        
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        let planeSpaceModelPosition = GPUVariable<GLSLVec4>(name: "planeSpaceModelPosition")
        
        globalScope ⥤ aPosition
        globalScope ⥤ aTexel
        globalScope ⥤ aNormal
        globalScope ⥥ uPlaneSpaceModelMatrix
        globalScope ⥥ uPlaneSpaceViewProjectionMatrix
        globalScope ⥥ uTextureScale
        globalScope ⟿↘ vTexel
        globalScope ⟿↘ vPlaneDistance
        globalScope ↳ MainGPUFunction(scope: mainScope)
        
        mainScope ✍ vTexel ⬅ aTexel * uTextureScale
        mainScope ✍ planeSpaceModelPosition ⬅ uPlaneSpaceModelMatrix * aPosition
        mainScope ✍ vPlaneDistance ⬅ FixedGPUEvaluation(glslCode: "\(planeSpaceModelPosition.name!).z")
        mainScope ✍ glPosition ⬅ uPlaneSpaceViewProjectionMatrix * planeSpaceModelPosition
        
        return globalScope
    }
    
    static func ReflectedFragment(
        glFragColor glFragColor: GPUVariable<GLSLColor>,
        uColorMap: GPUVariable<GLSLTexture>,
        vTexel: GPUVariable<GLSLVec2>,
        vPlaneDistance: GPUVariable<GLSLFloat>
        ) -> GPUScope {
        
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        
        globalScope ⥥ uColorMap
        globalScope ⟿↘ vTexel
        globalScope ⟿↘ vPlaneDistance
        globalScope ↳ MainGPUFunction(scope: mainScope)
        
        mainScope ✍ vPlaneDistance > GPUVariable<GLSLFloat>(value: 0.0)
        mainScope ✍ glFragColor ⬅ uColorMap ☒ vTexel
        
        return globalScope
    }
    
}
