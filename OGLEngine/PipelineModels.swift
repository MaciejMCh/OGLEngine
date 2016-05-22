//
//  PipelineModels.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 22.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

public struct FragmentShader {
    let uniforms: [Uniform]
    let varyings: [AnyGPUVariable]
    let function: TypedGPUFunction<Void>
}

public struct VertexShader {
    let attributes: [Attribute]
    let uniforms: [Uniform]
    let varyings: [AnyGPUVariable]
    let function: TypedGPUFunction<Void>
}

public struct GPUPipeline {
    let vertexShader: VertexShader
    let fragmentShader: FragmentShader
}

public struct GPUScope {
    
}

// MARK: Variable
public protocol GPUVariable {
    associatedtype UnderlyingType
}

public class AnyGPUVariable: GPUVariable {
    public typealias UnderlyingType = Any
}

public class TypedGPUVariable<T>: AnyGPUVariable {
    public typealias UnderlyingType = T
    
    private(set) var value: T!
    
    init(value: T) {
        self.value = value
    }
    
    override init() {
        
    }
}

// MARK: Function
public protocol GPUFunction {
    associatedtype ReturnType
}

public class AnyGPUFunction: GPUFunction {
    public typealias ReturnType = Any
    
    var input: [AnyGPUVariable]
    var output: TypedGPUVariable<ReturnType>
    var scope : GPUScope
    
    public init() {
        self.output = TypedGPUVariable<ReturnType>()
        self.input = []
        self.scope = GPUScope()
    }
    
    public init(input: [AnyGPUVariable], output: TypedGPUVariable<ReturnType>, scope: GPUScope) {
        self.input = input
        self.output = output
        self.scope = scope
    }
}

public class TypedGPUFunction<T>: AnyGPUFunction {
    public typealias ReturnType = T
    
    override init() {
        super.init()
    }
    
    init(input: [AnyGPUVariable], output: TypedGPUVariable<T>, scope: GPUScope) {
        super.init()
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

public struct GPUEvaluationAssignment<T>: GPUInstruction {
    let assignee: TypedGPUVariable<T>
    let assignment: GPUEvaluation<T>
}

public class GPUDotProduct: GPUEvaluation<Float> {
//    private(set) var lhs: TypedGPUVariable<GLKVector3>
//    private(set) var rhs: TypedGPUVariable<GLKVector3>
    
//    init(lhs: TypedGPUVariable<GLKVector3>, rhs: TypedGPUVariable<GLKVector3>) {
//        self.lhs = lhs
//        self.rhs = rhs
//    }
}