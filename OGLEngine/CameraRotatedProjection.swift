//
//  CameraRotatedProjection.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 06.07.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

extension Camera {
    func rotatedProjectionMatrix() -> GLKMatrix4 {
        let projectionMatrix = self.projectionMatrix()
        let viewMatrix = self.viewMatrix()
        let rotationMatrix = trimToRotation(viewMatrix)
        let rotatedProjectionMatrix = rotationMatrix * projectionMatrix
        return rotatedProjectionMatrix
    }
}