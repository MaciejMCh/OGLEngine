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

func transformVector(vector: GLKVector3, transformation: GLKMatrix4) -> GLKVector3 {
    let t = transformation
    let mat = Matrix<Float>([
        [t.m00, t.m10, t.m20, t.m30],
        [t.m01, t.m11, t.m21, t.m31],
        [t.m02, t.m12, t.m22, t.m32],
        [t.m03, t.m13, t.m23, t.m33]])
    let vec = Matrix<Float>([[vector.x], [vector.y], [vector.z], [1.0]])
    let transformed = mat * vec
    return GLKVector3Make(transformed.column(0)[0], transformed.column(0)[1], transformed.column(0)[2])
}

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

func modelTransformatrionMatrix(position: GLKVector3, orientation: GLKVector3) -> GLKMatrix4 {
    var transformation = CATransform3DIdentity
    transformation = CATransform3DTranslate(transformation, CGFloat(position.x), CGFloat(position.y), CGFloat(position.z))
    transformation = CATransform3DRotate(transformation, CGFloat(orientation.x), 1, 0, 0)
    transformation = CATransform3DRotate(transformation, CGFloat(orientation.y), 0, 1, 0)
    transformation = CATransform3DRotate(transformation, CGFloat(orientation.z), 0, 0, 1)
    return transformation.toGLK()
}

func multiplyMatrices(lhs: GLKMatrix4, rhs: GLKMatrix4) -> GLKMatrix4 {
    let caLhs = lhs.toCA()
    let caRhs = rhs.toCA()
    let result = CATransform3DConcat(caLhs, caRhs)
    let glkResult = result.toGLK()
    return glkResult
}

func trimToMat3(matrix: GLKMatrix4) -> GLKMatrix3 {
    let m = matrix
    return GLKMatrix3Make(m.m00, m.m01, m.m02,
                          m.m10, m.m11, m.m12,
                          m.m20, m.m21, m.m22)
}

func transpose(matrix: GLKMatrix3) -> GLKMatrix3 {
    let m = matrix
    return GLKMatrix3Make(m.m00, m.m10, m.m20,
                          m.m01, m.m11, m.m21,
                          m.m02, m.m12, m.m22)
}

func * (left: GLKMatrix4, right: GLKMatrix4) -> GLKMatrix4 {
    return multiplyMatrices(left, rhs: right)
}

