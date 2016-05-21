//
//  GPUFunction.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 21.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

//protocol GPUFunction {
//    associatedtype InputType
//    associatedtype OutputType
//    
//    func functionBody(input: InputType) -> OutputType
//}

public struct GPUFunction {
    var input: [GPUVariable]
    var output: GPUVariable
    var scope : GPUScope
    
    static func assignment(assignee: GPUVariable, assignment: GPUVariable) -> GPUFunction {
        return GPUFunction()
    }
    
    static func assignment(assignee: GPUVariable, assignment: GPUFunction) -> GPUFunction {
        return GPUFunction()
    }
    
    
    static func dotProduct(lhs: GPUVariable, rhs: GPUVariable) -> GPUFunction {
        return GPUFunction()
    }
    
    static func phongFactors() -> GPUFunction {
        let output = GPUVariable.color()
        let input = [GPUVariable(), GPUVariable(), GPUVariable()]
        
        let lightVector = input[0]
        let halfVector = input[1]
        let normalVector = input[2]
        
        let scope = GPUScope()
        let ndl = GPUVariable()
        let ndh = GPUVariable()
        
        scope | (ndl |= (normalVector || lightVector))
        scope | (ndh |= (normalVector || halfVector))
        scope | (output |= GPUVariable.color())
        
        return GPUFunction(input: input, output: output, scope: scope)
    }
    
    init(input: [GPUVariable] = [], output: GPUVariable = GPUVariable(), scope: GPUScope = GPUScope()) {
        self.input = input
        self.output = output
        self.scope = scope
    }
}

public struct GPUVariable {
    func declare() -> GPUFunction {
        return GPUFunction()
    }
    
    static func color() -> GPUVariable {
        return GPUVariable()
    }
    
    static func vec3() -> GPUVariable {
        return GPUVariable()
    }
}

postfix operator || {}
public func || (lhs: GPUVariable, rhs: GPUVariable) -> GPUFunction {
    return GPUFunction.dotProduct(lhs, rhs: rhs)
}

postfix operator |= {}
public func |= (lhs: GPUVariable, rhs: GPUVariable) -> GPUFunction {
    return GPUFunction.assignment(lhs, assignment: rhs)
}

public func |= (lhs: GPUVariable, rhs: GPUFunction) -> GPUFunction {
    return GPUFunction.assignment(lhs, assignment: rhs)
}

public struct GPUScope {
    
}

postfix operator | {}
public func | (lhs: GPUScope, rhs: GPUFunction) {
    
}

func diffuseColor() {
    let scope = GPUScope()
}

func play() {
    let scope = GPUScope()
    let viewVector = GPUVariable()
    let normalVector = GPUVariable()
    
    scope | viewVector.declare()
    scope | normalVector.declare()
}