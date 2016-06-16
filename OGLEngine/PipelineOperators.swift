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
infix operator ⟿↘ {}
public func ⟿↘ (lhs: GPUScope, rhs: AnyGPUVariable) {
    lhs.appendInstruction(GPUDeclaration(variable: rhs, precision: .Low, accessKind: .Varying))
}

infix operator ⟿↗ {}
public func ⟿↗ (lhs: GPUScope, rhs: AnyGPUVariable) {
    lhs.appendInstruction(GPUDeclaration(variable: rhs, precision: .High, accessKind: .Varying))
}

// Local declaration
infix operator ↳ {}
public func ↳ (lhs: GPUScope, rhs: AnyGPUVariable) {
    lhs.appendInstruction(GPUDeclaration(variable: rhs, accessKind: .Local))
}

infix operator ↳↗ {}
public func ↳↗ (lhs: GPUScope, rhs: AnyGPUVariable) {
    lhs.appendInstruction(GPUDeclaration(variable: rhs, precision: .High, accessKind: .Local))
}

infix operator ↳↘ {}
public func ↳↘ (lhs: GPUScope, rhs: AnyGPUVariable) {
    lhs.appendInstruction(GPUDeclaration(variable: rhs, precision: .Low, accessKind: .Local))
}

// Uniform declaration
infix operator ⎘ {}
public func ⎘ (lhs: GPUScope, rhs: GPUScope) {
    lhs.mergeScope(rhs)
}

// Function declaration
public func ↳ (lhs: GPUScope, rhs: AnyGPUFunction) {
    lhs.appendFunction(rhs)
}

// MARK: GPUVariable

// Assignment
infix operator ⬅ { associativity left precedence 140 }
public func ⬅ <T>(lhs: GPUVariable<T>, rhs: GPUVariable<T>) -> GPUInstruction {
    return GPUAssignment(assignee: lhs, assignment: rhs)
}

public func ⬅ <T>(lhs: GPUVariable<T>, rhs: GPUEvaluation<T>) -> GPUInstruction {
    return GPUEvaluationAssignment(assignee: lhs, assignment: rhs)
}

// MARK: Function

// Vector Operations

// Dot product
infix operator ⋅ { associativity left precedence 200 }
public func ⋅ (lhs: GPUVariable<GLSLVec3>, rhs: GPUVariable<GLSLVec3>) -> GPUEvaluation<GLSLFloat> {
    return GPUEvaluation<GLSLFloat>(function: GPUFunction<GLSLFloat>(signature: "dot", input: [lhs, rhs]))
}

// Cross product
public func ✖ (lhs: GPUVariable<GLSLVec3>, rhs: GPUVariable<GLSLVec3>) -> GPUEvaluation<GLSLVec3> {
    return GPUEvaluation<GLSLVec3>(function: GPUFunction<GLSLVec3>(signature: "cross", input: [lhs, rhs]))
}

// Difference
infix operator - { associativity left precedence 200 }
public func - (lhs: GPUVariable<GLSLVec3>, rhs: GPUVariable<GLSLVec3>) -> GPUInfixEvaluation<GLSLVec3> {
    return GPUInfixEvaluation<GLSLVec3>(operatorSymbol: "-", lhs: lhs, rhs: rhs)
}

// Sum
infix operator + { associativity left precedence 200 }
public func + (lhs: GPUVariable<GLSLVec3>, rhs: GPUVariable<GLSLVec3>) -> GPUInfixEvaluation<GLSLVec3> {
    return GPUInfixEvaluation<GLSLVec3>(operatorSymbol: "+", lhs: lhs, rhs: rhs)
}


// Normalization
prefix operator ^ {}
prefix func ^ (vector: GPUVariable<GLSLVec3>) -> GPUEvaluation<GLSLVec3> {
    return GPUEvaluation<GLSLVec3>(function: GPUFunction<GLSLVec3>(signature: "normalize", input: [vector]))
}

// Scaling
public func * (lhs: GPUVariable<GLSLVec2>, rhs: GPUVariable<GLSLFloat>) -> GPUInfixEvaluation<GLSLVec2> {
    return GPUInfixEvaluation<GLSLVec2>(operatorSymbol: "*", lhs: lhs, rhs: rhs)
}

// Primitive Scaling
public func * (lhs: GPUVariable<GLSLVec3>, rhs: GPUVariable<GLSLFloat>) -> GPUInfixEvaluation<GLSLVec3> {
    return GPUInfixEvaluation<GLSLVec3>(operatorSymbol: "*", lhs: lhs, rhs: rhs)
}

// Matrix operations
infix operator * { associativity left precedence 140 }
public func * (lhs: GPUVariable<GLSLMat4>, rhs: GPUVariable<GLSLVec4>) -> GPUInfixEvaluation<GLSLVec4> {
    return GPUInfixEvaluation<GLSLVec4>(operatorSymbol: "*", lhs: lhs, rhs: rhs)
}

public func * (lhs: GPUVariable<GLSLMat4>, rhs: GPUVariable<GLSLMat4>) -> GPUInfixEvaluation<GLSLMat4> {
    return GPUInfixEvaluation<GLSLMat4>(operatorSymbol: "*", lhs: lhs, rhs: rhs)
}

public func * (lhs: GPUVariable<GLSLMat3>, rhs: GPUVariable<GLSLVec3>) -> GPUInfixEvaluation<GLSLVec3> {
    return GPUInfixEvaluation<GLSLVec3>(operatorSymbol: "*", lhs: lhs, rhs: rhs)
}

public func * (lhs: GPUVariable<GLSLMat3>, rhs: GPUVariable<GLSLMat3>) -> GPUInfixEvaluation<GLSLMat3> {
    return GPUInfixEvaluation<GLSLMat3>(operatorSymbol: "*", lhs: lhs, rhs: rhs)
}

// Color operations
public func * (lhs: GPUVariable<GLSLColor>, rhs: GPUVariable<GLSLFloat>) -> GPUInfixEvaluation<GLSLColor> {
    return GPUInfixEvaluation<GLSLColor>(operatorSymbol: "*", lhs: lhs, rhs: rhs)
}

infix operator ✖ { associativity left precedence 200 }
public func ✖ (lhs: GPUVariable<GLSLColor>, rhs: GPUVariable<GLSLColor>) -> GPUInfixEvaluation<GLSLColor> {
    return GPUInfixEvaluation<GLSLColor>(operatorSymbol: "+", lhs: lhs, rhs: rhs)
}

prefix operator ⤺ {}
prefix func ⤺ (sample: GPUVariable<GLSLColor>) -> FixedGPUEvaluation<GLSLVec3> {
    return FixedGPUEvaluation(glslCode: "normalize(vec3(" + sample.name! + ") * 2.0 - vec3(1.0, 1.0, 1.0));")
}

prefix func ⤺ (vector: GPUVariable<GLSLVec3>) -> FixedGPUEvaluation<GLSLColor> {
    return FixedGPUEvaluation(glslCode: "vec4((\(vector.name!) + vec3(1.0, 1.0, 1.0)) * 0.5, 1.0)")
}

// Float operations
infix operator ^ { associativity left precedence 200 }
public func ^ (lhs: GPUVariable<GLSLFloat>, rhs: GPUVariable<GLSLFloat>) -> GPUEvaluation<GLSLFloat> {
    return GPUEvaluation<GLSLFloat>(function: GPUFunction<GLSLFloat>(signature: "pow", input: [lhs, rhs]))
}

public func > (lhs: GPUVariable<GLSLFloat>, rhs: GPUVariable<GLSLFloat>) -> FixedGPUInstruction {
    return FixedGPUInstruction(code: "if (\(lhs.name!) < \(rhs.name!)) {discard;}")
}

// Texture operations
infix operator ☒ { associativity left precedence 200 }
public func ☒ (lhs: GPUVariable<GLSLTexture>, rhs: GPUVariable<GLSLVec2>) -> GPUEvaluation<GLSLColor> {
    return GPUEvaluation<GLSLColor>(function: GPUFunction<GLSLColor>(signature: "texture2D", input: [lhs, rhs]))
}