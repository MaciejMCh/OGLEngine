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
    static func vertexShader(vertexShader: VertexShader) -> String {
        return stringFromLines([
            "",
            "// Auto generated code",
            "// Vertex shader",
            "// " + vertexShader.name,
            "",
            GLSLParser.scope(vertexShader.function.scope)
            ])
    }
    
    static func fragmentShader(fragmentShader: FragmentShader) -> String {
        return stringFromLines([
            "",
            "// Auto generated code",
            "// Fragment shader",
            "// " + fragmentShader.name,
            "",
            GLSLParser.scope(fragmentShader.function.scope)
            ])
    }
    
    static func scope(scope: GPUScope) -> String {
        var instructionLines: [String] = []
        for instruction in scope.instructions {
            instructionLines.append(instruction.glslRepresentation())
        }
        return stringFromLines(instructionLines)
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
        case is TypedGPUFunction<Void>: return "void"
        case is TypedGPUFunction<GLKVector3>: return "vec3"
        default:
            assert(false)
            return "unsupported type"
        }
    }
    
    static func variableType(variable: AnyGPUVariable) -> String {
        switch variable {
        case is TypedGPUVariable<GLSLVoid>: return "void"
        case is TypedGPUVariable<GLSLInt>: return "int"
        case is TypedGPUVariable<GLSLFloat>: return "float"
            
        case is TypedGPUVariable<GLSLVec2>: return "vec2"
        case is TypedGPUVariable<GLSLVec3>: return "vec3"
        case is TypedGPUVariable<GLSLVec4>: return "vec4"
        
        case is TypedGPUVariable<GLSLMat3>: return "mat3"
        case is TypedGPUVariable<GLSLMat4>: return "mat4"
        
        case is TypedGPUVariable<GLSLColor>: return "vec4"
        case is TypedGPUVariable<GLSLTexture>: return "sampler2D"
            
        default:
            assert(false)
            return "unsupported type"
        }
    }
    
    static func gpuType(type: GPUType) -> String {
        switch type {
        case .Mat3: return "mat3"
        case .Mat4: return "mat4"
        case .Vec2: return "vec2"
        case .Vec3: return "vec3"
        case .Vec4: return "vec4"
        case .Float: return "float"
        case .Texture: return "sampler2D"
        case .Plane: return "vec4"
        }
    }
    
    static func precision(precision: VariablePrecision) -> String {
        switch precision {
        case .Low: return "lowp"
        case .High: return "highp"
        }
    }
    
    static func attributesDeclaration(attributes: [Attribute]) -> String {
        var string = ""
        
        for attribute in attributes {
            string = string + "attribute " + GLSLParser.gpuType(attribute.gpuType()) + " " + attribute.gpuDomainName() + ";\n"
        }
        
        return string
    }
    
    static func uniformsDeclaration(uniforms: [Uniform]) -> String {
        var string = ""
        
        for uniform in uniforms {
            string = string + "uniform " + GLSLParser.gpuType(uniform.gpuType()) + " " + uniform.gpuDomainName() + ";\n"
        }
        
        return string
    }
}