//
//  SmartPipeline.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 18.07.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

extension GPUPipeline {
    static func smartPipeline(vertexScope vertexScope: GPUScope, fragmentScope: GPUScope) {
        let f = vertexScope.completedAsVertexShaderScope()
    }
}

extension GPUScope {
    func completedAsVertexShaderScope() -> GPUScope {
        let globalScope = GPUScope()
        let mainScope = GPUScope()
        var variables = instructions.map{$0.variablesUsed()}.stomp()
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
            
            switch variable.name.characters.first! {
            case "a": globalScope.appendInstruction(GPUDeclaration(variable: variable, accessKind: .Attribute))
            case "u": globalScope.appendInstruction(GPUDeclaration(variable: variable, accessKind: .Uniform))
            case "v": globalScope.appendInstruction(GPUDeclaration(variable: variable, accessKind: .Varying))
            default: mainScope.appendInstruction(GPUDeclaration(variable: variable, accessKind: .Local))
            }
            declaredVariables.append(variable)
        }
        
        let notDeclarations = instructions.filter{!($0 is GPUDeclaration)}
        for notDeclaration in notDeclarations {
            mainScope.appendInstruction(notDeclaration)
        }
        
        
        globalScope.appendFunction(MainGPUFunction(scope: mainScope))
        
        NSLog("\n" + GLSLParser.scope(self))
        NSLog("\n\n" + GLSLParser.scope(globalScope))
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