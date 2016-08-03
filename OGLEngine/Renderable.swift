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
}

protocol NormalMapped {
    var normalMap: Texture {get}
}

protocol SpecularMapped {
    var specularMap: Texture {get}
}

protocol ReflectiveSurface {
    var reflectionColorMap: RenderedTexture {get}
}

protocol ReflectiveSolid {
    var rayBoxColorMap: RenderedTexture {get}
}

protocol Material {
    var materialProperties: MaterialProperties {get}
}

class MaterialProperties {
    var specularPower: Float
    var specularSharpness: Float
    var fresnelA: Float
    var fresnelB: Float
    
    init(specularPower: Float, specularSharpness: Float, fresnelA: Float, fresnelB: Float) {
        self.specularPower = specularPower
        self.specularSharpness = specularSharpness
        self.fresnelA = fresnelA
        self.fresnelB = fresnelB
    }
}

struct LighModelIdeaRenderable: Mesh, Model, ColorMapped, NormalMapped, SpecularMapped, ReflectiveSolid, Material {
    let vao: VAO
    let geometryModel: GeometryModel
    let colorMap: Texture
    let normalMap: Texture
    let specularMap: Texture
    let rayBoxColorMap: RenderedTexture
    let materialProperties: MaterialProperties
}

struct CloseShotRenderable: Mesh, Model, ColorMapped, NormalMapped, SpecularMapped {
    let vao: VAO
    let geometryModel: GeometryModel
    let colorMap: Texture
    let normalMap: Texture
    let specularMap: Texture
}

struct MediumShotRenderable: Mesh, Model, ColorMapped {
    let vao: VAO
    let geometryModel: GeometryModel
    let colorMap: Texture
}

struct ReflectiveSurfaceRenderable: Mesh, Model, ReflectiveSurface {
    let vao: VAO
    let geometryModel: GeometryModel
    let reflectionColorMap: RenderedTexture
    var reflectionPlane: ReflectionPlane {
        return ReflectionPlane(model: self.geometryModel)
    }
}

struct ReflectedRenderable: Mesh, Model, ColorMapped {
    let vao: VAO
    let geometryModel: GeometryModel
    let colorMap: Texture
}

struct SkyBoxRenderable: Mesh, ColorMapped {
    let vao: VAO
    let colorMap: Texture
}

struct FrameBufferViewerRenderable: Mesh {
    let vao: VAO
    let frameBufferRenderedTexture: RenderedTexture
}
