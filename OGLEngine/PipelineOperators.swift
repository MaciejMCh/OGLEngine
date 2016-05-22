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
public func ✍ (lhs: GPUScope, rhs: GPUInstruction) {
    lhs.appendInstruction(rhs)
}

// MARK: Variable

// Assignment
infix operator ⬅ { associativity left precedence 140 }
public func ⬅ <T>(lhs: TypedGPUVariable<T>, rhs: TypedGPUVariable<T>) -> GPUInstruction {
    return GPUAssignment(assignee: lhs, assignment: rhs)
}

public func ⬅ <T>(lhs: TypedGPUVariable<T>, rhs: GPUEvaluation<T>) -> GPUInstruction {
    return GPUEvaluationAssignment(assignee: lhs, assignment: rhs)
}

prefix operator ⇅ {}
prefix func ⇅ <T>(sharedStruct: GPUSharedStruct) -> TypedGPUVariable<T> {
    return sharedStruct.GPUVariable()
}

// MARK: Function

// Dot product
infix operator ⋅ { associativity left precedence 200 }
public func ⋅ (lhs: TypedGPUVariable<GLKVector3>, rhs: TypedGPUVariable<GLKVector3>) -> GPUEvaluation<Float> {
    return GPUEvaluation<Float>(function: StandardGPUFunction(name: "dot", input: [lhs, rhs]))
}

// Matrix operations
infix operator * { associativity left precedence 140 }
public func * (lhs: TypedGPUVariable<GLKMatrix4>, rhs: TypedGPUVariable<GLKVector4>) -> GPUInfixEvaluation<GLKVector4> {
    return GPUInfixEvaluation<GLKVector4>(operatorSymbol: "*", lhs: lhs, rhs: rhs)
}