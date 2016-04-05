//
//  Renderable.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 21.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation
import UIKit

protocol Mesh {
    var vao: VAO {get}
}

protocol Model {
    var geometryModel: GeometryModel {get}
}

protocol Colored {
    var color: UIColor {get}
}

protocol ColorMapped {
    var colorMap: Texture {get}
}

protocol NormalMapped {
    var normalMap: Texture {get}
}

protocol BumpMapped: ColorMapped, NormalMapped {
    
}

struct FinalRenderable: Mesh, Model, BumpMapped {
    let vao: VAO
    let geometryModel: GeometryModel
    let colorMap: Texture
    let normalMap: Texture
}
