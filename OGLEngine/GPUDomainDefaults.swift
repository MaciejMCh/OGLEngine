//
//  Programs.swift
//  SwiftyProgram
//
//  Created by Maciej Chmielewski on 18.03.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit


enum GPUType {
    case Float
    case Vec2
    case Vec3
    case Mat3
    case Mat4
    case Texture
    case Plane
    
    func variableNamed(name: String) -> AnyGPUVariable {
        switch self {
        case .Float: return TypedGPUVariable<GLSLFloat>(name: name)
        case .Vec2: return TypedGPUVariable<GLSLVec2>(name: name)
        case .Vec3: return TypedGPUVariable<GLSLVec3>(name: name)
        case .Mat3: return TypedGPUVariable<GLSLMat3>(name: name)
        case .Mat4: return TypedGPUVariable<GLSLMat4>(name: name)
        case .Texture: return TypedGPUVariable<GLSLTexture>(name: name)
        case .Plane: return TypedGPUVariable<GLSLPlane>(name: name)
        }
    }
}

protocol GLSLEnum {
    func gpuDomainName() -> String
}

enum Attribute: GLSLEnum {
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
    
    func gpuType() -> GPUType {
        switch self {
        case .Position, .Normal, .TangentMatrixCol1, .TangentMatrixCol2, .TangentMatrixCol3: return .Vec3
        case .Texel: return .Vec3
        }
    }
    
    func gpuDomainName() -> String {
        return gpuDomainNameWithPrefix(self.name(), prefix: "a")
    }
    
    func variable() -> AnyGPUVariable {
        return self.gpuType().variableNamed(self.gpuDomainName())
    }
}

enum Uniform: GLSLEnum {
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
    case TextureScale
    case ReflectionColorMap
    case ClippingPlane
    
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
        case .TextureScale: return "TextureScale"
        case .ReflectionColorMap: return "ReflectionColorMap"
        case .ClippingPlane: return "ClippingPlane"
        }
    }
        
    func gpuType() -> GPUType {
        switch self {
        case .ModelMatrix, .ViewMatrix, .ProjectionMatrix, .ModelViewProjectionMatrix: return .Mat4
        case .NormalMatrix: return .Mat3
        case .EyePosition, .Position, .LightDirection, .LightHalfVector: return .Vec3
        case .TextureScale: return .Float
        case .ColorMap, .NormalMap, .ReflectionColorMap: return .Texture
        case .ClippingPlane: return .Plane
        }
    }
    
    func gpuDomainName() -> String {
        return gpuDomainNameWithPrefix(self.name(), prefix: "u")
    }
    
    func variable() -> AnyGPUVariable {
        return self.gpuType().variableNamed(self.gpuDomainName())
    }
    
}

struct DefaultInterfaces {
    
    static func none() -> GPUInterface {
        return GPUInterface(attributes: [], uniforms: [])
    }
    
    static func detailInterface() -> GPUInterface {
        return GPUInterface(attributes: [.Position, .Texel, .TangentMatrixCol1, .TangentMatrixCol2, .TangentMatrixCol3], uniforms: [.ModelMatrix, .ViewMatrix, .ProjectionMatrix, .NormalMatrix, .EyePosition, .LightDirection, .ColorMap, .NormalMap, .TextureScale])
    }
    
    static func mediumShotInterface() -> GPUInterface {
        return GPUInterface(attributes: [.Position, .Texel, .Normal], uniforms: [.ModelViewProjectionMatrix, .NormalMatrix, .LightDirection, .LightHalfVector, .ColorMap])
    }
    
    static func backgroundInterface() -> GPUInterface {
        return GPUInterface(attributes: [.Position], uniforms: [.ModelViewProjectionMatrix, .LightHalfVector, .ColorMap, .NormalMap])
    }
    
    static func reflectiveInterface() -> GPUInterface {
        return GPUInterface(attributes: [.Position, .Texel], uniforms: [.ModelViewProjectionMatrix, .ReflectionColorMap])
    }
    
    static func reflectedInterface() -> GPUInterface {
        return GPUInterface(attributes: [.Position, .Normal, .Texel], uniforms: [.ModelMatrix, .ViewMatrix, .ProjectionMatrix, .ColorMap, .TextureScale])
    }
    
}

func gpuDomainNameWithPrefix(originalName: String, prefix: String) -> String {
    let first = originalName.substringToIndex(originalName.startIndex.advancedBy(1))
    let rest = originalName.substringFromIndex(originalName.startIndex.advancedBy(1))
    return prefix + first.uppercaseString + rest
}
