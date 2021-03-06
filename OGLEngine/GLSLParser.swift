//
//  GLSLParser.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 22.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

func stringFromLines(lines: [String]) -> String {
    guard lines.count > 0 else {
        return ""
    }
    var result = ""
    
    for line in lines {
        result = result + line + "\n"
    }
    
    return result
}

struct GLSLParser {
    static func vertexShader(vertexShader: GPUVertexShader) -> String {
        return stringFromLines([
            "",
            "// Auto generated code",
            "// Vertex shader",
            "// " + vertexShader.name,
            "",
            GLSLParser.scope(vertexShader.function.scope!)
            ])
    }
    
    static func fragmentShader(fragmentShader: GPUFragmentShader) -> String {
        return stringFromLines([
            "",
            "// Auto generated code",
            "// Fragment shader",
            "// " + fragmentShader.name,
            "",
            GLSLParser.scope(fragmentShader.function.scope!)
            ])
    }
    
    static func scope(scope: GPUScope) -> String {
        var instructionLines: [String] = []
        for instruction in scope.instructions {
            instructionLines.append(instruction.glslRepresentation())
        }
        
        var functionDeclarationStrings: [String] = []
        for function in scope.functions {
            functionDeclarationStrings.append(GLSLParser.function(function))
        }
        
        return stringFromLines(instructionLines + functionDeclarationStrings)
    }
    
    static func function(function: AnyGPUFunction) -> String {
        return stringFromLines([
            functionDeclaration(function),
            scope(function.scope!),
            "}"
            ])
    }
    
    static func functionDeclaration(function: AnyGPUFunction) -> String {
        return GLSLParser.functionType(function) + " " + function.signature + "(" + GLSLParser.argumentsDeclaration(function.input) + ")" + " {"
    }
    
    static func argumentsDeclaration(arguments: [AnyGPUVariable]) -> String {
        var string = ""
        for argument in arguments {
            string = string + GLSLParser.variableType(argument) + " " + argument.name! + ", "
        }
        if (string.characters.count >= 2) {
            string = string.substringToIndex(string.endIndex.advancedBy(-2))
        }
        return string
    }
    
    static func functionType(function: AnyGPUFunction) -> String {
        switch function {
        case is GPUFunction<GLSLVoid>: return "void"
        case is GPUFunction<GLSLVec3>: return "vec3"
        default:
            assert(false)
            return "unsupported type"
        }
    }
    
    static func variableType(variable: AnyGPUVariable) -> String {
        switch variable {
        case is GPUVariable<GLSLVoid>: return "void"
        case is GPUVariable<GLSLInt>: return "int"
        case is GPUVariable<GLSLFloat>: return "float"
            
        case is GPUVariable<GLSLVec2>: return "vec2"
        case is GPUVariable<GLSLVec3>: return "vec3"
        case is GPUVariable<GLSLVec4>: return "vec4"
        
        case is GPUVariable<GLSLMat3>: return "mat3"
        case is GPUVariable<GLSLMat4>: return "mat4"
        
        case is GPUVariable<GLSLColor>: return "vec4"
        case is GPUVariable<GLSLTexture>: return "sampler2D"
            
        default:
            assert(false)
            return "unsupported type"
        }
    }
    
    static func precision(precision: GPUVariablePrecision) -> String {
        switch precision {
        case .Low: return "lowp"
        case .High: return "highp"
        }
    }
    
}