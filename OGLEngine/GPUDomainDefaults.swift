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
    case Vec4
    case Mat3
    case Mat4
    case Texture
    case Plane
    
    func variableNamed(name: String) -> AnyGPUVariable {
        switch self {
        case .Float: return GPUVariable<GLSLFloat>(name: name)
        case .Vec2: return GPUVariable<GLSLVec2>(name: name)
        case .Vec3: return GPUVariable<GLSLVec3>(name: name)
        case .Vec4: return GPUVariable<GLSLVec4>(name: name)
        case .Mat3: return GPUVariable<GLSLMat3>(name: name)
        case .Mat4: return GPUVariable<GLSLMat4>(name: name)
        case .Texture: return GPUVariable<GLSLTexture>(name: name)
        case .Plane: return GPUVariable<GLSLPlane>(name: name)
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
    case Tangent
    
    func name() -> String {
        switch self {
        case .Position: return "position"
        case .Texel: return "texel"
        case .Normal: return "normal"
        case .Tangent: return "tangent"
        }
    }
    
    func location() -> GLuint {
        switch self {
        case .Position: return 0
        case .Texel: return 1
        case .Normal: return 2
        case .Tangent: return 3
        }
    }
    
    func size() -> Int {
        switch self {
        case .Position: return 3
        case .Texel: return 2
        case .Normal: return 3
        case .Tangent: return 3
        }
    }
    
    func gpuType() -> GPUType {
        switch self {
        case .Normal, .Tangent: return .Vec3
        case .Texel: return .Vec2
        case .Position: return .Vec4
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
    case ModelMatrix2
    case ViewProjectionMatrix
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
        case .ModelMatrix2: return "modelMatrix2"
        case .ViewProjectionMatrix: return "viewProjectionMatrix"
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
        case .ModelMatrix, .ModelMatrix2, .ViewProjectionMatrix, .ModelViewProjectionMatrix: return .Mat4
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
        return GPUInterface(attributes: [.Position, .Texel, .Normal, .Tangent], uniforms: [.ModelMatrix, .ViewProjectionMatrix, .NormalMatrix, .EyePosition, .LightDirection, .ColorMap, .NormalMap, .TextureScale])
    }
    
    static func mediumShotInterface() -> GPUInterface {
        return GPUInterface(attributes: [.Position, .Texel, .Normal], uniforms: [.ModelViewProjectionMatrix, .NormalMatrix, .LightDirection, .LightHalfVector, .ColorMap, .TextureScale])
    }
    
    static func backgroundInterface() -> GPUInterface {
        return GPUInterface(attributes: [.Position], uniforms: [.ModelViewProjectionMatrix, .LightHalfVector, .ColorMap, .NormalMap])
    }
    
    static func reflectiveInterface() -> GPUInterface {
        return GPUInterface(attributes: [.Position, .Texel], uniforms: [.ModelViewProjectionMatrix, .ReflectionColorMap])
    }
    
    static func reflectedInterface() -> GPUInterface {
        return GPUInterface(attributes: [.Position, .Normal, .Texel], uniforms: [.ModelMatrix, .ModelMatrix2, .ViewProjectionMatrix, .ColorMap, .TextureScale])
    }
    
}

func gpuDomainNameWithPrefix(originalName: String, prefix: String) -> String {
    let first = originalName.substringToIndex(originalName.startIndex.advancedBy(1))
    let rest = originalName.substringFromIndex(originalName.startIndex.advancedBy(1))
    return prefix + first.uppercaseString + rest
}
