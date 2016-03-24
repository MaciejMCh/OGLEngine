//
//  Program.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 24.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation
import GLKit

class Program : NSObject {
    static var ProgramUniformTexture: GLint = 0
    static var ProgramUniformNormalMap: GLint = 0
    static var ProgramUniformModelMatrix: GLint = 0
    static var ProgramUniformViewMatrix: GLint = 0
    static var ProgramUniformProjectionMatrix: GLint = 0
    static var ProgramUniformNormalMatrix: GLint = 0
    static var ProgramUniformEyePosition: GLint = 0
    static var ProgramUniformDirectionalLightDirection: GLint = 0
}
