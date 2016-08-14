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
        return variable.declaration(access: accessKind, precision: precision)
    }
    
    public func variablesUsed() -> [AnyVariable] {
        return [variable]
    }
}

public class FieldEvaluation<T: GLSLType>: Evaluation<T>, GPUInstruction {
    var evaluation: AnyEvaluation
    var fieldName: String
    
    init(evaluation: AnyEvaluation, fieldName: String) {
        self.evaluation = evaluation
        self.fieldName = fieldName
    }
    
    public override func glslFace() -> String {
        return evaluation.glslFace() + "." + fieldName
    }
    
    public func glslRepresentation() -> String {
        return glslFace()
    }
    
    public func variablesUsed() -> [AnyVariable] {
        return evaluation.variablesUsed()
    }
}

public class ArrayElementEvaluation<T: GLSLType>: Evaluation<T>, GPUInstruction {
    var arrayVariable: IntArrayVariable
    var index: Evaluation<GLSLInt>
    
    init(arrayVariable: IntArrayVariable, index: Evaluation<GLSLInt>) {
        self.arrayVariable = arrayVariable
        self.index = index
    }
    
    public override func glslFace() -> String {
        return "\(arrayVariable.name)[\(index.glslFace())]"
    }
    
    public func glslRepresentation() -> String {
        return glslFace()
    }
    
    public func variablesUsed() -> [AnyVariable] {
        return [arrayVariable] + index.variablesUsed()
    }
}


public struct DiscardInstruction: GPUInstruction {
    public func glslRepresentation() -> String {
        return "discard;"
    }
    public func variablesUsed() -> [AnyVariable] {
        return []
    }
}

public struct ConditionInstruction: GPUInstruction {
    let bool: Evaluation<GLSLBool>
    let successInstructions: [GPUInstruction]
    let failureInstructions: [GPUInstruction]?
    
    init(bool: Evaluation<GLSLBool>, successInstructions: [GPUInstruction], failureInstructions: [GPUInstruction]? = nil) {
        self.bool = bool
        self.successInstructions = successInstructions
        self.failureInstructions = failureInstructions
    }
    
    public func glslRepresentation() -> String {
        var lines: [String] = []
        lines.append("if (\(bool.glslFace())) {")
        lines.appendContentsOf(successInstructions.map{$0.glslRepresentation()})
        if let failureInstructions = failureInstructions {
            lines.append("} else {")
            lines.appendContentsOf(failureInstructions.map{$0.glslRepresentation()})
        }
        lines.append("}")
        return stringFromLines(lines)
    }
    
    public func variablesUsed() -> [AnyVariable] {
        var variablesUsed =  successInstructions.map{$0.variablesUsed()}.stomp()
        if let failureInstructions = failureInstructions {
            variablesUsed.appendContentsOf(failureInstructions.map{$0.variablesUsed()}.stomp())
        }
        variablesUsed.appendContentsOf(bool.variablesUsed())
        return variablesUsed
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
        variables.appendContentsOf(assignment.variablesUsed())
        return variables
    }
}

extension AnyEvaluation {
    public func variablesUsed() -> [AnyVariable] {
        var variables: [AnyVariable] = []
        if let variable = self as? AnyVariable {
            variables.append(variable)
        }
        if let instruction = self as? GPUInstruction {
            variables.appendContentsOf(instruction.variablesUsed())
        }
        return variables
    }
}
