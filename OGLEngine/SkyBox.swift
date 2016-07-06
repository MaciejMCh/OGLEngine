//
//  SkyBox.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 05.07.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

extension SkyBox {
    init() {
        vao = VAO(obj: OBJLoader.objFromFileNamed("skybox"))
        colorMap = ImageTexture(imageNamed: "skybox.png")
        colorMap.bind()
    }
}