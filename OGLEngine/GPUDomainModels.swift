//
//  Program.swift
//  SwiftyProgram
//
//  Created by Maciej Chmielewski on 18.03.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit


struct GPUInterface {
    let attributes: [GPUAttribute]
    let uniforms: [GPUUniform]
    
    init(attributes: [Attribute], uniforms: [Uniform]) {
        self.attributes = attributes.map{return $0.gpuVariable()}
        self.uniforms = uniforms.map{return $0.gpuVariable()}
    }
}

class GPUAttribute {
    let variable: GPUVariable<Vector>
    let location: GLuint
    func bindLocation(programGLName: GLuint) {
        glBindAttribLocation(programGLName, self.location, self.gpuDomainName())
    }
    
    init(variable: GPUVariable<Vector>, location: GLuint) {
        self.variable = variable
        self.location = location
    }
    
    func gpuDomainName() -> String {
        return produceGpuDomainName(self.variable.name, prefix: "a")
    }
}

class UniformInstance {
    var type: ProcessingUnitType
    var uniform: Uniform!
    var location: GLint = 0
    
    init() {
        
    }
    
    func bindLocation(programGLName: GLuint) {
        self.location = glGetUniformLocation(programGLName, self.gpuDomainName())
    }
    
    
    
//    init(variable: GPUVariable<GPUVariableType>) {
//        self.variable = variable
//    }
    
    func gpuDomainName() -> String {
        return produceGpuDomainName(self.uniform.name(), prefix: "u")
    }
}

func produceGpuDomainName(name: String, prefix: String) -> String {
    let first = name.substringToIndex(name.startIndex.advancedBy(1)).uppercaseString
    let rest = name.substringFromIndex(name.startIndex.advancedBy(1))
    return prefix + first + rest
}

enum GPUType {
    case Float
    case Vec2
    case Vec3
    case Mat3
    case Mat4
    case Texture
}

typealias Dimension = (columns: Int, rows: Int)

protocol ProcessingUnitType {
    associatedtype CPUType
    var gpuType: GPUType {get}
    var dimension: Dimension {get}
}

struct PUVector2: ProcessingUnitType {
    typealias CPUType = GLKVector2
    let gpuType: GPUType = .Vec2
    let dimension: Dimension = Dimension(2, 1)
}

struct PUVector3: ProcessingUnitType {
    typealias CPUType = GLKVector3
    let gpuType: GPUType = .Vec3
    let dimension: Dimension = Dimension(3, 1)
}

struct PUMatrix3: ProcessingUnitType {
    typealias CPUType = GLKMatrix3
    let gpuType: GPUType = .Mat3
    let dimension: Dimension = Dimension(3, 3)
}

struct PUMatrix4: ProcessingUnitType {
    typealias CPUType = GLKMatrix4
    let gpuType: GPUType = .Mat4
    let dimension: Dimension = Dimension(4, 4)
}
