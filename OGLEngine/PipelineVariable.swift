//
//  PipelineVariable.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 31.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

public enum GPUVariablePrecision {
    case Low
    case High
}

public enum GPUVariableAccessKind {
    case Attribute
    case Uniform
    case Varying
    case Local
}

public protocol AnyEvaluation {
    func glslFace() -> String
}

public class Evaluation<T: GLSLType>: AnyEvaluation {
    public func glslFace() -> String {
        assert(false)
        return ""
    }
}

public protocol AnyVariable {
    var name: String {get}
    func createUniform() -> AnyGPUUniform
    func declaration(access access: GPUVariableAccessKind, precision: GPUVariablePrecision?) -> String
}

public class Variable<T: GLSLType>: Evaluation<T>, AnyVariable {
    public var name: String
    
    init(name: String) {
        self.name = name
    }
    
    public override func glslFace() -> String {
        return name
    }
    
    public func createUniform() -> AnyGPUUniform {
        let name = "u" + self.name.substringFromIndex(self.name.startIndex.advancedBy(1))
        return GPUUniform<T>(name: name)
    }
    
    public func declaration(access accessKind: GPUVariableAccessKind, precision: GPUVariablePrecision?) -> String {
        var access = ""
        switch accessKind {
        case .Attribute: access = "attribute "
        case .Uniform: access = "uniform "
        case .Varying: access = "varying "
        case .Local: access = ""
        }
        let precision = precision != nil ? GLSLParser.precision(precision!) : ""
        let type = GLSLParser.variableType(self)
        var result = access + " " + precision + " " + type + " " + name + ";"
        
        // Trim
        result = result.stringByReplacingOccurrencesOfString("   ", withString: " ")
        result = result.stringByReplacingOccurrencesOfString("  ", withString: " ")
        result = result.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        return result
    }
}

class Primitive<T: GLSLType>: Evaluation<T> {
    var value: T.CPUCounterpart
    
    init(value: T.CPUCounterpart) {
        self.value = value
    }
    
    override func glslFace() -> String {
        return T.primitiveFace(value)
    }
}

protocol AnyFunction {
    var signature: String {get}
    var arguments: [AnyEvaluation] {get}
}

public class Function<T: GLSLType>: Evaluation<T>, AnyFunction {
    var signature: String
    var arguments: [AnyEvaluation]
    
    init(signature: String, arguments: [AnyEvaluation]) {
        self.signature = signature
        self.arguments = arguments
    }
    
    public override func glslFace() -> String {
        var face = signature + "("
        for argument in arguments {
            face = face + argument.glslFace() + ", "
        }
        if face.characters.count > 3 {
            face = face.substringToIndex(face.endIndex.advancedBy(-2))
        }
        face = face + ")"
        return face
    }
}

extension Function: GPUInstruction {
    public func glslRepresentation() -> String {
        return glslFace()
    }
    public func variablesUsed() -> [AnyVariable] {
        return arguments.map{$0.variablesUsed()}.stomp()
    }
}

public class InfixFunction<ReturnType: GLSLType>: Evaluation<ReturnType> {
    private(set) var operatorSymbol: String
    private(set) var lhs: AnyEvaluation
    private(set) var rhs: AnyEvaluation
    
    init(operatorSymbol: String, lhs: AnyEvaluation, rhs: AnyEvaluation) {
        self.operatorSymbol = operatorSymbol
        self.lhs = lhs
        self.rhs = rhs
    }
    
    public override func glslFace() -> String {
        return "(\(lhs.glslFace()) \(operatorSymbol) \(rhs.glslFace()))"
    }
}

extension InfixFunction: GPUInstruction {
    public func glslRepresentation() -> String {
        return glslFace()
    }
    
    public func variablesUsed() -> [AnyVariable] {
        var variables: [AnyVariable] = []
        variables.appendContentsOf(lhs.variablesUsed())
        variables.appendContentsOf(rhs.variablesUsed())
        return variables
    }
}

public class IntArrayVariable: Variable<GLSLIntArray> {
    var size: UInt
    
    init(name: String, size: UInt) {
        self.size = size
        super.init(name: name)
    }
    
    public override func declaration(access accessKind: GPUVariableAccessKind, precision: GPUVariablePrecision?) -> String {
        var declaration = Variable<GLSLInt>(name: name).declaration(access: accessKind, precision: precision)
        declaration = declaration.stringByReplacingOccurrencesOfString(";", withString: "[\(size)];")
        return declaration
    }
}
