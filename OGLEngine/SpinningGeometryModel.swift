//
//  SpinningGeometryModel.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 21.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation
import GLKit

class SpinningGeometryModel : NSObject {
    
    var translation: GLKMatrix4!
    
    convenience init(position: GLKVector3) {
        self.init()
        self.translation = GLKMatrix4MakeTranslation(position.x, position.y, position.z)
    }
    
    func modelMatrix() -> GLKMatrix4 {
        return GLKMatrix4Rotate(self.translation, Float(CACurrentMediaTime()), 0.5, 1, 0.25)
    }
}