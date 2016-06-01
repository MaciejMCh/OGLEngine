//
//  GLSLVariablesCollection.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 30.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

protocol GPURepresentable {
    var glslName: String {get}
}

extension GPUVariable {
    convenience init(glslRepresentable: GPURepresentable) {
        self.init(name: glslRepresentable.glslName)
    }
}

struct GPUVariableCollection<T: GPURepresentable> {
    let collection: [T]
    
    // TODO: Very ugly
    func get<T where T: GLSLType>(uniform: GPUVariable<T>) -> GPUVariable<T>! {
        for element in self.collection {
            if element.glslName == uniform.glslName {
                if self is GPUVariableCollection<AnyGPUVariable> {
                    return element as! GPUVariable<T>
                } else if self is GPUVariableCollection<AnyGPUUniform> {
                    return (element as! GPUUniform<T>).typedVariable
                }
            }
        }
        return nil
    }
    
    func get<T where T: GLSLType>(attribute: GPUAttribute<T>) -> GPUVariable<T>! {
        for element in self.collection {
            if element.glslName == attribute.glslName {
                return (element as! GPUAttribute<T>).typedVariable
            }
        }
        return nil
    }
    
}
