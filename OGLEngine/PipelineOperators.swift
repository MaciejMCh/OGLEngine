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

// Attribute declaration
infix operator ⥤ {}
public func ⥤ (lhs: GPUScope, rhs: AnyGPUVariable) {
    lhs.appendInstruction(GPUDeclaration(variable: rhs, accessKind: .Attribute))
}

// Uniform declaration
infix operator ⥥ {}
public func ⥥ (lhs: GPUScope, rhs: AnyGPUVariable) {
    lhs.appendInstruction(GPUDeclaration(variable: rhs, accessKind: .Uniform))
}

// Varying declaration
infix operator ⟿ {}
public func ⟿ (lhs: GPUScope, rhs: AnyGPUVariable) {
    lhs.appendInstruction(GPUDeclaration(variable: rhs, accessKind: .Varying))
}

// varying declaration

// Uniform declaration

infix operator ⎘ {}
public func ⎘ (lhs: GPUScope, rhs: GPUScope) {
    lhs.mergeScope(rhs)
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
public func ⋅ (lhs: TypedGPUVariable<GLSLVec3>, rhs: TypedGPUVariable<GLSLVec3>) -> GPUEvaluation<GLSLFloat> {
    return GPUEvaluation<GLSLFloat>(function: StandardGPUFunction(name: "dot", input: [lhs, rhs]))
}

// Normalization
prefix operator ^ {}
prefix func ^ (vector: TypedGPUVariable<GLSLVec3>) -> GPUEvaluation<GLSLVec3> {
    return GPUEvaluation<GLSLVec3>(function: StandardGPUFunction(name: "normalize", input: [vector]))
}

// Scaling
public func * (lhs: TypedGPUVariable<GLSLVec2>, rhs: TypedGPUVariable<GLSLFloat>) -> GPUInfixEvaluation<GLSLVec2> {
    return GPUInfixEvaluation<GLSLVec2>(operatorSymbol: "*", lhs: lhs, rhs: rhs)
}


// Matrix operations
infix operator * { associativity left precedence 140 }
public func * (lhs: TypedGPUVariable<GLKMatrix4>, rhs: TypedGPUVariable<GLKVector4>) -> GPUInfixEvaluation<GLKVector4> {
    return GPUInfixEvaluation<GLKVector4>(operatorSymbol: "*", lhs: lhs, rhs: rhs)
}

public func * (lhs: TypedGPUVariable<GLSLMat4>, rhs: TypedGPUVariable<GLSLVec4>) -> GPUInfixEvaluation<GLSLVec4> {
    return GPUInfixEvaluation<GLSLVec4>(operatorSymbol: "*", lhs: lhs, rhs: rhs)
}

public func * (lhs: TypedGPUVariable<GLSLMat3>, rhs: TypedGPUVariable<GLSLVec3>) -> GPUInfixEvaluation<GLSLVec3> {
    return GPUInfixEvaluation<GLSLVec3>(operatorSymbol: "*", lhs: lhs, rhs: rhs)
}

// Color operations
public func * (lhs: TypedGPUVariable<GLSLColor>, rhs: TypedGPUVariable<GLSLFloat>) -> GPUInfixEvaluation<GLSLColor> {
    return GPUInfixEvaluation<GLSLColor>(operatorSymbol: "*", lhs: lhs, rhs: rhs)
}

infix operator ✖ { associativity left precedence 200 }
public func ✖ (lhs: TypedGPUVariable<GLSLColor>, rhs: TypedGPUVariable<GLSLColor>) -> GPUInfixEvaluation<GLSLColor> {
    return GPUInfixEvaluation<GLSLColor>(operatorSymbol: "+", lhs: lhs, rhs: rhs)
}

// Float operations
infix operator ^ { associativity left precedence 200 }
public func ^ (lhs: TypedGPUVariable<GLSLFloat>, rhs: TypedGPUVariable<GLSLFloat>) -> GPUEvaluation<GLSLFloat> {
    return GPUEvaluation<GLSLFloat>(function: StandardGPUFunction(name: "pow", input: [lhs, rhs]))
}
