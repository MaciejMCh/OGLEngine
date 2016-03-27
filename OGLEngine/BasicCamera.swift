//
//  BasicCamera.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 27.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation
import GLKit

class BasicCamera2: NSObject, Camera {
    
    var position: GLKVector3! = GLKVector3Make(0, 0, 0)
    var orientation: GLKVector3! = GLKVector3Make(0, 0, 0)
    var staticProjectionMatrix: GLKMatrix4! = GLKMatrix4Identity
    
    convenience init(position: GLKVector3, orientation: GLKVector3) {
        self.init()
        self.position = position
        self.orientation = orientation
    }
    
    override init() {
        super.init()
        var aspect: Float = fabs(Float(UIScreen.mainScreen().bounds.size.width) / Float(UIScreen.mainScreen().bounds.size.height))
        self.staticProjectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), aspect, 0.1, 100.0)
    }
    
    func cameraPosition() -> GLKVector3 {
        return self.position
    }
    
    func projectionMatrix() -> GLKMatrix4 {
        return self.staticProjectionMatrix
    }
    
    func viewMatrix() -> GLKMatrix4 {
        var orientation: GLKVector3 = self.orientation
        var position: GLKVector3 = self.position
        let id: GLKMatrix4 = GLKMatrix4Identity
        let rotx = GLKMatrix4Rotate(id, orientation.x, 1, 0, 0)
        let roty = GLKMatrix4Rotate(rotx, orientation.y, 0, 1, 0)
        let rotz = GLKMatrix4Rotate(roty, orientation.z, 0, 0, 1)
        let tra = GLKMatrix4Translate(roty, position.x, position.y, position.z)
        return GLKMatrix4MakeTranslation(position.x, position.y, position.z)
    }
}