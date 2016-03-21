//
//  Renderable.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 21.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation

class Renderable : NSObject {
    
    var vao: VAO!
    var geometryModel: GeometryModel!
    var texture: Texture!
    
    convenience init(vao: VAO, geometryModel: GeometryModel, texture: Texture) {
        self.init()
        self.vao = vao
        self.geometryModel = geometryModel
        self.texture = texture
    }
}