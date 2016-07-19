//
//  PipelineVariable.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 31.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

//public class AnyGPUVariable {
//    private(set) var name: String?
//    
//    init(name: String? = nil) {
//        self.name = name
//    }
//}
//
//extension AnyGPUVariable: GPURepresentable {
//    var glslName: String {
//        get {
//            return self.name!
//        }
//    }
//}

//public class Variable<T: GLSLType>: AnyGPUVariable {
//    private(set) var value: T.CPUCounterpart?
//    override var name: String? {
//        get {
//            if let value = self.value {
//                return T.primitiveFace(value)
//            } else {
//                return super.name
//            }
//        }
//        set {
//            self.name = newValue
//        }
//    }
//    
//    init(value: T.CPUCounterpart? = nil, name: String? = nil) {
//        super.init(name: name)
//        self.value = value
//    }   
//}

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
        return ""
    }
}

public class FixedEvaluation<T: GLSLType>: Evaluation<T> {
    var code: String
    
    init(code: String) {
        self.code = code
    }
    
    override public func glslFace() -> String {
        return code
    }
}

public protocol AnyVariable {
    var name: String {get}
}

public class Variable<T: GLSLType>: Evaluation<T>, AnyVariable {
    public var name: String
    
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
}

class InfixFunction<T: GLSLType>: Evaluation<T> {
    var lhs: AnyVariable
    var rhs: AnyVariable
    
    init(lhs: AnyVariable, rhs: AnyVariable) {
        self.lhs = lhs
        self.rhs = rhs
    }
}


