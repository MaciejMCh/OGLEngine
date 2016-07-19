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
public func ⥤ (lhs: GPUScope, rhs: AnyVariable) {
    lhs.appendInstruction(GPUDeclaration(variable: rhs, accessKind: .Attribute))
}

// Uniform declaration
infix operator ⥥ {}
public func ⥥ (lhs: GPUScope, rhs: AnyVariable) {
    lhs.appendInstruction(GPUDeclaration(variable: rhs, accessKind: .Uniform))
}

// Varying declaration
infix operator ⟿↘ {}
public func ⟿↘ (lhs: GPUScope, rhs: AnyVariable) {
    lhs.appendInstruction(GPUDeclaration(variable: rhs, precision: .Low, accessKind: .Varying))
}

infix operator ⟿↗ {}
public func ⟿↗ (lhs: GPUScope, rhs: AnyVariable) {
    lhs.appendInstruction(GPUDeclaration(variable: rhs, precision: .High, accessKind: .Varying))
}

// Local declaration
infix operator ↳ {}
public func ↳ (lhs: GPUScope, rhs: AnyVariable) {
    lhs.appendInstruction(GPUDeclaration(variable: rhs, accessKind: .Local))
}

infix operator ↳↗ {}
public func ↳↗ (lhs: GPUScope, rhs: AnyVariable) {
    lhs.appendInstruction(GPUDeclaration(variable: rhs, precision: .High, accessKind: .Local))
}

infix operator ↳↘ {}
public func ↳↘ (lhs: GPUScope, rhs: AnyVariable) {
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

// MARK: Variable

// Assignment
infix operator ⬅ { associativity left precedence 140 }
public func ⬅ <T>(lhs: Variable<T>, rhs: Evaluation<T>) -> GPUInstruction {
    return GPUAssignment(assignee: lhs, assignment: rhs)
}

public func ⬅ (lhs: Variable<GLSLVec4>, rhs: Evaluation<GLSLVec3>) -> GPUInstruction {
    let extended = VecInits.vec4(rhs)
    return lhs ⬅ extended
}

// MARK: Function

// Vector Operations

// Dot product
infix operator ⋅ { associativity left precedence 200 }
public func ⋅ (lhs: Evaluation<GLSLVec3>, rhs: Evaluation<GLSLVec3>) -> Function<GLSLFloat> {
    return Function<GLSLFloat>(signature: "dot", arguments: [lhs, rhs])
}

// Cross product
public func ✖ (lhs: Variable<GLSLVec3>, rhs: Variable<GLSLVec3>) -> Function<GLSLVec3> {
    return Function<GLSLVec3>(signature: "cross", arguments: [lhs, rhs])
}

// Difference
infix operator - { associativity left precedence 200 }
public func - (lhs: Evaluation<GLSLVec3>, rhs: Evaluation<GLSLVec3>) -> GPUInfixEvaluation<GLSLVec3> {
    return GPUInfixEvaluation<GLSLVec3>(operatorSymbol: "-", lhs: lhs, rhs: rhs)
}

// Sum
infix operator + { associativity left precedence 200 }
public func + (lhs: Evaluation<GLSLVec3>, rhs: Evaluation<GLSLVec3>) -> GPUInfixEvaluation<GLSLVec3> {
    return GPUInfixEvaluation<GLSLVec3>(operatorSymbol: "+", lhs: lhs, rhs: rhs)
}

// Inits

// Normalization
prefix operator ^ {}
prefix func ^ (vector: Evaluation<GLSLVec3>) -> Function<GLSLVec3> {
    return Function<GLSLVec3>(signature: "normalize", arguments: [vector])
}

// Scaling
public func * (lhs: Evaluation<GLSLVec2>, rhs: Evaluation<GLSLFloat>) -> GPUInfixEvaluation<GLSLVec2> {
    return GPUInfixEvaluation<GLSLVec2>(operatorSymbol: "*", lhs: lhs, rhs: rhs)
}

// Primitive Scaling
public func * (lhs: Evaluation<GLSLVec3>, rhs: Evaluation<GLSLFloat>) -> GPUInfixEvaluation<GLSLVec3> {
    return GPUInfixEvaluation<GLSLVec3>(operatorSymbol: "*", lhs: lhs, rhs: rhs)
}

// Matrix operations
infix operator * { associativity left precedence 140 }
public func * (lhs: Evaluation<GLSLMat4>, rhs: Evaluation<GLSLVec4>) -> GPUInfixEvaluation<GLSLVec4> {
    return GPUInfixEvaluation<GLSLVec4>(operatorSymbol: "*", lhs: lhs, rhs: rhs)
}

public func * (lhs: Evaluation<GLSLMat4>, rhs: Evaluation<GLSLMat4>) -> GPUInfixEvaluation<GLSLMat4> {
    return GPUInfixEvaluation<GLSLMat4>(operatorSymbol: "*", lhs: lhs, rhs: rhs)
}

public func * (lhs: Evaluation<GLSLMat3>, rhs: Evaluation<GLSLVec3>) -> GPUInfixEvaluation<GLSLVec3> {
    return GPUInfixEvaluation<GLSLVec3>(operatorSymbol: "*", lhs: lhs, rhs: rhs)
}

public func * (lhs: Evaluation<GLSLMat3>, rhs: Evaluation<GLSLMat3>) -> GPUInfixEvaluation<GLSLMat3> {
    return GPUInfixEvaluation<GLSLMat3>(operatorSymbol: "*", lhs: lhs, rhs: rhs)
}

public func * (lhs: Evaluation<GLSLMat4>, rhs: Evaluation<GLSLVec3>) -> GPUInfixEvaluation<GLSLVec4> {
    let vec4 = VecInits.vec4(rhs)
    return lhs * vec4
}

// Color operations
public func * (lhs: Evaluation<GLSLColor>, rhs: Evaluation<GLSLFloat>) -> GPUInfixEvaluation<GLSLColor> {
    return GPUInfixEvaluation<GLSLColor>(operatorSymbol: "*", lhs: lhs, rhs: rhs)
}

infix operator ✖ { associativity left precedence 200 }
public func ✖ (lhs: Evaluation<GLSLColor>, rhs: Evaluation<GLSLColor>) -> GPUInfixEvaluation<GLSLColor> {
    return GPUInfixEvaluation<GLSLColor>(operatorSymbol: "+", lhs: lhs, rhs: rhs)
}

prefix operator ⤺ {}
prefix func ⤺ (sample: Evaluation<GLSLColor>) -> Function<GLSLVec3> {
//    return FixedGPUEvaluation(glslCode: "normalize(vec3(" + sample.name! + ") * 2.0 - vec3(1.0, 1.0, 1.0));", usedVariables: [sample])
    let vec3 = VecInits.vec3(sample)
    let doubledVec3 = vec3 * Primitive<GLSLFloat>(value: 2.0)
    let substracted = doubledVec3 - Primitive<GLSLVec3>(value: GLKVector3Make(1.0, 1.0, 1.0))
    let normalized = ^substracted
    return normalized
}

struct VecInits {
    static func vec4(vec3: Evaluation<GLSLVec3>) -> Function<GLSLVec4> {
        return Function<GLSLVec4>(signature: "vec4", arguments: [vec3, Primitive<GLSLFloat>(value: 1.0)])
    }
    
    static func color(vec3: Evaluation<GLSLVec3>) -> Function<GLSLColor> {
        return Function<GLSLColor>(signature: "vec4", arguments: [vec3, Primitive<GLSLFloat>(value: 1.0)])
    }
    
    static func vec3(vec4: Evaluation<GLSLVec4>) -> Function<GLSLVec3> {
        return Function<GLSLVec3>(signature: "vec3", arguments: [vec4])
    }
    
    static func vec3(color: Evaluation<GLSLColor>) -> Function<GLSLVec3> {
        return Function<GLSLVec3>(signature: "vec3", arguments: [color])
    }
}

prefix func ⤺ (vector: Evaluation<GLSLVec3>) -> Function<GLSLColor> {
//    return FixedGPUEvaluation(glslCode: "vec4((\(vector.name!) + vec3(1.0, 1.0, 1.0)) * 0.5, 1.0)", usedVariables: [vector])
    let added = vector + Primitive(value: GLKVector3Make(1.0, 1.0, 1.0))
    let halfed = added * Primitive(value: 0.5)
    let extended = VecInits.color(halfed)
    return extended
}

// Float operations
infix operator ^ { associativity left precedence 200 }
public func ^ (lhs: Evaluation<GLSLFloat>, rhs: Evaluation<GLSLFloat>) -> Function<GLSLFloat> {
    return Function<GLSLFloat>(signature: "pow", arguments: [lhs, rhs])
}

public func * (lhs: Evaluation<GLSLFloat>, rhs: Evaluation<GLSLFloat>) -> GPUInfixEvaluation<GLSLFloat> {
    return GPUInfixEvaluation<GLSLFloat>(operatorSymbol: "*", lhs: lhs, rhs: rhs)
}

public func > (lhs: Evaluation<GLSLFloat>, rhs: Evaluation<GLSLFloat>) -> FixedGPUInstruction {
    return FixedGPUInstruction(code: "if (\(lhs.glslFace()) < \(rhs.glslFace())) {discard;}")
}

// Texture operations
infix operator ☒ { associativity left precedence 200 }
public func ☒ (lhs: Evaluation<GLSLTexture>, rhs: Evaluation<GLSLVec2>) -> Function<GLSLColor> {
    return Function<GLSLColor>(signature: "texture2D", arguments: [lhs, rhs])
}

public func ☒ (lhs: Evaluation<GLSLTexture>, rhs: Evaluation<GLSLVec2>) -> FixedEvaluation<GLSLFloat> {
    return FixedEvaluation<GLSLFloat>(code: "texture2D(\(lhs.glslFace()), \(rhs.glslFace())).r * 80.0")
}
