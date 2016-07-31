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
    
    var closeShots: [CloseShotRenderable]
    var mediumShots: [MediumShotRenderable]
    var reflectiveSurfaces: [ReflectiveSurfaceRenderable]
    
    var directionalLight: DirectionalLight
    var camera: Camera
    let elucidation = Elucidation()
    
    var skyBox: SkyBoxRenderable
    
    var rayBoxColorMap: RenderedTexture!
    
    init(closeShots: [CloseShotRenderable], mediumShots: [MediumShotRenderable], reflectiveSurfaces: [ReflectiveSurfaceRenderable], directionalLight: DirectionalLight, camera: Camera) {
        self.closeShots = closeShots
        self.mediumShots = mediumShots
        self.reflectiveSurfaces = reflectiveSurfaces
        self.directionalLight = directionalLight
        self.camera = camera
        self.skyBox = SkyBoxRenderable()
    }
    
    func reflecteds() -> [ReflectedRenderable] {
        var reflecteds: [ReflectedRenderable] = []
        for closeShot in self.closeShots {
            reflecteds.append(ReflectedRenderable(vao: closeShot.vao, geometryModel: closeShot.geometryModel, colorMap: closeShot.colorMap))
        }
        return reflecteds
    }
    
    func lighModelIdeaRenderables() -> [LighModelIdeaRenderable] {
        return closeShots.map{LighModelIdeaRenderable(
            vao: $0.vao,
            geometryModel: $0.geometryModel,
            colorMap: $0.colorMap,
            normalMap: $0.normalMap,
            specularMap: $0.specularMap,
            rayBoxColorMap: rayBoxColorMap)}
    }
    
}


struct DefaultScenes {
    
}