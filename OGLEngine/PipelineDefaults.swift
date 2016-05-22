//
//  PipelineDefaults.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 22.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

public struct GPUFunctions {
    
    static func assignment<T>(assignee: TypedGPUVariable<T>, assignment: TypedGPUVariable<T>) -> TypedGPUFunction<Void> {
        return TypedGPUFunction<Void>()
    }
    
    static func assignment<T>(assignee: TypedGPUVariable<T>, assignment: TypedGPUFunction<T>) -> TypedGPUFunction<Void> {
        return TypedGPUFunction<Void>()
    }
    
    
    static func dotProduct(lhs: TypedGPUVariable<GLKVector3>, rhs: TypedGPUVariable<GLKVector3>) -> TypedGPUFunction<Float> {
        return TypedGPUFunction<Float>()
    }
    
    static func phongFactors() -> TypedGPUFunction<GLKVector2> {
        let output = TypedGPUVariable<GLKVector2>()
        let input = [TypedGPUVariable<GLKVector3>(), TypedGPUVariable<GLKVector3>(), TypedGPUVariable<GLKVector3>()]
        
        let lightVector = input[0]
        let halfVector = input[1]
        let normalVector = input[2]
        
        let scope = GPUScope()
        let ndl = TypedGPUVariable<Float>()
        let ndh = TypedGPUVariable<Float>()
        
        scope ✍ ndl ⬅ normalVector ⋅ lightVector
        scope ✍ ndh ⬅ normalVector ⋅ halfVector
        scope ✍ output ⬅ TypedGPUVariable<GLKVector2>()
        
        return TypedGPUFunction<GLKVector2>(input: input, output: output, scope: scope)
    }
}
