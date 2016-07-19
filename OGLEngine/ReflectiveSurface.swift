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
    let vClipSpace: Variable<GLSLVec4> = Variable<GLSLVec4>(name: "vClipSpace")
    
    func varyings() -> [GPUVarying] {
        return [
            GPUVarying(variable: vClipSpace, precision: .Low)
        ]
    }
}

extension DefaultScopes {
    static func ReflectiveSurfaceVertex(
        glPosition: Variable<GLSLVec4>,
        aPosition: Variable<GLSLVec3>,
        aTexel: Variable<GLSLVec2>,
        uModelViewProjectionMatrix: Variable<GLSLMat4>,
        vClipSpace: Variable<GLSLVec4>
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
        glFragColor: Variable<GLSLColor>,
        uReflectionColorMap: Variable<GLSLTexture>,
        vClipSpace: Variable<GLSLVec4>
        ) -> GPUScope {
        
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        let ndc = Variable<GLSLVec2>(name: "ndc")
        let reflectionColor = Variable<GLSLColor>(name: "reflectionColor")
        let surfaceColor = Variable<GLSLColor>(name: "surfaceColor")
        
        
        globalScope ⥥ uReflectionColorMap
        globalScope ⟿↘ vClipSpace
        globalScope ↳ MainGPUFunction(scope: mainScope)
        
        mainScope ↳↘ ndc
        mainScope ✍ ndc ⬅ FixedEvaluation(code: "(\(vClipSpace.name).xy / \(vClipSpace.name).w) / 2.0 + 0.5")
        mainScope ↳↘ reflectionColor
        mainScope ✍ reflectionColor ⬅ FixedEvaluation(code: "texture2D(\(uReflectionColorMap.name), vec2(\(ndc.name).x, 1.0 - \(ndc.name).y))")
        mainScope ↳↘ surfaceColor
        mainScope ✍ surfaceColor ⬅ Primitive<GLSLColor>(value: (r: 0.0, g: 0.1, b: 0.1, a: 1.0))
        mainScope ✍ glFragColor ⬅ reflectionColor ✖ surfaceColor
        
        return globalScope
    }
    
}