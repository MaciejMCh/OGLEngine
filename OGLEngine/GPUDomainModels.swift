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
}

class GPUAttribute {
    let variable: GPUVariable<Vector>
    let location: GLuint
    func bindLocation(program: GPUProgram) {
        glBindAttribLocation(program.glName, self.location, self.gpuDomainName())
    }
    
    init(variable: GPUVariable<Vector>, location: GLuint) {
        self.variable = variable
        self.location = location
    }
    
    func gpuDomainName() -> String {
        return produceGpuDomainName(self.variable.name, prefix: "a")
    }
}

class GPUUniform {
    let variable: GPUVariable<GPUVariableType>
    var location: GLint = 0
    func bindLocation(program: GPUProgram) {
        self.location = glGetUniformLocation(program.glName, self.gpuDomainName())
    }
    
    init(variable: GPUVariable<GPUVariableType>) {
        self.variable = variable
    }
    
    func gpuDomainName() -> String {
        return produceGpuDomainName(self.variable.name, prefix: "u")
    }
}

func produceGpuDomainName(name: String, prefix: String) -> String {
    let first = name.substringToIndex(name.startIndex.advancedBy(1)).uppercaseString
    let rest = name.substringFromIndex(name.startIndex.advancedBy(1))
    return prefix + first + rest
}


struct GPUVariable<T> {
    let name: String
    let variable: T
}

typealias Dimension = (columns: Int, rows: Int)

protocol GPUVariableType {
    var dimension: Dimension {get}
}

struct GPUTexture : GPUVariableType {
    let dimension = Dimension(1, 1)
}

struct Vector : GPUVariableType {
    let length: Int
    let numberType : GPUNumberType
    var dimension: Dimension {
        get {
            return Dimension(length, 1)
        }
    }
}


struct Matrix : GPUVariableType {
    let size: Int
    var dimension: Dimension {
        get {
            return Dimension(size, size)
        }
    }
}


enum GPUNumberType {
    case float
    case integer
}