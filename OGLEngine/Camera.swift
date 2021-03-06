//
//  Camera.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 21.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation
import GLKit

protocol Camera {
    
    func viewProjectionMatrix() -> GLKMatrix4
    func viewMatrix() -> GLKMatrix4
    func projectionMatrix() -> GLKMatrix4
    func cameraPosition() -> GLKVector3
    
}
