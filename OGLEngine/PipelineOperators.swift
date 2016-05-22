//
//  PipelineOperators.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 22.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

// MARK: Scope

// Append function
infix operator ✍ {}
public func ✍ (lhs: GPUScope, rhs: AnyGPUFunction) {
    
}

// MARK: Variable

// Assignment
infix operator ⬅ { associativity left precedence 140 }
public func ⬅ <T>(lhs: TypedGPUVariable<T>, rhs: TypedGPUVariable<T>) -> TypedGPUFunction<Void> {
    return TypedGPUFunction<Void>()
}

public func ⬅ <T>(lhs: TypedGPUVariable<T>, rhs: TypedGPUFunction<T>) -> TypedGPUFunction<Void> {
    return TypedGPUFunction<Void>()
}

prefix operator ⇅ {}
prefix func ⇅ <T>(sharedStruct: GPUSharedStruct) -> TypedGPUVariable<T> {
    return sharedStruct.GPUVariable()
}

// MARK: Function

// Dot product
infix operator ⋅ { associativity left precedence 200 }
public func ⋅ (lhs: TypedGPUVariable<GLKVector3>, rhs: TypedGPUVariable<GLKVector3>) -> TypedGPUFunction<Float> {
    return TypedGPUFunction<Float>()
}