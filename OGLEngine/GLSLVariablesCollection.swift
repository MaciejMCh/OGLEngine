//
//  GLSLVariablesCollection.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 30.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

protocol GLSLRepresentable {
    var glslName: String {get}
}

struct GLSLVariableCollection<T: GLSLRepresentable> {
    let collection: [T]
    
    func get(variable: GLSLRepresentable) -> T! {
        for element in collection {
            if element.glslName == variable.glslName {
                return element
            }
        }
        return nil
    }
    
}
