//
//  Renderable.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 21.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation
import UIKit
import GLKit

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
    var textureScale: Float {get}
}

protocol NormalMapped {
    var normalMap: Texture {get}
    var textureScale: Float {get}
}

protocol ReflectiveSurface {
    var reflectionColorMap: RenderedTexture {get}
}

protocol BumpMapped: ColorMapped, NormalMapped {
    
}

struct CloseShotRenderable: Mesh, Model, BumpMapped {
    let vao: VAO
    let geometryModel: GeometryModel
    let colorMap: Texture
    let normalMap: Texture
    let textureScale: GLfloat
}

struct MediumShotRenderable: Mesh, Model, ColorMapped {
    let vao: VAO
    let geometryModel: GeometryModel
    let colorMap: Texture
    let textureScale: Float
}

struct ReflectiveSurfaceRenderable: Mesh, Model, ReflectiveSurface {
    let vao: VAO
    let geometryModel: GeometryModel
    let reflectionColorMap: RenderedTexture
    var reflectionPlane: ReflectionPlane {
        let p1 = transformVector(GLKVector3Make(-1,-1,0), transformation: self.geometryModel.modelMatrix())
        let p2 = transformVector(GLKVector3Make(1,-1,0), transformation: self.geometryModel.modelMatrix())
        let p3 = transformVector(GLKVector3Make(-1,1,0), transformation: self.geometryModel.modelMatrix())
        return ReflectionPlane( p1: p1, p2: p2, p3: p3)
    }
}

struct ReflectedRenderable: Mesh, Model, ColorMapped {
    let vao: VAO
    let geometryModel: GeometryModel
    let colorMap: Texture
    let textureScale: Float
}