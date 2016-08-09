//
//  FullScreenVao.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 09.08.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

struct FullScreenVao {
    static var vao: VAO!
    static func setup() {
        vao = VAO(obj: OBJLoader.objFromFileNamed("full_screen"))
    }
}