//
//  PipelineModels.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 22.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

public enum VariablePrecision {
    case Low
    case High
}

public struct GPUVarying {
    let variable: AnyGPUVariable
    let type: GPUType
    let precision: VariablePrecision
}

public struct FragmentShader {
    let uniforms: [Uniform]
    let varyings: [AnyGPUVariable]
    let function: TypedGPUFunction<Void>
}

public struct VertexShader {
    let name: String
    let attributes: [Attribute]
    let uniforms: [Uniform]
    let varyings: [GPUVarying]
    let function: TypedGPUFunction<Void>
}

public struct GPUPipeline {
    let vertexShader: VertexShader
    let fragmentShader: FragmentShader
}

public class GPUScope {
    var instructions: [GPUInstruction] = []
    func appendInstruction(instruction: GPUInstruction) {
        self.instructions.append(instruction)
    }
}

// MARK: Variable
public protocol GPUVariable {
    associatedtype UnderlyingType
}

public class AnyGPUVariable: GPUVariable {
    public typealias UnderlyingType = Any
    private(set) var name: String?
    
    init(name: String? = nil) {
        self.name = name
    }
}

public class TypedGPUVariable<T>: AnyGPUVariable {
    public typealias UnderlyingType = T
    
    private(set) var value: T?
    
    init(value: T? = nil, name: String? = nil) {
        super.init(name: name)
        self.value = value
    }
    
}

// MARK: Function
public protocol GPUFunction {
    associatedtype ReturnType
}

public class AnyGPUFunction: GPUFunction {
    public typealias ReturnType = String
    
    var signature: String
    var input: [AnyGPUVariable]
    var scope : GPUScope
    
    public init() {
        self.signature = "error"
        self.input = []
        self.scope = GPUScope()
    }
    
    public init(signature: String, input: [AnyGPUVariable], output: TypedGPUVariable<ReturnType>, scope: GPUScope) {
        self.signature = signature
        self.input = input
        self.scope = scope
    }
    
    public func outputVariable() -> TypedGPUVariable<ReturnType> {
        return TypedGPUVariable<ReturnType>()
    }
}

public class TypedGPUFunction<T>: AnyGPUFunction {
    typealias ReturnType = T
    
    override init() {
        super.init()
    }
    
    init(signature: String, input: [AnyGPUVariable], scope: GPUScope) {
        super.init()
        self.signature = signature
        self.input = input
        self.scope = scope
    }
    
    init(input: [AnyGPUVariable], output: TypedGPUVariable<T>, scope: GPUScope) {
        super.init()
    }
    
    public func GGoutputVariable() -> TypedGPUVariable<T> {
        return TypedGPUVariable<T>()
    }
}

public class StandardGPUFunction<T>: TypedGPUFunction<T> {
    init(name: String, input: [AnyGPUVariable]) {
        super.init()
        self.input = input
    }
}

// Instruction

public protocol GPUInstruction {
    
}

public struct GPUDeclaration: GPUInstruction {
    let variable: AnyGPUVariable
}

public struct GPUAssignment<T>: GPUInstruction {
    let assignee: TypedGPUVariable<T>
    let assignment: TypedGPUVariable<T>
}

public class GPUEvaluation<ReturnType>: GPUInstruction {
    private(set) var function: TypedGPUFunction<ReturnType>
    
    init(function: TypedGPUFunction<ReturnType>) {
        self.function = function
    }
}

public class GPUInfixEvaluation<ReturnType>: GPUEvaluation<ReturnType> {
    private(set) var operatorSymbol: String
    private(set) var lhs: AnyGPUVariable
    private(set) var rhs: AnyGPUVariable
    
    init(operatorSymbol: String, lhs: AnyGPUVariable, rhs: AnyGPUVariable) {
        self.operatorSymbol = operatorSymbol
        self.lhs = lhs
        self.rhs = rhs
        super.init(function: TypedGPUFunction<ReturnType>())
    }
}

public struct GPUEvaluationAssignment<T>: GPUInstruction {
    let assignee: TypedGPUVariable<T>
    let assignment: GPUEvaluation<T>
}
