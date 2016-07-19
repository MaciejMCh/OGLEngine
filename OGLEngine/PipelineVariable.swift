//
//  PipelineVariable.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 31.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

public class AnyGPUVariable {
    private(set) var name: String?
    
    init(name: String? = nil) {
        self.name = name
    }
}

extension AnyGPUVariable: GPURepresentable {
    var glslName: String {
        get {
            return self.name!
        }
    }
}

public class GPUVariable<T: GLSLType>: AnyGPUVariable {
    private(set) var value: T.CPUCounterpart?
    override var name: String? {
        get {
            if let value = self.value {
                return T.primitiveFace(value)
            } else {
                return super.name
            }
        }
        set {
            self.name = newValue
        }
    }
    
    init(value: T.CPUCounterpart? = nil, name: String? = nil) {
        super.init(name: name)
        self.value = value
    }   
}

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














protocol AnyEvaluation {
    func glslFace() -> String
}

class Evaluation<T: GLSLType>: AnyEvaluation {
    func glslFace() -> String {
        return ""
    }
}

protocol AnyVariable {
    var name: String {get}
}

class Variable<T: GLSLType>: Evaluation<T>, AnyVariable {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

class Primitive<T: GLSLType>: Evaluation<T> {
    var value: T.CPUCounterpart
    
    init(value: T.CPUCounterpart) {
        self.value = value
    }
}

class Function<T: GLSLType>: Evaluation<T> {
    var signature: String
    var arguments: [AnyVariable]
    
    init(signature: String, arguments: [AnyVariable]) {
        self.signature = signature
        self.arguments = arguments
    }
}

class InfixFunction<T: GLSLType>: Evaluation<T> {
    var lhs: AnyVariable
    var rhs: AnyVariable
    
    init(lhs: AnyVariable, rhs: AnyVariable) {
        self.lhs = lhs
        self.rhs = rhs
    }
}


