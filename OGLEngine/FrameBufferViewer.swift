//
//  FrameBufferViewer.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 06.07.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

extension DefaultPipelines {
    static func FrameBufferViewer() -> GPUPipeline {
        let attributes = GPUVariableCollection<AnyGPUAttribute>(collection: [
            GPUAttributes.position,
            GPUAttributes.texel
            ])
        let uniforms = GPUVariableCollection<AnyGPUUniform>(collection: [
            GPUUniform(variable: GPUUniforms.colorMap)
            ])
        let interpolation = FrameBufferViewerInterpolation()
        return GPUPipeline(
            vertexShader: DefaultVertexShaders.FrameBufferViewer(attributes, uniforms: uniforms, interpolation: interpolation),
            fragmentShader: DefaultFragmentShaders.FrameBufferViewer(uniforms, interpolation: interpolation))
    }
}

extension DefaultFragmentShaders {
    static func FrameBufferViewer(uniforms: GPUVariableCollection<AnyGPUUniform>,
                                  interpolation: FrameBufferViewerInterpolation) -> GPUFragmentShader {
        return GPUFragmentShader(
            name: "FrameBufferViewer",
            uniforms: uniforms,
            interpolation: interpolation,
            function: MainGPUFunction(scope: DefaultScopes.FrameBufferViewerFragment(
                glFragColor: OpenGLDefaultVariables.glFragColor(),
                vTexel: interpolation.vTexel,
                uColorMap: uniforms.get(GPUUniforms.colorMap))))
    }
}

extension DefaultVertexShaders {
    static func FrameBufferViewer(attributes: GPUVariableCollection<AnyGPUAttribute>,
                                  uniforms: GPUVariableCollection<AnyGPUUniform>,
                                  interpolation: FrameBufferViewerInterpolation) -> GPUVertexShader {
        return GPUVertexShader(
            name: "FrameBufferViewer",
            attributes: attributes,
            uniforms: uniforms,
            interpolation: interpolation,
            function: MainGPUFunction(scope: DefaultScopes.FrameBufferViewerVertex(
                glPosition: OpenGLDefaultVariables.glPosition(),
                aPosition: attributes.get(GPUAttributes.position),
                aTexel: attributes.get(GPUAttributes.texel),
                vTexel: interpolation.vTexel)))
    }
}

struct FrameBufferViewerInterpolation: GPUInterpolation {
    let vTexel: GPUVariable<GLSLVec2> = GPUVariable<GLSLVec2>(name: "vTexel")
    
    func varyings() -> [GPUVarying] {
        return [GPUVarying(variable: vTexel, precision: .Low)]
    }
}

extension DefaultScopes {
    static func FrameBufferViewerVertex(
        glPosition glPosition: GPUVariable<GLSLVec4>,
                   aPosition: GPUVariable<GLSLVec3>,
                   aTexel: GPUVariable<GLSLVec2>,
                   vTexel: GPUVariable<GLSLVec2>
                   ) -> GPUScope {
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        
        globalScope ⥤ aPosition
        globalScope ⥤ aTexel
        globalScope ⟿↘ vTexel
        globalScope ↳ MainGPUFunction(scope: mainScope)
        
        mainScope ✍ vTexel ⬅ aTexel
        mainScope ✍ glPosition ⬅ aPosition
        
        return globalScope
    }
    
    static func FrameBufferViewerFragment(
        glFragColor glFragColor: GPUVariable<GLSLColor>,
                    vTexel: GPUVariable<GLSLVec2>,
                    uColorMap: GPUVariable<GLSLTexture>) -> GPUScope {
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        
        globalScope ⟿↘ vTexel
        globalScope ⥥ uColorMap
        globalScope ↳ MainGPUFunction(scope: mainScope)
        
        mainScope ✍ glFragColor ⬅ uColorMap ☒ vTexel
        
        return globalScope
    }
}