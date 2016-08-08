//
//  RayBoxCamera.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 07.07.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

class RayBoxCamera: Camera {
    var staticProjectionMatrix: GLKMatrix4!
    var eyePosition: GLKVector3!
    var lookingViewMatrix: GLKMatrix4 = GLKMatrix4Identity
    
    init(eyePosition: GLKVector3) {
        self.staticProjectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90.0), 1, 0.1, 200.0)
        self.eyePosition = eyePosition
    }
    
    func lookAt(focusDirection: CubeTextureSide) {
        self.lookingViewMatrix = focusDirection.lookingMatrix()
    }
    
    func viewMatrix() -> GLKMatrix4 {
        return lookingViewMatrix
    }
    
    func projectionMatrix() -> GLKMatrix4 {
        return staticProjectionMatrix
    }
    
    func cameraPosition() -> GLKVector3 {
        return eyePosition
    }
}

extension CubeTextureSide {
    func lookingMatrix() -> GLKMatrix4 {
        switch self {
        case .PositiveX: return GLKMatrix4Make(0, 0, -1, 0,
                                               0, -1, 0, 0,
                                               -1, 0, 0, 0,
                                               0, 0, 0, 1)
        case .NegativeX: return GLKMatrix4Make(0, 0, 1, 0,
                                               0, -1, 0, 0,
                                               1, 0, 0, 0,
                                               0, 0, 0, 1)
        case .PositiveY: return GLKMatrix4Make(1, 0, 0, 0,
                                               0, 0, -1, 0,
                                               0, 1, 0, 0,
                                               0, 0, 0, 1)
        case .NegativeY: return GLKMatrix4Make(1, 0, 0, 0,
                                               0, 0, 1, 0,
                                               0, -1, 0, 0,
                                               0, 0, 0, 1)
        case .PositiveZ: return GLKMatrix4Make(1, 0, 0, 0,
                                               0, -1, 0, 0,
                                               0, 0, -1, 0,
                                               0, 0, 0, 1)
        case .NegativeZ: return GLKMatrix4Make(-1, 0, 0, 0,
                                               0, -1, 0, 0,
                                               0, 0, 1, 0,
                                               0, 0, 0, 1)
        }
    }
}