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
        let vViewVector = GPUVariable<GLSLVec3>(name: "vViewVector")
        let aNormal = GPUVariable<GLSLVec3>(name: "aNormal")
        let vNormal = GPUVariable<GLSLVec3>(name: "vNormal")
        let uEyePosition = GPUUniforms.eyePosition;
        let uModelViewProjectionMatrix = GPUVariable<GLSLMat4>(name: "uModelViewProjectionMatrix")
        let uRayBoxColorMap = GPUVariable<GLSLTexture>(name: "uRayBoxColorMap")
        
        let attributes = GPUVariableCollection<AnyGPUAttribute>(collection: [
            GPUAttributes.position,
            GPUAttributes.normal,
            ])
        let uniforms = GPUVariableCollection<AnyGPUUniform>(collection: [
            GPUUniform(variable: GPUUniforms.modelViewProjectionMatrix),
            GPUUniform(variable: GPUUniforms.rayBoxColorMap),
            GPUUniform(variable: GPUUniforms.eyePosition)
            ])
        
        let vertexScope = GPUScope()
        let vertexMainScope = GPUScope()
        vertexScope ⥤ aPosition
        vertexScope ⥤ aNormal
        vertexScope ⥥ uModelViewProjectionMatrix
        vertexScope ⥥ uEyePosition
        vertexScope ⟿↘ vNormal
        vertexScope ⟿↘ vViewVector
        vertexScope ↳ MainGPUFunction(scope: vertexMainScope)
        vertexMainScope ✍ vNormal ⬅ aNormal
        vertexMainScope ✍ vViewVector ⬅ (aPosition - uEyePosition)
        vertexMainScope ✍ OpenGLDefaultVariables.glPosition() ⬅ uModelViewProjectionMatrix * aPosition
        
        let fragmentScope = GPUScope()
        let fragmentMainScope = GPUScope()
        let texelFunction = DefaultGPUFunction.rayBoxTexelWithNormal()
        fragmentScope ⟿↘ vNormal
        fragmentScope ⟿↘ vViewVector
        fragmentScope ⥥ uRayBoxColorMap
        fragmentScope ↳ texelFunction
        fragmentScope ↳ MainGPUFunction(scope: fragmentMainScope)
        fragmentMainScope ✍ FixedGPUInstruction(code: stringFromLines([
            "lowp vec3 viewVector = normalize(vViewVector);",
            "lowp vec3 normal = normalize(vNormal);",
//            d−2(d⋅n)n
            "lowp vec3 ray = viewVector - (normal * (dot(normal, viewVector) * 2.0));"
            ]))
        fragmentMainScope ✍ FixedGPUInstruction(code: stringFromLines([
            "gl_FragColor = texture2D(uRayBoxColorMap, rayBoxTexelWithNormal(ray));"
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
