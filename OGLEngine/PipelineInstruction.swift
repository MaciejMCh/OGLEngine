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

public struct GPUDeclaration: GPUInstruction {
    let variable: AnyGPUVariable
    let precision: VariablePrecision?
    let accessKind: VariableAccessKind
    
    init(variable: AnyGPUVariable, precision: VariablePrecision? = nil, accessKind: VariableAccessKind = .Local) {
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
        let name = self.variable.name!
        var result = access + " " + precision + " " + type + " " + name + ";"
        
        // Trim
        result = result.stringByReplacingOccurrencesOfString("   ", withString: " ")
        result = result.stringByReplacingOccurrencesOfString("  ", withString: " ")
        result = result.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        return result
    }
}

public struct GPUAssignment<T: GLSLType>: GPUInstruction {
    let assignee: GPUVariable<T>
    let assignment: GPUVariable<T>
    
    public func glslRepresentation() -> String {
        return assignee.name! + " = " + assignment.name! + ";"
    }
}

public class GPUEvaluation<ReturnType: GLSLType>: GPUInstruction {
    private(set) var function: GPUFunction<ReturnType>
    
    init(function: GPUFunction<ReturnType>) {
        self.function = function
    }
    
    func variable() -> GPUVariable<ReturnType> {
        return GPUVariable<ReturnType>(name: "")
    }
    
    public func glslRepresentation() -> String {
        var inputString = ""
        for argument in self.function.input {
            inputString = inputString + argument.name! + ", "
        }
        if inputString.characters.count >= 2 {
            inputString = inputString.substringToIndex(inputString.endIndex.advancedBy(-2))
        }
        return self.function.signature + "(" + inputString + ")"
    }
}

public class GPUInfixEvaluation<ReturnType: GLSLType>: GPUEvaluation<ReturnType> {
    private(set) var operatorSymbol: String
    private(set) var lhs: AnyGPUVariable
    private(set) var rhs: AnyGPUVariable
    
    init(operatorSymbol: String, lhs: AnyGPUVariable, rhs: AnyGPUVariable) {
        self.operatorSymbol = operatorSymbol
        self.lhs = lhs
        self.rhs = rhs
        super.init(function: GPUFunction<ReturnType>(signature: operatorSymbol, input: [lhs, rhs]))
    }
    
    public override func glslRepresentation() -> String {
        return self.lhs.name! + " " + self.operatorSymbol + " " + self.rhs.name!
    }
}

public struct GPUEvaluationAssignment<T: GLSLType>: GPUInstruction {
    let assignee: GPUVariable<T>
    let assignment: GPUEvaluation<T>
    
    public func glslRepresentation() -> String {
        return self.assignee.name! + " = " + self.assignment.glslRepresentation() + ";"
    }
}