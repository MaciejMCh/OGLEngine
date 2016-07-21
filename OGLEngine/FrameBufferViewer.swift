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
        let attributes = GPUAttributesCollection(collection: [
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
    static func FrameBufferViewer(attributes: GPUAttributesCollection,
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
    let vTexel: Variable<GLSLVec2> = Variable<GLSLVec2>(name: "vTexel")
    
    func varyings() -> [GPUVarying] {
        return [GPUVarying(variable: vTexel, precision: .Low)]
    }
}

extension DefaultScopes {
    static func FrameBufferViewerVertex(
        glPosition glPosition: Variable<GLSLVec4>,
                   aPosition: Variable<GLSLVec3>,
                   aTexel: Variable<GLSLVec2>,
                   vTexel: Variable<GLSLVec2>
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
        glFragColor glFragColor: Variable<GLSLColor>,
                    vTexel: Variable<GLSLVec2>,
                    uColorMap: Variable<GLSLTexture>) -> GPUScope {
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        
        globalScope ⟿↘ vTexel
        globalScope ⥥ uColorMap
        globalScope ↳ MainGPUFunction(scope: mainScope)
        
        mainScope ✍ glFragColor ⬅ uColorMap ☒ vTexel
        
        return globalScope
    }
}