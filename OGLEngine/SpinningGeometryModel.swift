//
//  SpinningGeometryModel.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 21.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation
import GLKit

class SpinningGeometryModel: GeometryModel {
    
    override var orientation: GLKVector3 {
        get {
            let time = Float(CACurrentMediaTime())
            return GLKVector3Make(time, 0, 0)
        }
        set {
            
        }
    }
    
}