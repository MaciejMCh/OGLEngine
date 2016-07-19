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
    func variablesUsed() -> [AnyVariable]
}

public struct FixedGPUInstruction: GPUInstruction {
    let code: String
    let usedVariables: [AnyVariable]
    
    public func glslRepresentation() -> String {
        return code
    }
    
    public func variablesUsed() -> [AnyVariable] {
        return usedVariables
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
    
    public func variablesUsed() -> [AnyVariable] {
        return [variable]
    }
}

public struct GPUAssignment<T: GLSLType>: GPUInstruction {
    let assignee: Variable<T>
    let assignment: Evaluation<T>
    
    public func glslRepresentation() -> String {
        return assignee.name + " = " + assignment.glslFace() + ";"
    }
    
    public func variablesUsed() -> [AnyVariable] {
        var variables: [AnyVariable] = [assignee]
        if let instructionAssignment = assignment as? GPUInstruction {
            variables.appendContentsOf(instructionAssignment.variablesUsed())
        }
        return variables
    }
}
