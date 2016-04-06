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
        return GPUAttribute(variable: GPUVariable(name: "texel", variable: Vector(length: 2, numberType: .float)), location: 1);
    }
    
    static func normal() -> GPUAttribute {
        return GPUAttribute(variable: GPUVariable(name: "normal", variable: Vector(length: 3, numberType: .float)), location: 2);
    }
    
    static func tangentMatrixCol1() -> GPUAttribute {
        return GPUAttribute(variable: GPUVariable(name: "tangentMatrixCol1", variable: Vector(length: 3, numberType: .float)), location: 3);
    }
    static func tangentMatrixCol2() -> GPUAttribute {
        return GPUAttribute(variable: GPUVariable(name: "tangentMatrixCol2", variable: Vector(length: 3, numberType: .float)), location: 4);
    }
    static func tangentMatrixCol3() -> GPUAttribute {
        return GPUAttribute(variable: GPUVariable(name: "tangentMatrixCol3", variable: Vector(length: 3, numberType: .float)), location: 5);
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
}

struct DefaultGPUUniforms {
    
    static func modelMatrix() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: UniformName.modelMatrix.rawValue, variable: Matrix(size: 4)))
    }
    
    static func viewMatrix() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: UniformName.viewMatrix.rawValue, variable: Matrix(size: 4)))
    }
    
    static func projectionMatrix() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: UniformName.projectionMatrix.rawValue, variable: Matrix(size: 4)))
    }
    
    static func modelViewProjectionMatrix() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: UniformName.modelViewProjectionMatrix.rawValue, variable: Matrix(size: 4)))
    }
    
    static func normalMatrix() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: UniformName.normalMatrix.rawValue, variable: Matrix(size: 3)))
    }
    
    static func eyePosition() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: UniformName.eyePosition.rawValue, variable: Vector(length: 3, numberType: .float)))
    }
    
    static func position() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: UniformName.position.rawValue, variable: Vector(length: 3, numberType: .float)))
    }
    
    static func lightDirection() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: UniformName.lightDirection.rawValue, variable: Vector(length: 3, numberType: .float)))
    }
    
    static func lightHalfVector() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: UniformName.lightHalfVector.rawValue, variable: Vector(length: 3, numberType: .float)))
    }
    
    static func colorMap() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: UniformName.colorMap.rawValue, variable: GPUTexture()))
    }
    
    static func normalMap() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: UniformName.normalMap.rawValue, variable: GPUTexture()))
    }
    
}


struct DefaultInterfaces {
    
    static func none() -> GPUInterface {
        return GPUInterface(attributes: [], uniforms: [])
    }
    
    static func detailInterface() -> GPUInterface {
        let GPUAttributes: [GPUAttribute] = [
            DefaultGPUAttributes.position(),
            DefaultGPUAttributes.texel(),
            DefaultGPUAttributes.normal(),
            DefaultGPUAttributes.tangentMatrixCol1(),
            DefaultGPUAttributes.tangentMatrixCol2(),
            DefaultGPUAttributes.tangentMatrixCol3()
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
        let GPUAttributes: [GPUAttribute] = [
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