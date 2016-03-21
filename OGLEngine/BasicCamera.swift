//
//  BasicCamera.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 21.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation
import GLKit

class BasicCamera : NSObject, Camera {
    
    var staticProjectionMatrix: GLKMatrix4!
    var position: GLKVector3!
    var orientation: GLKVector3!
    
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
        NSLog("p: %.f %.f %.f", position.x, position.y, position.z)
        NSLog("o: %.f %.f %.f", orientation.x, orientation.y, orientation.z)
        var viewMatrix: GLKMatrix4 = GLKMatrix4Identity
        viewMatrix = GLKMatrix4Rotate(viewMatrix, orientation.x, 1, 0, 0)
        viewMatrix = GLKMatrix4Rotate(viewMatrix, orientation.y, 0, 1, 0)
        viewMatrix = GLKMatrix4Rotate(viewMatrix, orientation.z, 0, 0, 1)
        viewMatrix = GLKMatrix4Translate(viewMatrix, position.x, position.y, position.z)
        return viewMatrix
    }
}