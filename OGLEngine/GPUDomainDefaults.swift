//
//  Programs.swift
//  SwiftyProgram
//
//  Created by Maciej Chmielewski on 18.03.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

enum Attribute {
    case Position
    case Texel
    case Normal
    case TangentMatrixCol1
    case TangentMatrixCol2
    case TangentMatrixCol3
    
    func name() -> String {
        switch self {
        case .Position: return "position"
        case .Texel: return "texel"
        case .Normal: return "normal"
        case .TangentMatrixCol1: return "tangentMatrixCol1"
        case .TangentMatrixCol2: return "tangentMatrixCol2"
        case .TangentMatrixCol3: return "tangentMatrixCol3"
        }
    }
    
    func location() -> GLuint {
        switch self {
        case .Position: return 0
        case .Texel: return 1
        case .Normal: return 2
        case .TangentMatrixCol1: return 3
        case .TangentMatrixCol2: return 4
        case .TangentMatrixCol3: return 5
        }
    }
    
    func size() -> Int {
        switch self {
        case .Position: return 3
        case .Texel: return 2
        case .Normal: return 3
        case .TangentMatrixCol1: return 3
        case .TangentMatrixCol2: return 3
        case .TangentMatrixCol3: return 3
        }
    }
    
    func gpuVariable() -> GPUAttribute {
        return GPUAttribute(variable: GPUVariable(name: self.name(), variable: Vector(length: self.size(), numberType: .float)), location: self.location());
    }
}

enum Uniform {
    case ModelMatrix
    case ViewMatrix
    case ProjectionMatrix
    case ModelViewProjectionMatrix
    case NormalMatrix
    case EyePosition
    case Position
    case LightDirection
    case LightHalfVector
    case ColorMap
    case NormalMap
    
    func name() -> String {
        switch self {
        case .ModelMatrix: return "modelMatrix"
        case .ViewMatrix: return "viewMatrix"
        case .ProjectionMatrix: return "projectionMatrix"
        case .ModelViewProjectionMatrix: return "modelViewProjectionMatrix"
        case .NormalMatrix: return "normalMatrix"
        case .EyePosition: return "eyePosition"
        case .Position: return "position"
        case .LightDirection: return "lightDirection"
        case .LightHalfVector: return "lightHalfVector"
        case .ColorMap: return "colorMap"
        case .NormalMap: return "NormalMap"
        }
    }
        
    func gpuVariable() -> GPUUniform {
        switch self {
        case .ModelMatrix, .ViewMatrix, .ProjectionMatrix, .ModelViewProjectionMatrix: return GPUUniform(variable: GPUVariable(name: self.name(), variable: Matrix(size: 4)))
        case .NormalMatrix: return GPUUniform(variable: GPUVariable(name: self.name(), variable: Matrix(size: 3)))
        case .EyePosition, .Position, .LightDirection, .LightHalfVector: return GPUUniform(variable: GPUVariable(name: self.name(), variable: Vector(length: 3, numberType: .float)))
        case .ColorMap, .NormalMap: return GPUUniform(variable: GPUVariable(name: self.name(), variable: GPUTexture()))
        }
    }
    
}

struct DefaultInterfaces {
    
    static func none() -> GPUInterface {
        return GPUInterface(attributes: [], uniforms: [])
    }
    
    static func detailInterface() -> GPUInterface {
        return GPUInterface(attributes: [.Position, .Texel, .Normal, .TangentMatrixCol1, .TangentMatrixCol2, .TangentMatrixCol3], uniforms: [.ModelMatrix, .ViewMatrix, .ProjectionMatrix, .NormalMatrix, .EyePosition, .LightDirection, .ColorMap, .NormalMap])
    }
    
    static func backgroundInterface() -> GPUInterface {
        return GPUInterface(attributes: [.Position], uniforms: [.ModelViewProjectionMatrix, .LightHalfVector, .ColorMap, .NormalMap])
    }
    
}

extension Array {
    
    func uniformNamed(uniform: Uniform) -> GPUUniform! {
        for element in self {
            if let element = element as? GPUUniform {
                if element.variable.name == uniform.name() {
                    return element
                }
            }
        }
        return nil
    }
    
}