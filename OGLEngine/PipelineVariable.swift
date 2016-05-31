//
//  PipelineVariable.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 31.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

public class AnyGPUVariable {
    private(set) var name: String?
    
    init(name: String? = nil) {
        self.name = name
    }
}

extension AnyGPUVariable: GPURepresentable {
    var glslName: String {
        get {
            return self.name!
        }
    }
}

public class GPUVariable<T: GLSLType>: AnyGPUVariable {
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

public enum GPUVariablePrecision {
    case Low
    case High
}

public enum GPUVariableAccessKind {
    case Attribute
    case Uniform
    case Varying
    case Local
}