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

class GPUInstance {
    var uniform: Uniform
    var location: GLint
    var sceneEntityPass: SceneEntityPass?
    
    init(uniform: Uniform, location: GLint) {
        self.uniform = uniform
        self.location = location
    }
    
    func bindWithSceneEntityPass(sceneEntityPass: SceneEntityPass) {
        self.sceneEntityPass = sceneEntityPass
    }
    
    func passToGpu() {
        self.sceneEntityPass?.passToGpu(self.location)
    }
}

protocol SceneEntityPass {
    func passToGpu(location: GLint)
}

protocol Passing {
    associatedtype Pass
    var passSubject: Pass {get}
    func pass(passSubject: Pass, location: GLint)
}

extension SceneEntityPass where Self: Passing {
    func passToGpu(location: GLint) {
        self.pass(self.passSubject, location: location)
    }
}

protocol Vector3Pass: SceneEntityPass, Passing {
    associatedtype Pass = GLKVector3
    var vector3Pass: GLKVector3 {get}
}

extension Vector3Pass {
    var passSubject: GLKVector3 {
        get {
            return self.vector3Pass
        }
    }
    
    func pass(passSubject: GLKVector3, location: GLint) {
        GPUPassFunctions.vec3Pass(passSubject, location: location)
    }
}

class GetterPass<PassType>: SceneEntityPass, Passing {
    typealias Pass = PassType
    typealias PassSubjectGetter = () -> PassType
    
    var subjectGetter: PassSubjectGetter
    
    var passSubject: PassType {
        get {
            return self.subjectGetter()
        }
    }
    
    init(subjectGetter: PassSubjectGetter) {
        self.subjectGetter = subjectGetter
    }
    
    func pass(passSubject: PassType, location: GLint) {
        switch passSubject {
        case is GLKVector3: GPUPassFunctions.vec3Pass(passSubject as! GLKVector3, location: location)
        default: break
        }
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
