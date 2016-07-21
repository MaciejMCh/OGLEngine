//
//  GLSLVariablesCollection.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 30.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

//protocol GPURepresentable {
//    var glslName: String {get}
//}
//
//extension Variable {
//    convenience init(glslRepresentable: GPURepresentable) {
//        self.init(name: glslRepresentable.glslName)
//    }
//}

struct GPUVariableCollection<T: AnyVariable> {
    let collection: [T]
    
    // TODO: Very ugly
    func get<T where T: GLSLType>(uniform: Variable<T>) -> Variable<T>! {
        for element in self.collection {
            if element.name == uniform.name {
//                if self is GPUVariableCollection<AnyVariable> {
//                    return element as! Variable<T>
//                } else if self is GPUVariableCollection<AnyGPUUniform> {
                    return (element as! GPUUniform<T>).typedVariable
//                }
            }
        }
        return nil
    }
    
//    func get<T where T: GLSLType>(attribute: GPUAttribute<T>) -> Variable<T>! {
//        for element in self.collection {
//            if element.name == attribute.name {
//                return (element as! GPUAttribute<T>).typedVariable
//            }
//        }
//        return nil
//    }
    
}
