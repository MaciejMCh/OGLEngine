//
//  RayBoxCamera.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 07.07.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

enum FocusDirection {
    case Left
    case Forward
    case Right
    case Back
    case Up
    case Down
    
    func lookAtRay() -> GLKVector3 {
        let first = Float(0.0001)
        switch self {
        case .Left: return GLKVector3Make(-1, 0, 0)
        case .Forward: return GLKVector3Make(0, 1, 0)
        case .Right: return GLKVector3Make(1, 0, 0)
        case .Back: return GLKVector3Make(0, -1, 0)
        case .Up: return GLKVector3Make(0, first, 1)
        case .Down: return GLKVector3Make(0, first, -1)
        }
    }
    
    func applyViewPort() {
        let w = GLsizei(512 / 2)
        let h = GLsizei(512 / 3)
        switch self {
        case .Left: glViewport(0, 2*h, w, h)
        case .Forward: glViewport(w, 2*h, w, h)
        case .Right: glViewport(0, h, w, h)
        case .Back: glViewport(w, h, w, h)
        case .Up: glViewport(0, 0, w, h)
        case .Down: glViewport(w, 0, w, h)
        }
    }
}

class RayBoxCamera: LookAtCamera {
    init(eyePosition: GLKVector3) {
        super.init()
        self.staticProjectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90.0), 1, 0.1, 200.0)
        self.eyePosition = eyePosition
    }
    
    func lookAt(focusDirection: FocusDirection) {
        self.focusPosition = GLKVector3Add(self.cameraPosition(), focusDirection.lookAtRay())
    }
}