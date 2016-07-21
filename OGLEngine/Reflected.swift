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
        let attributes = GPUAttributesCollection(collection: [
            GPUAttributes.position,
            GPUAttributes.texel,
            GPUAttributes.normal
            ])
        let uniforms = GPUVariableCollection<AnyGPUUniform>(collection: [
            GPUUniform(variable: GPUUniforms.planeSpaceModelMatrix),
            GPUUniform(variable: GPUUniforms.planeSpaceViewProjectionMatrix),
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
        attributes attributes: GPUAttributesCollection,
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
                vTexel: interpolation.vTexel,
                vPlaneDistance: interpolation.vPlaneDistance)))
    }
}

struct ReflectedInterpolation: GPUInterpolation {
    let vTexel: Variable<GLSLVec2> = Variable<GLSLVec2>(name: "vTexel")
    let vPlaneDistance: Variable<GLSLFloat> = Variable<GLSLFloat>(name: "vPlaneDistance")
    
    func varyings() -> [GPUVarying] {
        return [
            GPUVarying(variable: vTexel, precision: .Low),
            GPUVarying(variable: vPlaneDistance, precision: .Low)
        ]
    }
}

extension DefaultScopes {
    static func ReflectedVertex(
        glPosition glPosition: Variable<GLSLVec4>,
        aPosition: Variable<GLSLVec3>,
        aTexel: Variable<GLSLVec2>,
        aNormal: Variable<GLSLVec3>,
        uPlaneSpaceModelMatrix: Variable<GLSLMat4>,
        uPlaneSpaceViewProjectionMatrix: Variable<GLSLMat4>,
        vTexel: Variable<GLSLVec2>,
        vPlaneDistance: Variable<GLSLFloat>
        ) -> GPUScope {
        
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        let planeSpaceModelPosition = Variable<GLSLVec4>(name: "planeSpaceModelPosition")
        
        globalScope ⥤ aPosition
        globalScope ⥤ aTexel
        globalScope ⥤ aNormal
        globalScope ⥥ uPlaneSpaceModelMatrix
        globalScope ⥥ uPlaneSpaceViewProjectionMatrix
        globalScope ⟿↘ vTexel
        globalScope ⟿↘ vPlaneDistance
        globalScope ↳ MainGPUFunction(scope: mainScope)
        
        mainScope ✍ vTexel ⬅ aTexel
        mainScope ↳ planeSpaceModelPosition
        mainScope ✍ planeSpaceModelPosition ⬅ uPlaneSpaceModelMatrix * aPosition
        mainScope ✍ vPlaneDistance ⬅ FixedEvaluation<GLSLFloat>(code: "\(planeSpaceModelPosition.name).z")
        mainScope ✍ glPosition ⬅ uPlaneSpaceViewProjectionMatrix * planeSpaceModelPosition
        
        return globalScope
    }
    
    static func ReflectedFragment(
        glFragColor glFragColor: Variable<GLSLColor>,
        uColorMap: Variable<GLSLTexture>,
        vTexel: Variable<GLSLVec2>,
        vPlaneDistance: Variable<GLSLFloat>
        ) -> GPUScope {
        
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        
        globalScope ⥥ uColorMap
        globalScope ⟿↘ vTexel
        globalScope ⟿↘ vPlaneDistance
        globalScope ↳ MainGPUFunction(scope: mainScope)
        
        mainScope ✍ vPlaneDistance > Primitive<GLSLFloat>(value: 0.0)
        mainScope ✍ glFragColor ⬅ uColorMap ☒ vTexel
        
        return globalScope
    }
    
}
