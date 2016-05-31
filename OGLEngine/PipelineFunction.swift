//
//  PipelineFunction.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 31.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

public protocol GPUFunction {
    associatedtype ReturnType
}

public class AnyGPUFunction: GPUFunction {
    public typealias ReturnType = GLSLVoid
    
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

public class TypedGPUFunction<T: GLSLType>: AnyGPUFunction {
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

public class ShaderFunction: TypedGPUFunction<GLSLVoid> {
    init(scope: GPUScope) {
        super.init(signature: "main", input: [], scope: scope)
    }
}

public class StandardGPUFunction<T: GLSLType>: TypedGPUFunction<T> {
    init(name: String, input: [AnyGPUVariable]) {
        super.init()
        self.signature = name
        self.input = input
    }
}
