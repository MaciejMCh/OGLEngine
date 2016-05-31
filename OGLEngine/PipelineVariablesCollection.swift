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
    
    func get(variable: GPURepresentable) -> T! {
        for element in collection {
            if element.glslName == variable.glslName {
                return element
            }
        }
        return nil
    }
    
}
