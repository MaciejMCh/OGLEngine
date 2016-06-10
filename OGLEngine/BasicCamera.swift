//
//  BasicCamera.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 27.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation
import GLKit

class BasicCamera: Camera {
    
    var position: GLKVector3! = GLKVector3Make(0, 0, 0)
    var orientation: GLKVector3! = GLKVector3Make(0, 0, 0)
    var staticProjectionMatrix: GLKMatrix4! = GLKMatrix4Identity
    
    init(position: GLKVector3, orientation: GLKVector3) {
        self.position = position
        self.orientation = orientation
        let aspect: Float = fabs(Float(UIScreen.mainScreen().bounds.size.width) / Float(UIScreen.mainScreen().bounds.size.height))
        self.staticProjectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), aspect, 0.1, 100.0)
    }
    
    
    final func cameraPosition() -> GLKVector3 {
        return GLKVector3Make(-self.position.x, -self.position.y, -self.position.z)
    }
    
    func projectionMatrix() -> GLKMatrix4 {
        return self.staticProjectionMatrix
    }
    
    func viewMatrix() -> GLKMatrix4 {
        return transformatrionMatrix(self.position, orientation: self.orientation)
    }
    
    func viewProjectionMatrix() -> GLKMatrix4 {
        return self.viewMatrix() * self.projectionMatrix()
    }
}