//
//  SkyBoxPipeline.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 05.07.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

extension DefaultPipelines {
    static func SkyBox() -> GPUPipeline {
        let attributes = GPUVariableCollection<AnyGPUAttribute>(collection: [
            GPUAttributes.position,
            GPUAttributes.texel
            ])
        let uniforms = GPUVariableCollection<AnyGPUUniform>(collection: [
            GPUUniform(variable: GPUUniforms.rotatedProjectionMatrix),
            GPUUniform(variable: GPUUniforms.colorMap)
            ])
        let interpolation = SkyBoxInterpolation()
        return GPUPipeline(
            vertexShader: DefaultVertexShaders.SkyBox(attributes, uniforms: uniforms, interpolation: interpolation),
            fragmentShader: DefaultFragmentShaders.SkyBox(uniforms, interpolation: interpolation))
    }
}

extension DefaultVertexShaders {
    static func SkyBox(attributes: GPUVariableCollection<AnyGPUAttribute>, uniforms: GPUVariableCollection<AnyGPUUniform>, interpolation: SkyBoxInterpolation) -> GPUVertexShader {
        return GPUVertexShader(
            name: "SkyBox",
            attributes: attributes,
            uniforms: uniforms,
            interpolation: interpolation,
            function: MainGPUFunction(
                scope: DefaultScopes.SkyBoxVertex(
                    glPosition: OpenGLDefaultVariables.glPosition(),
                    aPosition: attributes.get(GPUAttributes.position),
                    aTexel: attributes.get(GPUAttributes.texel),
                    vTexel: interpolation.vTexel,
                    uRotatedProjectionMatrix: uniforms.get(GPUUniforms.rotatedProjectionMatrix))))
    }
}

extension DefaultFragmentShaders {
    static func SkyBox(uniforms: GPUVariableCollection<AnyGPUUniform>, interpolation: SkyBoxInterpolation) -> GPUFragmentShader {
        return GPUFragmentShader(
            name: "SkyBox",
            uniforms: uniforms,
            interpolation: interpolation,
            function: MainGPUFunction(scope: DefaultScopes.SkyBoxFragment(
                glFragColor: OpenGLDefaultVariables.glFragColor(),
                vTexel: interpolation.vTexel,
                uColorMap: uniforms.get(GPUUniforms.colorMap))))
    }
}

struct SkyBoxInterpolation: GPUInterpolation {
    let vTexel: GPUVariable<GLSLVec2> = GPUVariable<GLSLVec2>(name: "vTexel")
    
    func varyings() -> [GPUVarying] {
        return [GPUVarying(variable: vTexel, precision: .Low)]
    }
}

extension DefaultScopes {
    static func SkyBoxVertex(
        glPosition glPosition: GPUVariable<GLSLVec4>,
                   aPosition: GPUVariable<GLSLVec3>,
                   aTexel: GPUVariable<GLSLVec2>,
                   vTexel: GPUVariable<GLSLVec2>,
                   uRotatedProjectionMatrix: GPUVariable<GLSLMat4>
        ) -> GPUScope {
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        
        globalScope ⥤ aPosition
        globalScope ⥤ aTexel
        globalScope ⥥ uRotatedProjectionMatrix
        globalScope ⟿↘ vTexel
        globalScope ↳ MainGPUFunction(scope: mainScope)
        
        mainScope ✍ vTexel ⬅ aTexel
        mainScope ✍ glPosition ⬅ uRotatedProjectionMatrix * aPosition
        
        return globalScope
    }
    
    
    static func SkyBoxFragment(
        glFragColor glFragColor: GPUVariable<GLSLColor>,
                    vTexel: GPUVariable<GLSLVec2>,
                    uColorMap: GPUVariable<GLSLTexture>
        ) -> GPUScope {
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        
        globalScope ⟿↘ vTexel
        globalScope ⥥ uColorMap
        globalScope ↳ MainGPUFunction(scope: mainScope)
        
        mainScope ✍ glFragColor ⬅ uColorMap ☒ vTexel
        
        return globalScope
    }
}