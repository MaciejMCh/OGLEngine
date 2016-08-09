//
//  Renderable.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 21.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation
import GLKit

protocol Mesh {
    var vao: VAO {get}
}

class BasicRenderable: Mesh {
    var vao: VAO
    init(vao: VAO) {
        self.vao = vao
    }
}

protocol Model {
    var geometryModel: GeometryModel {get}
}

protocol Colored {
    var color: Color {get}
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

protocol Emitter {
    var emittingColor: Color {get}
}

struct CubeTextureBlurringContext {
    let blurringTexture: Texture
    let topTexture: Texture
    let leftTexture: Texture
    let bottomTexture: Texture
    let rightTexture: Texture
}

protocol CubeTextureBlur {
    var blurringContext: CubeTextureBlurringContext {get}
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

class LighModelIdeaRenderable: BasicRenderable, Model, ColorMapped, NormalMapped, SpecularMapped, ReflectiveSolid, Material {
    var geometryModel: GeometryModel
    var colorMap: Texture
    var normalMap: Texture
    var specularMap: Texture
    var rayBoxColorMap: RenderedTexture
    var materialProperties: MaterialProperties
    
    init(vao: VAO,
         geometryModel: GeometryModel,
         colorMap: Texture,
         normalMap: Texture,
         specularMap: Texture,
         rayBoxColorMap: RenderedTexture,
         materialProperties: MaterialProperties) {
        self.geometryModel = geometryModel
        self.colorMap = colorMap
        self.normalMap = normalMap
        self.specularMap = specularMap
        self.rayBoxColorMap = rayBoxColorMap
        self.materialProperties = materialProperties
        super.init(vao: vao)
    }
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

class EmitterRenderable: BasicRenderable, Model, Emitter {
    var geometryModel: GeometryModel
    var emittingColor: Color
    
    init(vao: VAO,
         geometryModel: GeometryModel,
         emittingColor: Color) {
        self.geometryModel = geometryModel
        self.emittingColor = emittingColor
        super.init(vao: vao)
    }
}

class CubeMapBlurrer: BasicRenderable, CubeTextureBlur {
    var blurringContext: CubeTextureBlurringContext
    
    init(vao: VAO, blurringContext: CubeTextureBlurringContext) {
        self.blurringContext = blurringContext
        super.init(vao: vao)
    }
}
