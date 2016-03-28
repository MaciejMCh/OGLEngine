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
        return GPUAttribute(name: "position", variable: Vector(length: 3, numberType: .float));
    }
    
    static func texel() -> GPUAttribute {
        return GPUAttribute(name: "texel", variable: Vector(length: 2, numberType: .float));
    }
    
    static func normal() -> GPUAttribute {
        return GPUAttribute(name: "normal", variable: Vector(length: 3, numberType: .float));
    }
    
    static func tangent() -> GPUAttribute {
        return GPUAttribute(name: "tangent", variable: Vector(length: 3, numberType: .float));
    }
    
    static func bitangent() -> GPUAttribute {
        return GPUAttribute(name: "bitangent", variable: Vector(length: 3, numberType: .float));
    }
    
}


struct DefaultGPUUniforms {
    
    static func modelMatrix() -> GPUUniform {
        return GPUUniform(name: "modelMatrix", variable: Matrix(dimension: (4, 4)))
    }
    
    static func viewMatrix() -> GPUUniform {
        return GPUUniform(name: "viewMatrix", variable: Matrix(dimension: (4, 4)))
    }
    
    static func projectionMatrix() -> GPUUniform {
        return GPUUniform(name: "modelMatrix", variable: Matrix(dimension: (4, 4)))
    }
    
    static func modelViewProjectionMatrix() -> GPUUniform {
        return GPUUniform(name: "modelViewProjectionMatrix", variable: Matrix(dimension: (4, 4)))
    }
    
    static func normalMatrix() -> GPUUniform {
        return GPUUniform(name: "normalMatrix", variable: Matrix(dimension: (3, 3)))
    }
    
    static func eyePosition() -> GPUUniform {
        return GPUUniform(name: "eyePosition", variable: Vector(length: 3, numberType: .float))
    }
    
    static func position() -> GPUUniform {
        return GPUUniform(name: "position", variable: Vector(length: 3, numberType: .float))
    }
    
    static func lightDirection() -> GPUUniform {
        return GPUUniform(name: "lightDirection", variable: Vector(length: 3, numberType: .float))
    }
    
    static func lightHalfVector() -> GPUUniform {
        return GPUUniform(name: "lightHalfVector", variable: Vector(length: 3, numberType: .float))
    }
    
    static func colorMap() -> GPUUniform {
        return GPUUniform(name: "colorMap", variable: GPUTexture())
    }
    
    static func normalMap() -> GPUUniform {
        return GPUUniform(name: "normalMap", variable: GPUTexture())
    }
    
    static func tangent() -> GPUUniform {
        return GPUUniform(name: "tangent", variable: Vector(length: 3, numberType: .float));
    }
    
    static func bitangent() -> GPUUniform {
        return GPUUniform(name: "bitangent", variable: Vector(length: 3, numberType: .float));
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
