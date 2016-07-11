//
//  RayBox.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 08.07.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

extension DefaultPipelines {
    static func RayBox() -> GPUPipeline {
        let attributes = GPUVariableCollection<AnyGPUAttribute>(collection: [
            GPUAttributes.position,
            GPUAttributes.texel,
            GPUAttributes.normal
            ])
        let uniforms = GPUVariableCollection<AnyGPUUniform>(collection: [
            GPUUniform(variable: GPUUniforms.modelViewProjectionMatrix),
            GPUUniform(variable: GPUUniforms.colorMap)
            ])
        let interpolation = ReflectedInterpolation()
        let vertexShader = DefaultVertexShaders.Reflected(attributes: attributes, uniforms: uniforms, interpolation: interpolation)
        let fragmentShader = DefaultFragmentShaders.Reflected(uniforms, interpolation: interpolation)
        return GPUPipeline(vertexShader: vertexShader, fragmentShader: fragmentShader)
    }
}

extension DefaultFragmentShaders {
    static func RayBox(uniforms: GPUVariableCollection<AnyGPUUniform>, interpolation: RayBoxInterpolation) -> GPUFragmentShader {
        return GPUFragmentShader(
            name: "RayBox",
            uniforms: uniforms,
            interpolation: interpolation,
            function: MainGPUFunction(scope: DefaultScopes.RayBoxFragment(
                glFragColor: OpenGLDefaultVariables.glFragColor(),
                uColorMap: uniforms.get(GPUUniforms.colorMap),
                vTexel: interpolation.vTexel)))
    }
}

extension DefaultVertexShaders {
    static func Reflected(
        attributes attributes: GPUVariableCollection<AnyGPUAttribute>,
                   uniforms: GPUVariableCollection<AnyGPUUniform>,
                   interpolation: RayBoxInterpolation) -> GPUVertexShader {
        return GPUVertexShader(
            name: "RayBox",
            attributes: attributes,
            uniforms: uniforms,
            interpolation: interpolation,
            function: MainGPUFunction(scope: DefaultScopes.RayBoxVertex(
                glPosition: OpenGLDefaultVariables.glPosition(),
                aPosition: attributes.get(GPUAttributes.position),
                aTexel: attributes.get(GPUAttributes.texel),
                aNormal: attributes.get(GPUAttributes.normal),
                uModelViewProjectionMatrix: uniforms.get(GPUUniforms.modelViewProjectionMatrix),
                vTexel: interpolation.vTexel)))
    }
}

struct RayBoxInterpolation: GPUInterpolation {
    let vTexel: GPUVariable<GLSLVec2> = GPUVariable<GLSLVec2>(name: "vTexel")
    
    func varyings() -> [GPUVarying] {
        return [
            GPUVarying(variable: vTexel, precision: .Low)
        ]
    }
}

extension DefaultScopes {
    static func RayBoxVertex(
        glPosition glPosition: GPUVariable<GLSLVec4>,
                   aPosition: GPUVariable<GLSLVec3>,
                   aTexel: GPUVariable<GLSLVec2>,
                   aNormal: GPUVariable<GLSLVec3>,
                   uModelViewProjectionMatrix: GPUVariable<GLSLMat4>,
                   vTexel: GPUVariable<GLSLVec2>
        ) -> GPUScope {
        
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        
        globalScope ⥤ aPosition
        globalScope ⥤ aTexel
        globalScope ⥤ aNormal
        globalScope ⥥ uModelViewProjectionMatrix
        globalScope ⟿↘ vTexel
        globalScope ↳ MainGPUFunction(scope: mainScope)
        
        mainScope ✍ vTexel ⬅ aTexel
        mainScope ✍ glPosition ⬅ uModelViewProjectionMatrix * aPosition
        
        return globalScope
    }
    
    static func RayBoxFragment(
        glFragColor glFragColor: GPUVariable<GLSLColor>,
                    uColorMap: GPUVariable<GLSLTexture>,
                    vTexel: GPUVariable<GLSLVec2>
        ) -> GPUScope {
        
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        
        globalScope ⥥ uColorMap
        globalScope ⟿↘ vTexel
        globalScope ↳ MainGPUFunction(scope: mainScope)
        
        mainScope ✍ glFragColor ⬅ uColorMap ☒ vTexel
        
        return globalScope
    }
    
}
