//
//  GeometryModel.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 21.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation

@objc protocol GeometryModel {
    
    func modelMatrix() -> GLKMatrix4
    
}
