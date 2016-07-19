//
//  OpenGLDefaultVariables.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 31.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

public struct OpenGLDefaultVariables {
    static func glPosition() -> Variable<GLSLVec4> {
        return Variable<GLSLVec4>(name: "gl_Position")
    }
    
    static func glFragColor() -> Variable<GLSLColor> {
        return Variable<GLSLColor>(name: "gl_FragColor")
    }
}