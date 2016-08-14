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
        let attributes = GPUAttributesCollection(collection: [
            GPUAttributes.position,
            GPUAttributes.texel
            ])
        let uniforms = UniformsCollection(collection: [
            GPUUniforms.rotatedProjectionMatrix,
            GPUUniforms.colorMap
            ])
        let interpolation = SkyBoxInterpolation()
        return GPUPipeline(
            vertexShader: DefaultVertexShaders.SkyBox(attributes, uniforms: uniforms, interpolation: interpolation),
            fragmentShader: DefaultFragmentShaders.SkyBox(uniforms, interpolation: interpolation))
    }
}

extension DefaultVertexShaders {
    static func SkyBox(attributes: GPUAttributesCollection, uniforms: UniformsCollection, interpolation: SkyBoxInterpolation) -> GPUVertexShader {
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
    static func SkyBox(uniforms: UniformsCollection, interpolation: SkyBoxInterpolation) -> GPUFragmentShader {
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
    let vTexel: Variable<GLSLVec2> = Variable<GLSLVec2>(name: "vTexel")
    
    func varyings() -> [GPUVarying] {
        return [GPUVarying(variable: vTexel, precision: .Low)]
    }
}

extension DefaultScopes {
    static func SkyBoxVertex(
        glPosition glPosition: Variable<GLSLVec4>,
                   aPosition: Variable<GLSLVec3>,
                   aTexel: Variable<GLSLVec2>,
                   vTexel: Variable<GLSLVec2>,
                   uRotatedProjectionMatrix: Variable<GLSLMat4>
        ) -> GPUScope {
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        
        globalScope ⥤ aPosition
        globalScope ⥤ aTexel
        globalScope ⥥ uRotatedProjectionMatrix
        globalScope ⟿↘ vTexel
        globalScope ↳ MainGPUFunction(scope: mainScope)
        
        mainScope ✍ FixedGPUInstruction(code: "vTexel = vec2(aTexel.x, 1.0 - aTexel.y);", usedVariables: [])
        mainScope ✍ glPosition ⬅ uRotatedProjectionMatrix * aPosition
        
        return globalScope
    }
    
    
    static func SkyBoxFragment(
        glFragColor glFragColor: Variable<GLSLColor>,
                    vTexel: Variable<GLSLVec2>,
                    uColorMap: Variable<GLSLTexture>
        ) -> GPUScope {
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        
        globalScope ⟿↘ vTexel
        globalScope ⥥ uColorMap
        globalScope ↳ MainGPUFunction(scope: mainScope)
        mainScope ✍ glFragColor ⬅ VecInits.fixedAlphaColor(uColorMap ☒ vTexel, alpha: Primitive(value: 0.0))
        
        return globalScope
    }
}