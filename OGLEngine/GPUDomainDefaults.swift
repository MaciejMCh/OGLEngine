//
//  Programs.swift
//  SwiftyProgram
//
//  Created by Maciej Chmielewski on 18.03.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

struct DefaultGPUAttributes {
    
    static func position() -> GPUAttribute {
        return GPUAttribute(variable: GPUVariable(name: "position", variable: Vector(length: 3, numberType: .float)), location: 0);
    }
    
    static func texel() -> GPUAttribute {
        return GPUAttribute(variable: GPUVariable(name: "texel", variable: Vector(length: 2, numberType: .float)), location: 0);
    }
    
    static func normal() -> GPUAttribute {
        return GPUAttribute(variable: GPUVariable(name: "normal", variable: Vector(length: 3, numberType: .float)), location: 0);
    }
    
    static func tangent() -> GPUAttribute {
        return GPUAttribute(variable: GPUVariable(name: "tangent", variable: Vector(length: 3, numberType: .float)), location: 0);
    }
    
    static func bitangent() -> GPUAttribute {
        return GPUAttribute(variable: GPUVariable(name: "bitangent", variable: Vector(length: 3, numberType: .float)), location: 0);
    }
    
}

enum UniformName: String {
    case modelMatrix = "modelMatrix"
    case viewMatrix = "viewMatrix"
    case projectionMatrix = "projectionMatrix"
    case modelViewProjectionMatrix = "modelViewProjectionMatrix"
    case normalMatrix = "normalMatrix"
    case eyePosition = "eyePosition"
    case position = "position"
    case lightDirection = "lightDirection"
    case lightHalfVector = "lightHalfVector"
    case colorMap = "colorMap"
    case normalMap = "normalMap"
    case tangent = "tangent"
    case bitangent = "bitangent"
}

struct DefaultGPUUniforms {
    
    static func modelMatrix() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: UniformName.modelMatrix.rawValue, variable: Matrix(dimension: (4, 4))), location: 0)
    }
    
    static func viewMatrix() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: UniformName.viewMatrix.rawValue, variable: Matrix(dimension: (4, 4))), location: 0)
    }
    
    static func projectionMatrix() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: UniformName.projectionMatrix.rawValue, variable: Matrix(dimension: (4, 4))), location: 0)
    }
    
    static func modelViewProjectionMatrix() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: UniformName.modelViewProjectionMatrix.rawValue, variable: Matrix(dimension: (4, 4))), location: 0)
    }
    
    static func normalMatrix() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: UniformName.normalMatrix.rawValue, variable: Matrix(dimension: (3, 3))), location: 0)
    }
    
    static func eyePosition() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: UniformName.eyePosition.rawValue, variable: Vector(length: 3, numberType: .float)), location: 0)
    }
    
    static func position() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: UniformName.position.rawValue, variable: Vector(length: 3, numberType: .float)), location: 0)
    }
    
    static func lightDirection() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: UniformName.lightDirection.rawValue, variable: Vector(length: 3, numberType: .float)), location: 0)
    }
    
    static func lightHalfVector() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: UniformName.lightHalfVector.rawValue, variable: Vector(length: 3, numberType: .float)), location: 0)
    }
    
    static func colorMap() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: UniformName.colorMap.rawValue, variable: GPUTexture()), location: 0)
    }
    
    static func normalMap() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: UniformName.normalMap.rawValue, variable: GPUTexture()), location: 0)
    }
    
    static func tangent() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: UniformName.tangent.rawValue, variable: Vector(length: 3, numberType: .float)), location: 0);
    }
    
    static func bitangent() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: UniformName.bitangent.rawValue, variable: Vector(length: 3, numberType: .float)), location: 0);
    }
    
}


struct DefaultInterfaces {
    
    static func none() -> GPUInterface {
        return GPUInterface(attributes: [], uniforms: [])
    }
    
    static func detailInterface() -> GPUInterface {
        let GPUAttributes = [
            DefaultGPUAttributes.position(),
            DefaultGPUAttributes.texel(),
            DefaultGPUAttributes.normal(),
            DefaultGPUAttributes.tangent(),
            DefaultGPUAttributes.bitangent()
        ]
        let GPUUniforms = [
            DefaultGPUUniforms.modelMatrix(),
            DefaultGPUUniforms.viewMatrix(),
            DefaultGPUUniforms.projectionMatrix(),
            DefaultGPUUniforms.normalMatrix(),
            DefaultGPUUniforms.eyePosition(),
            DefaultGPUUniforms.lightDirection(),
            DefaultGPUUniforms.colorMap(),
            DefaultGPUUniforms.normalMap()
        ]
        return GPUInterface(attributes: GPUAttributes, uniforms: GPUUniforms)
    }
    
    static func backgroundInterface() -> GPUInterface {
        let GPUAttributes = [
            DefaultGPUAttributes.position()
        ]
        let GPUUniforms = [
            DefaultGPUUniforms.modelViewProjectionMatrix(),
            DefaultGPUUniforms.lightHalfVector(),
            DefaultGPUUniforms.colorMap(),
            DefaultGPUUniforms.normalMap(),
        ]
        return GPUInterface(attributes: GPUAttributes, uniforms: GPUUniforms)
    }
    
}

extension Array {
    
    func uniformNamed(uniformName: UniformName) -> GPUUniform! {
        for element in self {
            if let element = element as? GPUUniform {
                if element.variable.name == uniformName.rawValue {
                    return element
                }
            }
        }
        return nil
    }
    
}