//
//  Program.swift
//  SwiftyProgram
//
//  Created by Maciej Chmielewski on 18.03.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit


struct GPUInterface {
    let attributes: [Attribute]
    let uniforms: [Uniform]
    
    init(attributes: [Attribute], uniforms: [Uniform]) {
        self.attributes = attributes
        self.uniforms = uniforms
    }
}

struct GPUInstance {
    var type: GPUType
    var location: GLuint
}

enum GPUType {
    case Float
    case Vec2
    case Vec3
    case Mat3
    case Mat4
    case Texture
}

typealias Dimension = (columns: Int, rows: Int)

protocol SceneEntityPass {
    func passToGpu()
}

protocol Passing {
    associatedtype Pass
    var pass: Pass {get}
    func passFunction() -> ((pass: Pass) -> ())
}

class LightPosition: SceneEntityPass, Passing {
    typealias Pass = GLKVector3
    var pass: GLKVector3 = GLKVector3Make(0, 0, 0)
}

extension SceneEntityPass where Self: Passing {
    func passToGpu() {
        self.passFunction(self.pass)
    }
}

extension Passing where Pass: GLKVector3 {
    func passFunction(pass: GLKVector3) {
        
    }
}
