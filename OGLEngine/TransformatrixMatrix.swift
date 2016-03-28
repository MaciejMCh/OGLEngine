//
//  TransformatrixMatrix.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 28.03.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

func transformatrionMatrix(position: GLKVector3, orientation: GLKVector3) -> GLKMatrix4 {
    var transformation = CATransform3DIdentity
    transformation = CATransform3DRotate(transformation, CGFloat(orientation.x), 1, 0, 0)
    transformation = CATransform3DRotate(transformation, CGFloat(orientation.y), 0, 1, 0)
    transformation = CATransform3DRotate(transformation, CGFloat(orientation.z), 0, 0, 1)
    
    transformation = CATransform3DTranslate(transformation, CGFloat(position.x), CGFloat(position.y), CGFloat(position.z))
    
    return GLKMatrix4Make(
        Float(transformation.m11), Float(transformation.m12), Float(transformation.m13), Float(transformation.m14),
        Float(transformation.m21), Float(transformation.m22), Float(transformation.m23), Float(transformation.m24),
        Float(transformation.m31), Float(transformation.m32), Float(transformation.m33), Float(transformation.m34),
        Float(transformation.m41), Float(transformation.m42), Float(transformation.m43), Float(transformation.m44))
}