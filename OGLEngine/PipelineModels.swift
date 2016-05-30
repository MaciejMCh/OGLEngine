//
//  PipelineModels.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 22.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

public protocol Interpolation {
    func varyings() -> [GPUVarying]
}

public enum VariablePrecision {
    case Low
    case High
}

public enum VariableAccessKind {
    case Attribute
    case Uniform
    case Varying
    case Local
}

public struct GPUVarying {
    let variable: AnyGPUVariable
    let precision: VariablePrecision
}

public protocol Shader {
    var name: String {get}
    var interpolation: Interpolation {get}
    var function: TypedGPUFunction<GLSLVoid> {get}
}

public struct FragmentShader: Shader {
    public let name: String
    let uniforms: GLSLVariableCollection<AnyGPUUniform>
    public let interpolation: Interpolation
    public let function: TypedGPUFunction<GLSLVoid>
}

public struct VertexShader: Shader {
    public let name: String
    let attributes: GLSLVariableCollection<GPUAttribute>
    let uniforms: GLSLVariableCollection<AnyGPUUniform>
    public let interpolation: Interpolation
    public let function: TypedGPUFunction<GLSLVoid>
}

public struct GPUPipeline {
    let vertexShader: VertexShader
    let fragmentShader: FragmentShader
    
    func uniform<T>(variable: TypedGPUVariable<T>) -> GPUUniform<T>! {
        for uniform in vertexShader.uniforms.collection {
            if uniform.glslName == variable.glslName {
                return uniform as! GPUUniform<T>
            }
        }
        return nil
    }
}

public class GPUScope {
    var instructions: [GPUInstruction] = []
    
    func appendInstruction(instruction: GPUInstruction) {
        self.instructions.append(instruction)
    }
    
    func mergeScope(scope: GPUScope) {
        var mergedInstructions: [GPUInstruction] = []
        mergedInstructions.appendContentsOf(self.instructions)
        mergedInstructions.appendContentsOf(scope.instructions)
        self.instructions = mergedInstructions
    }
}

// MARK: Variable
public protocol GPUVariable {
    associatedtype UnderlyingType
}

public class AnyGPUVariable: GPUVariable {
    public typealias UnderlyingType = Any
    private(set) var name: String?
    
    init(name: String? = nil) {
        self.name = name
    }
}

extension AnyGPUVariable: GLSLRepresentable {
    var glslName: String {
        get {
            return self.name!
        }
    }
}

public class TypedGPUVariable<T: GLSLType>: AnyGPUVariable {
    public typealias UnderlyingType = T
    
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

// MARK: Function
public protocol GPUFunction {
    associatedtype ReturnType
}

public class AnyGPUFunction: GPUFunction {
    public typealias ReturnType = GLSLVoid
    
    var signature: String
    var input: [AnyGPUVariable]
    var scope : GPUScope
    
    public init() {
        self.signature = "error"
        self.input = []
        self.scope = GPUScope()
    }
    
    public init(signature: String, input: [AnyGPUVariable], output: TypedGPUVariable<ReturnType>, scope: GPUScope) {
        self.signature = signature
        self.input = input
        self.scope = scope
    }
    
    public func outputVariable() -> TypedGPUVariable<ReturnType> {
        return TypedGPUVariable<ReturnType>()
    }
}

public class TypedGPUFunction<T: GLSLType>: AnyGPUFunction {
    typealias ReturnType = T
    
    override init() {
        super.init()
    }
    
    init(signature: String, input: [AnyGPUVariable], scope: GPUScope) {
        super.init()
        self.signature = signature
        self.input = input
        self.scope = scope
    }
    
    init(input: [AnyGPUVariable], output: TypedGPUVariable<T>, scope: GPUScope) {
        super.init()
    }
    
    public func GGoutputVariable() -> TypedGPUVariable<T> {
        return TypedGPUVariable<T>()
    }
}

public class ShaderFunction: TypedGPUFunction<GLSLVoid> {
    init(scope: GPUScope) {
        super.init(signature: "main", input: [], scope: scope)
    }
}

public class StandardGPUFunction<T: GLSLType>: TypedGPUFunction<T> {
    init(name: String, input: [AnyGPUVariable]) {
        super.init()
        self.signature = name
        self.input = input
    }
}

// Instruction

public protocol GPUInstruction {
    func glslRepresentation() -> String
}

public struct GPUFunctionBody<T: GLSLType>: GPUInstruction {
    let function: TypedGPUFunction<T>
    let childScope: GPUScope
    
    public func glslRepresentation() -> String {
        return stringFromLines([
            GLSLParser.functionDeclaration(self.function),
            GLSLParser.scope(self.childScope),
            "}"])
    }
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
    let assignee: TypedGPUVariable<T>
    let assignment: TypedGPUVariable<T>
    
    public func glslRepresentation() -> String {
        return assignee.name! + " = " + assignment.name! + ";"
    }
}

public class GPUEvaluation<ReturnType: GLSLType>: GPUInstruction {
    private(set) var function: TypedGPUFunction<ReturnType>
    
    init(function: TypedGPUFunction<ReturnType>) {
        self.function = function
    }
    
    func variable() -> TypedGPUVariable<ReturnType> {
        return TypedGPUVariable<ReturnType>(name: "")
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
        super.init(function: TypedGPUFunction<ReturnType>())
    }
    
    public override func glslRepresentation() -> String {
        return self.lhs.name! + " " + self.operatorSymbol + " " + self.rhs.name!
    }
}

public struct GPUEvaluationAssignment<T: GLSLType>: GPUInstruction {
    let assignee: TypedGPUVariable<T>
    let assignment: GPUEvaluation<T>
    
    public func glslRepresentation() -> String {
        return self.assignee.name! + " = " + self.assignment.glslRepresentation() + ";"
    }
}
