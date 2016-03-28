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

struct GPUAttribute {
    let variable: GPUVariable<Vector>
    var location: GLuint = 0
    func getLocation(program: GPUProgram) {
        glGetAttribLocation(program.glName, self.gpuDomainName())
    }
    
    func gpuDomainName() -> String {
        return "a" + self.variable.name.capitalizedString
    }
}

struct GPUUniform {
    let variable: GPUVariable<GPUVariableType>
    var location: GLuint = 0
    func getLocation(program: GPUProgram) {
        glGetUniformLocation(program.glName, self.gpuDomainName())
    }
    
    func gpuDomainName() -> String {
        return "u" + self.variable.name.capitalizedString
    }
}

//typealias GPUAttribute = GPUVariable<Vector>


//typealias GPUUniform = GPUVariable<GPUVariableType>


struct GPUVariable<T> {
    let name: String
    let variable: T
}


protocol GPUVariableType {
    
}

struct GPUTexture : GPUVariableType {
    
}

struct Vector : GPUVariableType {
    let length: Int
    let numberType : GPUNumberType
}


struct Matrix : GPUVariableType {
    let dimension: (Int, Int)
}


enum GPUNumberType {
    case float
    case integer
}