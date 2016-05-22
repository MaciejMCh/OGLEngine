//
//  GPUFunction.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 21.05.2016.
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
        
        scope | ndl ⬅ normalVector ⋅ lightVector
        scope | ndh ⬅ normalVector ⋅ halfVector
        scope | output ⬅ TypedGPUVariable<GLKVector2>()
        
        return TypedGPUFunction<GLKVector2>(input: input, output: output, scope: scope)
    }
}

public protocol GPUVariable {
    associatedtype UnderlyingType
}

public class AnyGPUVariable: GPUVariable {
    public typealias UnderlyingType = Any
}

public class TypedGPUVariable<T>: AnyGPUVariable {
    public typealias UnderlyingType = T
}



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

// Dot product
infix operator ⋅ { associativity left precedence 200 }
public func ⋅ (lhs: TypedGPUVariable<GLKVector3>, rhs: TypedGPUVariable<GLKVector3>) -> TypedGPUFunction<Float> {
    return TypedGPUFunction<Float>()
}

// Assignment
postfix operator |= {}
public func |= <T>(lhs: TypedGPUVariable<T>, rhs: TypedGPUVariable<T>) -> TypedGPUFunction<Void> {
    return TypedGPUFunction<Void>()
}

public func |= <T>(lhs: TypedGPUVariable<T>, rhs: TypedGPUFunction<T>) -> TypedGPUFunction<Void> {
    return TypedGPUFunction<Void>()
}

infix operator ⬅ { associativity left precedence 140 }
public func ⬅ <T>(lhs: TypedGPUVariable<T>, rhs: TypedGPUVariable<T>) -> TypedGPUFunction<Void> {
    return TypedGPUFunction<Void>()
}

public func ⬅ <T>(lhs: TypedGPUVariable<T>, rhs: TypedGPUFunction<T>) -> TypedGPUFunction<Void> {
    return TypedGPUFunction<Void>()
}


public struct GPUScope {
    
}

infix operator | {}
public func | (lhs: GPUScope, rhs: AnyGPUFunction) {
    
}
