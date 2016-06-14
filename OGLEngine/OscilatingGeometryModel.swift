//
//  OscilatingGeometryModel.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 14.06.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

class OscilatingGeometryModel: GeometryModel {
    override var position: GLKVector3 {
        get {
            let time = Float(CACurrentMediaTime())
            return GLKVector3Make(0, 0, sin(time))
//            return GLKVector3Make(0, 0, 0.5)
        }
        set {
            
        }
    }
}