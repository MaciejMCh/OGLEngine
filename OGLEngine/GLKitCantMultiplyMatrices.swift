//
//  TransformatrixMatrix.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 28.03.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit
import simd
import Upsurge

extension GLKMatrix4 {
    func toCA() -> CATransform3D {
        return CATransform3D(m11: CGFloat(self.m00), m12: CGFloat(self.m01), m13: CGFloat(self.m02), m14: CGFloat(self.m03),
                             m21: CGFloat(self.m10), m22: CGFloat(self.m11), m23: CGFloat(self.m12), m24: CGFloat(self.m13),
                             m31: CGFloat(self.m20), m32: CGFloat(self.m21), m33: CGFloat(self.m22), m34: CGFloat(self.m23),
                             m41: CGFloat(self.m30), m42: CGFloat(self.m31), m43: CGFloat(self.m32), m44: CGFloat(self.m33))
    }
}

extension CATransform3D {
    func toGLK() -> GLKMatrix4 {
        return GLKMatrix4Make(
            Float(self.m11), Float(self.m12), Float(self.m13), Float(self.m14),
            Float(self.m21), Float(self.m22), Float(self.m23), Float(self.m24),
            Float(self.m31), Float(self.m32), Float(self.m33), Float(self.m34),
            Float(self.m41), Float(self.m42), Float(self.m43), Float(self.m44))
    }
}

func transformatrionMatrix(position: GLKVector3, orientation: GLKVector3) -> GLKMatrix4 {
    var transformation = CATransform3DIdentity
    transformation = CATransform3DRotate(transformation, CGFloat(orientation.x), 1, 0, 0)
    transformation = CATransform3DRotate(transformation, CGFloat(orientation.y), 0, 1, 0)
    transformation = CATransform3DRotate(transformation, CGFloat(orientation.z), 0, 0, 1)
    
    transformation = CATransform3DTranslate(transformation, CGFloat(position.x), CGFloat(position.y), CGFloat(position.z))
    
    return transformation.toGLK()
}

func multiplyMatrices(lhs: GLKMatrix4, rhs: GLKMatrix4) -> GLKMatrix4 {
    let caLhs = lhs.toCA()
    let caRhs = rhs.toCA()
    let result = CATransform3DConcat(caLhs, caRhs)
    let glkResult = result.toGLK()
    return glkResult
}

func invertAndTransposeMatrix(matrix: GLKMatrix4) -> GLKMatrix3 {
    
    let A = Matrix<Float>([
        [matrix.m00, matrix.m01, matrix.m02],
        [matrix.m10, matrix.m11, matrix.m12],
        [matrix.m20, matrix.m21, matrix.m22],
        ])         
    
    let inverted = inv(A)
    let transposed = transpose(inverted)
    return GLKMatrix3Make(transposed.elements[0], transposed.elements[1], transposed.elements[2],
                          transposed.elements[3], transposed.elements[4], transposed.elements[5],
                          transposed.elements[6], transposed.elements[7], transposed.elements[8])
    
    
}

func * (left: GLKMatrix4, right: GLKMatrix4) -> GLKMatrix4 {
    return multiplyMatrices(left, rhs: right)
}

