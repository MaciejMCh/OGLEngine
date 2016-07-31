//
//  SmartPipeline.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 18.07.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

class SmartPipelineProgram: PipelineProgram {
    typealias RenderableType = CloseShotRenderable
    var glName: GLuint = 0
    var pipeline: GPUPipeline
    
    init(vertexScope: GPUScope, fragmentScope: GPUScope) {
        self.pipeline = GPUPipeline.smartPipeline(vertexScope: vertexScope, fragmentScope: fragmentScope)
    }
}

extension GPUPipeline {
    
    static func smartPipeline(vertexScope vertexScope: GPUScope, fragmentScope: GPUScope) -> GPUPipeline {
        let vertexScope = vertexScope.completedShaderScope()
        let fragmentScope = fragmentScope.completedShaderScope(fixedPrecision: .Low)
        linkScopes(vertexScope: vertexScope, fragmentScope: fragmentScope)
        
        let vertexShader = GPUVertexShader(
            name: "auto linked",
            attributes: GPUAttributesCollection(collection: vertexScope.attributesUsed()),
            uniforms: UniformsCollection(collection: vertexScope.uniformsUsed()),
            interpolation: FixedGPUInterpolation(variables: vertexScope.varyingsUsed()),
            function: MainGPUFunction(scope: vertexScope))
        let fragmentShader = GPUFragmentShader(
            name: "auto linked",
            uniforms: UniformsCollection(collection: fragmentScope.uniformsUsed()),
            interpolation: FixedGPUInterpolation(variables: fragmentScope.varyingsUsed()),
            function: MainGPUFunction(scope: fragmentScope))
        return GPUPipeline(vertexShader: vertexShader, fragmentShader: fragmentShader)
    }
    
    static func linkScopes(vertexScope vertexScope: GPUScope, fragmentScope: GPUScope) {
        let vertexVaryings = vertexScope.varyingsUsed()
        let fragmentVaryings = fragmentScope.varyingsUsed()
        
        let vertexUndeclared = fragmentVaryings.filter{
            for vertexDeclared in vertexVaryings {
                if vertexDeclared.name == $0.name {
                    return false
                }
            }
            return true
        }
        
        for vertexUndeclaredVarying in vertexUndeclared {
            let correspondingUniform = vertexUndeclaredVarying.createUniform()
            vertexScope.appendGlobalDeclaration(vertexUndeclaredVarying, precision: .Low ,accessKind: .Varying)
            vertexScope.appendGlobalDeclaration(correspondingUniform, accessKind: .Uniform)
            vertexScope.appendInstructionToMainFunction(FixedGPUInstruction(code: "\(vertexUndeclaredVarying.name) = \(correspondingUniform.name);", usedVariables: [vertexUndeclaredVarying, correspondingUniform]))
        }
    }
}

struct FixedGPUInterpolation: GPUInterpolation {
    let variables: [AnyVariable]
    
    func varyings() -> [GPUVarying] {
        var varyings: [GPUVarying] = []
        for variable in variables {
            varyings.append(GPUVarying(variable: variable, precision: .Low))
        }
        return varyings
    }
}

extension GPUScope {
    
    func appendGlobalDeclaration(variable: AnyVariable, precision: GPUVariablePrecision? = nil, accessKind: GPUVariableAccessKind) {
        appendInstruction(GPUDeclaration(variable: variable, precision: precision, accessKind: accessKind))
    }
    
    func appendInstructionToMainFunction(instruction: GPUInstruction) {
        for function in functions {
            if function is MainGPUFunction {
                function.scope?.appendInstruction(instruction)
            }
        }
    }
    
    func variablesUsed() -> [AnyVariable] {
        return instructions.map{$0.variablesUsed()}.stomp()
    }

    func attributesUsed() -> [AnyGPUAttribute] {
        return variablesUsed().filter{$0 is AnyGPUAttribute}.map{$0 as! AnyGPUAttribute}
    }

    func uniformsUsed() -> [AnyGPUUniform] {
        let uniformVariables = variablesUsed().filter{
            let secondCharacter = $0.name.substringWithRange($0.name.startIndex.advancedBy(1) ..<  $0.name.startIndex.advancedBy(2))
            if secondCharacter == secondCharacter.uppercaseString {
                if $0.name.characters.first! == "u" {
                    return true
                }
            }
            return false
        }
        let uniforms = uniformVariables.map{$0.createUniform()}
        return uniforms
    }

    func varyingsUsed() -> [AnyVariable] {
        return variablesUsed().filter{$0.name.hasPrefix("v")}
    }
    
    func completedShaderScope(fixedPrecision fixedPrecision: GPUVariablePrecision? = nil) -> GPUScope {
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        let variables = variablesUsed()
        var declaredVariables: [AnyVariable] = []
        
        for variable in variables {
            if variable.name == "gl_Position" {continue}
            if variable.name == "gl_FragColor" {continue}
            
            var isDuplicate = false
            for declaredVariable in declaredVariables {
                if declaredVariable.name == variable.name {
                    isDuplicate = true
                    break
                }
            }
            if isDuplicate {
                continue
            }
            
            let secondCharacter = variable.name.substringWithRange(variable.name.startIndex.advancedBy(1) ..<  variable.name.startIndex.advancedBy(2))
            if secondCharacter == secondCharacter.uppercaseString {
                switch variable.name.characters.first! {
                case "a": globalScope.appendInstruction(GPUDeclaration(variable: variable, accessKind: .Attribute))
                case "u": globalScope.appendInstruction(GPUDeclaration(variable: variable, accessKind: .Uniform))
                case "v": globalScope.appendInstruction(GPUDeclaration(variable: variable, precision: .Low, accessKind: .Varying))
                default: mainScope.appendInstruction(GPUDeclaration(variable: variable, precision: fixedPrecision, accessKind: .Local))
                }
            } else {
                mainScope.appendInstruction(GPUDeclaration(variable: variable, precision: fixedPrecision, accessKind: .Local))
            }
            declaredVariables.append(variable)
        }

        let notDeclarations = instructions.filter{!($0 is GPUDeclaration)}
        for notDeclaration in notDeclarations {
            mainScope.appendInstruction(notDeclaration)
        }
        
        globalScope.appendFunction(MainGPUFunction(scope: mainScope))
        return globalScope
    }
    
}

extension Array {
    func splitingFilter(filteringFunction: (Array.Element -> Bool)) -> (including: Array, excluding: Array) {
        var including: [Array.Element] = []
        var excluding: [Array.Element] = []
        for element in self {
            if filteringFunction(element) {
                including.append(element)
            } else {
                excluding.append(element)
            }
        }
        return (including: including, excluding: excluding)
    }
}

public func + <T>(lhs: Array<T>, rhs: Array<T>) -> Array<T> {
    var merged = lhs
    merged.appendContentsOf(rhs)
    return merged
}
