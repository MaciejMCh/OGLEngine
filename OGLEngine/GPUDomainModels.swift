//
//  Program.swift
//  SwiftyProgram
//
//  Created by Maciej Chmielewski on 18.03.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

struct GPUProgram {
    let interface: GPUInterface
}


struct GPUInterface {
    let attributes: [GPUAttribute]
    let uniforms: [GPUUniform]
}


typealias GPUAttribute = GPUVariable<Vector>


typealias GPUUniform = GPUVariable<GPUVariableType>


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