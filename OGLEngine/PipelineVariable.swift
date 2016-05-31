//
//  PipelineVariable.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 31.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

public protocol GPUVariable {
    associatedtype UnderlyingType
}

public class AnyGPUVariable: GPUVariable {
    public typealias UnderlyingType = Any
    private(set) var name: String?
    
    init(name: String? = nil) {
        self.name = name
    }
}

extension AnyGPUVariable: GLSLRepresentable {
    var glslName: String {
        get {
            return self.name!
        }
    }
}

public class TypedGPUVariable<T: GLSLType>: AnyGPUVariable {
    public typealias UnderlyingType = T
    
    private(set) var value: T.CPUCounterpart?
    override var name: String? {
        get {
            if let value = self.value {
                return T.primitiveFace(value)
            } else {
                return super.name
            }
        }
        set {
            self.name = newValue
        }
    }
    
    init(value: T.CPUCounterpart? = nil, name: String? = nil) {
        super.init(name: name)
        self.value = value
    }   
}

public enum VariablePrecision {
    case Low
    case High
}

public enum VariableAccessKind {
    case Attribute
    case Uniform
    case Varying
    case Local
}