//
//  BasicCamera.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 27.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation
import GLKit
//import QuartzCore

class BasicCamera: NSObject, Camera {
    
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
        let aspect: Float = fabs(Float(UIScreen.mainScreen().bounds.size.width) / Float(UIScreen.mainScreen().bounds.size.height))
        self.staticProjectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), aspect, 0.1, 100.0)
    }
    
    func cameraPosition() -> GLKVector3 {
        return self.position
    }
    
    func projectionMatrix() -> GLKMatrix4 {
        return self.staticProjectionMatrix
    }
    
    func viewMatrix() -> GLKMatrix4 {
        return transformatrionMatrix(self.cameraPosition(), orientation: self.orientation)
    }
}