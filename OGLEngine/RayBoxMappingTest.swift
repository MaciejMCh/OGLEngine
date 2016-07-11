//
//  RayBoxMappingTest.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 11.07.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

struct RayBoxMappingTestRenderable: Mesh, Model, ReflectiveSolid {
    let vao: VAO
    let geometryModel: GeometryModel
    let rayBoxColorMap: RenderedTexture
}

class RayBoxMappingTestProgram: PipelineProgram {
    typealias RenderableType = RayBoxMappingTestRenderable
    var glName: GLuint = 0
    var pipeline = RayBoxMappingTest.Pipeline()
}

struct RayBoxMappingTest {
    
    struct RayBoxMappingTestInterpolation: GPUInterpolation {
        func varyings() -> [GPUVarying] {
            return []
        }
    }
    
    static func Pipeline() -> GPUPipeline {
        let aPosition = GPUVariable<GLSLVec3>(name: "aPosition")
        let aNormal = GPUVariable<GLSLVec3>(name: "aNormal")
        let vNormal = GPUVariable<GLSLVec3>(name: "vNormal")
        let uModelViewProjectionMatrix = GPUVariable<GLSLMat4>(name: "uModelViewProjectionMatrix")
        let uRayBoxColorMap = GPUVariable<GLSLTexture>(name: "uRayBoxColorMap")
        
        let attributes = GPUVariableCollection<AnyGPUAttribute>(collection: [
            GPUAttributes.position,
            GPUAttributes.normal,
            ])
        let uniforms = GPUVariableCollection<AnyGPUUniform>(collection: [
            GPUUniform(variable: GPUUniforms.modelViewProjectionMatrix),
            GPUUniform(variable: GPUUniforms.rayBoxColorMap)
            ])
        
        let vertexScope = GPUScope()
        let vertexMainScope = GPUScope()
        vertexScope ⥤ aPosition
        vertexScope ⥤ aNormal
        vertexScope ⥥ uModelViewProjectionMatrix
        vertexScope ⟿↘ vNormal
        vertexScope ↳ MainGPUFunction(scope: vertexMainScope)
        vertexMainScope ✍ vNormal ⬅ aNormal
        vertexMainScope ✍ OpenGLDefaultVariables.glPosition() ⬅ uModelViewProjectionMatrix * aPosition
        
        let fragmentScope = GPUScope()
        let fragmentMainScope = GPUScope()
        let texelFunction = DefaultGPUFunction.rayBoxTexelWithNormal()
        fragmentScope ⟿↘ vNormal
        fragmentScope ⥥ uRayBoxColorMap
        fragmentScope ↳ texelFunction
        fragmentScope ↳ MainGPUFunction(scope: fragmentMainScope)
        fragmentMainScope ✍ FixedGPUInstruction(code: stringFromLines([
            "gl_FragColor = texture2D(uRayBoxColorMap, rayBoxTexelWithNormal(vNormal));"
            ]))
        
        let interpolation = RayBoxMappingTestInterpolation()
        let vertexShader = GPUVertexShader(
            name: "RayBoxMappingTest",
            attributes: attributes,
            uniforms: uniforms,
            interpolation: interpolation,
            function: MainGPUFunction(scope: vertexScope))
        let fragmentShader = GPUFragmentShader(
            name: "RayBoxMappingTest",
            uniforms: uniforms,
            interpolation: interpolation,
            function: MainGPUFunction(scope: fragmentScope))
        return GPUPipeline(vertexShader: vertexShader, fragmentShader: fragmentShader)
    }
}
