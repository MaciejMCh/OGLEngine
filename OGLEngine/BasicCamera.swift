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
//        NSLog("%.2f %.2f %.2f", orientation.x, orientation.y, orientation.z)
        var position: GLKVector3 = self.cameraPosition()
        return transformatrionMatrix(position, orientation: orientation)
//        let id: GLKMatrix4 = GLKMatrix4Identity
//        let rotx = GLKMatrix4MakeXRotation(orientation.x)
//        let roty = GLKMatrix4MakeYRotation(orientation.y)
//        let rotz = GLKMatrix4MakeZRotation(orientation.z)
//        let tra = GLKMatrix4Translate(rotz, position.x, position.y, position.z)
//        var res = GLKMatrix4Multiply(rotx, roty)
//        res = GLKMatrix4Multiply(res, rotz)
//        res = GLKMatrix4Multiply(res, tra)
//        return GLKMatrix4Multiply(GLKMatrix4Identity, rotx)
        
//        return GLKMatrix4MakeTranslation(position.x, position.y, position.z)
//        return tra
//        var res = CATransform3DMakeRotation(CGFloat(orientation.x), 1, 0, 0)
//        res = CATransform3DRotate(res, CGFloat(orientation.y), 0, 1, 0)
//        res = CATransform3DRotate(res, CGFloat(orientation.z), 0, 1, 1)
        
//        res = CATransform3DMakeTranslation(CGFloat(position.x), CGFloat(position.y), CGFloat(position.z))
    
        
//        return GLKMatrix4Make(Float(res.m11), Float(res.m12), Float(res.m13), Float(res.m14), Float(res.m21), Float(res.m22), Float(res.m23), Float(res.m24), Float(res.m31), Float(res.m32), Float(res.m33), Float(res.m34), Float(res.m41), Float(res.m42), Float(res.m43), Float(res.m44))
        
    }
}