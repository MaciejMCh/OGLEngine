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
}

struct GPUImplementation {
    let instances: [GPUInstance]
}


struct GPUInstance {
    var uniform: Uniform
    var location: GLint
    var sceneEntityPass: SceneEntityPass?
    
    func passToGpu() {
        self.sceneEntityPass?.passToGpu(self.location)
    }
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
    func passToGpu(location: GLint)
}

protocol Passing {
    associatedtype Pass
    var passSubject: Pass {get}
    func pass(passSubject: Pass, location: GLint)
}

class Vector3Pass: SceneEntityPass, Passing {
    typealias Pass = GLKVector3
    var passSubject: GLKVector3 = GLKVector3Make(0, 0, 0)

    func pass(var passSubject: GLKVector3, location: GLint) {
        withUnsafePointer(&passSubject, {
            glUniform3fv(location, 1, UnsafePointer($0))
        })
    }
    
    func passToGpu(location: GLint) {
        self.pass(self.passSubject, location: location)
    }
    
}


extension Array {
    func get(uniform: Uniform) -> GPUInstance! {
        for element in self {
            if let instance = element as? GPUInstance {
                if instance.uniform == uniform {
                    return instance
                }
            }
        }
        return nil
    }
}

//extension SceneEntityPass where Self: Passing {
//    func passToGpu() {
//        self.passFunction(self.pass)
//    }
//}

//extension Passing where Pass: GLKVector3 {
//    func passFunction(pass: GLKVector3) {
//        
//    }
//}
