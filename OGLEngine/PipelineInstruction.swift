//
//  PipelineInstruction.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 31.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

public protocol GPUInstruction {
    func glslRepresentation() -> String
}

public struct FixedGPUInstruction: GPUInstruction {
    let code: String
    
    public func glslRepresentation() -> String {
        return code
    }
}

public struct GPUDeclaration: GPUInstruction {
    let variable: AnyVariable
    let precision: GPUVariablePrecision?
    let accessKind: GPUVariableAccessKind
    
    init(variable: AnyVariable, precision: GPUVariablePrecision? = nil, accessKind: GPUVariableAccessKind = .Local) {
        self.variable = variable
        self.precision = precision
        self.accessKind = accessKind
    }
    
    public func glslRepresentation() -> String {
        var access = ""
        switch self.accessKind {
        case .Attribute: access = "attribute "
        case .Uniform: access = "uniform "
        case .Varying: access = "varying "
        case .Local: access = ""
        }
        let precision = self.precision != nil ? GLSLParser.precision(self.precision!) : ""
        let type = GLSLParser.variableType(self.variable)
        let name = self.variable.name
        var result = access + " " + precision + " " + type + " " + name + ";"
        
        // Trim
        result = result.stringByReplacingOccurrencesOfString("   ", withString: " ")
        result = result.stringByReplacingOccurrencesOfString("  ", withString: " ")
        result = result.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        return result
    }
}

public struct GPUAssignment<T: GLSLType>: GPUInstruction {
    let assignee: Variable<T>
    let assignment: Evaluation<T>
    
    public func glslRepresentation() -> String {
        return assignee.name + " = " + assignment.glslFace() + ";"
    }
}

//public class GPUEvaluation<ReturnType: GLSLType>: GPUInstruction {
//    private(set) var function: GPUFunction<ReturnType>
//    
//    init(function: GPUFunction<ReturnType>) {
//        self.function = function
//    }
//    
//    func variable() -> Variable<ReturnType> {
//        return Variable<ReturnType>(name: "")
//    }
//    
//    public func glslRepresentation() -> String {
//        var inputString = ""
//        for argument in self.function.input {
//            inputString = inputString + argument.name! + ", "
//        }
//        if inputString.characters.count >= 2 {
//            inputString = inputString.substringToIndex(inputString.endIndex.advancedBy(-2))
//        }
//        return self.function.signature + "(" + inputString + ")"
//    }
//    
//    public func variablesUsed() -> [AnyGPUVariable] {
//        return function.input
//    }
//}

//public class FixedGPUEvaluation<ReturnType: GLSLType>: GPUEvaluation<ReturnType> {
//    private(set) var glslCode: String
//    private(set) var usedVariables: [AnyGPUVariable]
//    
//    init(glslCode: String, usedVariables: [AnyGPUVariable]) {
//        self.glslCode = glslCode
//        self.usedVariables = usedVariables
//        super.init(function: GPUFunction<ReturnType>(signature: "", input: []))
//    }
//    
//    public override func glslRepresentation() -> String {
//        return self.glslCode
//    }
//    
//    public override func variablesUsed() -> [AnyGPUVariable] {
//        return usedVariables
//    }
//    
//}

public class GPUInfixEvaluation<ReturnType: GLSLType>: Evaluation<ReturnType>, GPUInstruction {
    private(set) var operatorSymbol: String
    private(set) var lhs: AnyEvaluation
    private(set) var rhs: AnyEvaluation
    
    init(operatorSymbol: String, lhs: AnyEvaluation, rhs: AnyEvaluation) {
        self.operatorSymbol = operatorSymbol
        self.lhs = lhs
        self.rhs = rhs
    }
    
    public func glslRepresentation() -> String {
        return self.lhs.glslFace() + " " + self.operatorSymbol + " " + self.rhs.glslFace()
    }
    
    public override func glslFace() -> String {
        return glslRepresentation()
    }
}
