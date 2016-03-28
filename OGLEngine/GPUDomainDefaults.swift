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


struct DefaultGPUUniforms {
    
    static func modelMatrix() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: "modelMatrix", variable: Matrix(dimension: (4, 4))), location: 0)
    }
    
    static func viewMatrix() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: "viewMatrix", variable: Matrix(dimension: (4, 4))), location: 0)
    }
    
    static func projectionMatrix() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: "modelMatrix", variable: Matrix(dimension: (4, 4))), location: 0)
    }
    
    static func modelViewProjectionMatrix() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: "modelViewProjectionMatrix", variable: Matrix(dimension: (4, 4))), location: 0)
    }
    
    static func normalMatrix() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: "normalMatrix", variable: Matrix(dimension: (3, 3))), location: 0)
    }
    
    static func eyePosition() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: "eyePosition", variable: Vector(length: 3, numberType: .float)), location: 0)
    }
    
    static func position() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: "position", variable: Vector(length: 3, numberType: .float)), location: 0)
    }
    
    static func lightDirection() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: "lightDirection", variable: Vector(length: 3, numberType: .float)), location: 0)
    }
    
    static func lightHalfVector() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: "lightHalfVector", variable: Vector(length: 3, numberType: .float)), location: 0)
    }
    
    static func colorMap() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: "colorMap", variable: GPUTexture()), location: 0)
    }
    
    static func normalMap() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: "normalMap", variable: GPUTexture()), location: 0)
    }
    
    static func tangent() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: "tangent", variable: Vector(length: 3, numberType: .float)), location: 0);
    }
    
    static func bitangent() -> GPUUniform {
        return GPUUniform(variable: GPUVariable(name: "bitangent", variable: Vector(length: 3, numberType: .float)), location: 0);
    }
    
}


struct DefaultInterfaces {
    
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
