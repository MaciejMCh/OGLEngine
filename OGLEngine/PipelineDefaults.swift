//
//  PipelineDefaults.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 22.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

public struct DefaultPipelines {
    static func mediumShotPipeline() -> GPUPipeline {
        let varyings = [GPUVarying(variable: TypedGPUVariable<GLKVector2>(name: "vTexel"), type: .Vec2, precision: .Low)]
        let vertexShader = VertexShader(
            name: "Medium Shot",
            attributes: [.Position, .Texel, .Normal],
            uniforms: [.ModelViewProjectionMatrix],
            varyings: varyings,
            function: GPUFunctions.mediumShotVertex())
        let fragmentShader = FragmentShader(
            uniforms: [.ColorMap],
            varyings: [],
            function: GPUFunctions.mediumShotFragment())
        return GPUPipeline(vertexShader: vertexShader, fragmentShader: fragmentShader)
    }
}

public struct GPUFunctions {
    
    static func mediumShotVertex() -> TypedGPUFunction<Void> {
        let scope = GPUScope()
        return TypedGPUFunction<Void>(signature: "main", input: [], output: TypedGPUVariable<Void>(), scope: scope)
    }
    
    static func mediumShotFragment() -> TypedGPUFunction<Void> {
        return TypedGPUFunction<Void>()
    }
    
    static func phongFactors() -> TypedGPUFunction<PhongFactors> {
        let output = TypedGPUVariable<PhongFactors>()
        let input = [TypedGPUVariable<GLKVector3>(), TypedGPUVariable<GLKVector3>(), TypedGPUVariable<GLKVector3>()]
        
        let lightVector = input[0]
        let halfVector = input[1]
        let normalVector = input[2]
        
        let scope = GPUScope()
        let ndl = TypedGPUVariable<Float>(name: "ndl")
        let ndh = TypedGPUVariable<Float>(name: "ndh")
        
        scope ✍ ndl ⬅ normalVector ⋅ lightVector
        scope ✍ ndh ⬅ normalVector ⋅ halfVector
        scope ✍ output ⬅ ⇅PhongFactors(ndl: ndl, ndh: ndh)
        return TypedGPUFunction<PhongFactors>(input: input, output: output, scope: scope)
    }
}
