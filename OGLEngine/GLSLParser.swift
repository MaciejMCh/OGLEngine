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
            "// Attributes",
            GLSLParser.attributesDeclaration(vertexShader.attributes),
            "// Uniforms",
            GLSLParser.uniformsDeclaration(vertexShader.uniforms),
            "// Varyings",
            GLSLParser.varyingsDeclaration(vertexShader.varyings),
            GLSLParser.functionDeclaration(vertexShader.function),
            GLSLParser.scope(vertexShader.function.scope),
            "}"
            ])
    }
    
    static func scope(scope: GPUScope) -> String {
        return ""
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
        case is TypedGPUVariable<Void>: return "void"
        case is TypedGPUVariable<GLKVector3>: return "vec3"
        case is TypedGPUVariable<Int>: return "int"
        default:
            assert(false)
            return "unsupported type"
        }
    }
    
    static func gpuType(type: GPUType) -> String {
        switch type {
        case .Mat3: return "mat3"
        case .Mat4: return "mat4"
        case .Vec3: return "vec3"
        case .Vec2: return "vec2"
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
    
    static func varyingsDeclaration(varyings: [GPUVarying]) -> String {
        var string = ""
        
        for varying in varyings {
            string = string + "varying " + GLSLParser.precision(varying.precision) + " " + GLSLParser.gpuType(varying.type) + " " + varying.variable.name! + ";\n"
        }
        
        return string
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