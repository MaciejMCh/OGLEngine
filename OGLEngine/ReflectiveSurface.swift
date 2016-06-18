//
//  ReflectiveSurface.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 13.06.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

extension DefaultPipelines {
    static func ReflectiveSurface() -> GPUPipeline {
        let attributes = GPUVariableCollection<AnyGPUAttribute>(collection: [
            GPUAttributes.position,
            GPUAttributes.texel
            ])
        let uniforms = GPUVariableCollection<AnyGPUUniform>(collection: [
            GPUUniform(variable: GPUUniforms.modelViewProjectionMatrix),
            GPUUniform(variable: GPUUniforms.reflectionColorMap)
            ])
        let interpolation = ReflectiveSurfaceInterpolation()
        let vertexShader = DefaultVertexShaders.ReflectiveSurface(attributes, uniforms: uniforms, interpolation: interpolation)
        let fragmentShader = DefaultFragmentShaders.ReflectiveSurface(uniforms, interpolation: interpolation)
        return GPUPipeline(
            vertexShader: vertexShader,
            fragmentShader: fragmentShader)
    }
}

extension DefaultFragmentShaders {
    static func ReflectiveSurface(uniforms: GPUVariableCollection<AnyGPUUniform>, interpolation: ReflectiveSurfaceInterpolation) -> GPUFragmentShader {
        return GPUFragmentShader(
            name: "ReflectiveSurface",
            uniforms: uniforms,
            interpolation: interpolation,
            function: MainGPUFunction(scope: DefaultScopes.ReflectiveSurfaceFragment(
                OpenGLDefaultVariables.glFragColor(),
                uReflectionColorMap: uniforms.get(GPUUniforms.reflectionColorMap),
                vClipSpace: interpolation.vClipSpace)))
    }
}

extension DefaultVertexShaders {
    static func ReflectiveSurface(attributes: GPUVariableCollection<AnyGPUAttribute>,
                                  uniforms: GPUVariableCollection<AnyGPUUniform>,
                                  interpolation: ReflectiveSurfaceInterpolation) -> GPUVertexShader {
        return GPUVertexShader(
            name: "ReflectiveSurface",
            attributes: attributes,
            uniforms: uniforms,
            interpolation: interpolation,
            function: MainGPUFunction(scope: DefaultScopes.ReflectiveSurfaceVertex(
                OpenGLDefaultVariables.glPosition(),
                aPosition: attributes.get(GPUAttributes.position),
                aTexel: attributes.get(GPUAttributes.texel),
                uModelViewProjectionMatrix: uniforms.get(GPUUniforms.modelViewProjectionMatrix),
                vClipSpace: interpolation.vClipSpace)))
    }
}

struct ReflectiveSurfaceInterpolation: GPUInterpolation {
    let vClipSpace: GPUVariable<GLSLVec4> = GPUVariable<GLSLVec4>(name: "vClipSpace")
    
    func varyings() -> [GPUVarying] {
        return [
            GPUVarying(variable: vClipSpace, precision: .Low)
        ]
    }
}

extension DefaultScopes {
    static func ReflectiveSurfaceVertex(
        glPosition: GPUVariable<GLSLVec4>,
        aPosition: GPUVariable<GLSLVec3>,
        aTexel: GPUVariable<GLSLVec2>,
        uModelViewProjectionMatrix: GPUVariable<GLSLMat4>,
        vClipSpace: GPUVariable<GLSLVec4>
    ) -> GPUScope {
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        
        globalScope ⥤ aPosition
        globalScope ⥤ aTexel
        globalScope ⥥ uModelViewProjectionMatrix
        globalScope ⟿↘ vClipSpace
        globalScope ↳ MainGPUFunction(scope: mainScope)
        
        mainScope ✍ vClipSpace ⬅ uModelViewProjectionMatrix * aPosition
        mainScope ✍ glPosition ⬅ vClipSpace
        
        return globalScope
    }
    
    static func ReflectiveSurfaceFragment(
        glFragColor: GPUVariable<GLSLColor>,
        uReflectionColorMap: GPUVariable<GLSLTexture>,
        vClipSpace: GPUVariable<GLSLVec4>
        ) -> GPUScope {
        
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        let ndc = GPUVariable<GLSLVec2>(name: "ndc")
        let reflectionColor = GPUVariable<GLSLColor>(name: "reflectionColor")
        let surfaceColor = GPUVariable<GLSLColor>(name: "surfaceColor")
        
        
        globalScope ⥥ uReflectionColorMap
        globalScope ⟿↘ vClipSpace
        globalScope ↳ MainGPUFunction(scope: mainScope)
        
        mainScope ↳↘ ndc
        mainScope ✍ ndc ⬅ FixedGPUEvaluation(glslCode: "(\(vClipSpace.name!).xy / \(vClipSpace.name!).w) / 2.0 + 0.5")
        mainScope ↳↘ reflectionColor
        mainScope ✍ reflectionColor ⬅ FixedGPUEvaluation(glslCode: "texture2D(\(uReflectionColorMap.name!), vec2(\(ndc.name!).x, 1.0 - \(ndc.name!).y))")
        mainScope ↳↘ surfaceColor
        mainScope ✍ surfaceColor ⬅ GPUVariable<GLSLColor>(value: (r: 0.0, g: 0.1, b: 0.1, a: 1.0))
        mainScope ✍ glFragColor ⬅ reflectionColor ✖ surfaceColor
        
        return globalScope
    }
    
}