//
//  Reflection.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 18.05.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

struct ReflectionPlane {
    let geometryModel: GeometryModel
    
    let A: Float
    let B: Float
    let C: Float
    let D: Float
    
    let a: Float
    let b: Float
    let c: Float
    let d: Float
    
    init(model: GeometryModel) {
        self.geometryModel = model;
        A = 0
        B = 0
        C = 1
        D = 0
        a = 0
        b = 0
        c = 1
        d = 0
    }
    
//    init(p1: GLKVector3, p2: GLKVector3, p3: GLKVector3) {
//        let vec1 = GLKVector3Subtract(p1, p3)
//        let vec2 = GLKVector3Subtract(p2, p3)
//        let normal = GLKVector3Normalize(GLKVector3CrossProduct(vec1, vec2))
//        
//        self.A = normal.x
//        self.B = normal.y
//        self.C = normal.z
//        self.D = (self.A * p1.x + self.B * p1.y + self.C * p1.z) * -1.0
//        
////        debugPrint("\(A) \(B) \(C) \(D)")
//        
//        let N = sqrt(A * A + B * B + C * C)
//        
//        a = A / N
//        b = B / N
//        c = C / N
//        d = D / N
//    }
    
    func reflectedCamera(camera: LookAtCamera) -> LookAtCamera {
        let eyePosition = camera.eyePosition
        let focusPosition = camera.focusPosition
        let mirroredEyePosition = GLKVector3Make(eyePosition.x, eyePosition.y, -eyePosition.z)
        let mirroredFocusPosition = GLKVector3Make(focusPosition.x, focusPosition.y, -focusPosition.z)
        let reflectedCamera = LookAtCamera()
        reflectedCamera.eyePosition = mirroredEyePosition
        reflectedCamera.focusPosition = mirroredFocusPosition
//        debugPrint("\(eyePosition.z) -> \(focusPosition.z) || \(mirroredEyePosition.z) -> \(mirroredFocusPosition.z)")
        return reflectedCamera
    }
    
    func distanceToPoint(point: GLKVector3) -> Float {
        return point.x * a + point.y * b + point.z * c + d
    }
    
    func reflectedPoint(point: GLKVector3) -> GLKVector3 {
        let distance = distanceToPoint(point)
//        debugPrint("point \(point.x) \(point.y) \(point.z) is \(distance) from plane \(A) \(B) \(C) \(D)")
        return GLKVector3Add(point, GLKVector3Make(A * distance * -2, B * distance * -2, C * distance * -2))
    }
}