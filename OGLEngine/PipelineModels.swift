//
//  PipelineModels.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 22.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

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
