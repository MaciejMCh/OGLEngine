//
//  Scene.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 27.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation
import UIKit
import GLKit

struct Scene {
    var loadedRenderables: [LoadedRenderable]! = nil
    
    var closeShots: [CloseShotRenderable]
    var mediumShots: [MediumShotRenderable]
    var reflectiveSurfaces: [ReflectiveSurfaceRenderable]
    var idealRenderables: [LighModelIdeaRenderable]!
    var emitterRenderables: [EmitterRenderable]
    
    var directionalLight: DirectionalLight
    var camera: Camera
    let elucidation = Elucidation()
    
    var skyBox: SkyBox
    
    var rayBoxColorMap: RenderedTexture!
    
    var rayCubeTexture: CubeTexture!
    var emissionCubeTexture: CubeTexture!
    
    init(closeShots: [CloseShotRenderable] = [], mediumShots: [MediumShotRenderable] = [], reflectiveSurfaces: [ReflectiveSurfaceRenderable] = [], emitterRenderables: [EmitterRenderable] = [], directionalLight: DirectionalLight, camera: Camera) {
        self.closeShots = closeShots
        self.mediumShots = mediumShots
        self.reflectiveSurfaces = reflectiveSurfaces
        self.emitterRenderables = emitterRenderables
        self.directionalLight = directionalLight
        self.camera = camera
        self.skyBox = SkyBox(name: "morning")
    }
    
    func reflecteds() -> [ReflectedRenderable] {
        var reflecteds: [ReflectedRenderable] = []
        for closeShot in self.closeShots {
            reflecteds.append(ReflectedRenderable(vao: closeShot.vao, geometryModel: closeShot.geometryModel, colorMap: closeShot.colorMap))
        }
        return reflecteds
    }
}


struct DefaultScenes {
    
}