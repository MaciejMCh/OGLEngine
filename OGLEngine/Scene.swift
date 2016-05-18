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

class Scene {
    
    var closeShots: [CloseShotRenderable]
    var mediumShots: [MediumShotRenderable]
    var reflectiveSurfaces: [ReflectiveSurfaceRenderable]
    
    var directionalLight: DirectionalLight
    var camera: Camera
    
    init(closeShots: [CloseShotRenderable], mediumShots: [MediumShotRenderable], reflectiveSurfaces: [ReflectiveSurfaceRenderable], directionalLight: DirectionalLight, camera: Camera) {
        self.closeShots = closeShots
        self.mediumShots = mediumShots
        self.reflectiveSurfaces = reflectiveSurfaces
        self.directionalLight = directionalLight
        self.camera = camera
    }
    
    func reflecteds() -> [ReflectedRenderable] {
        var reflecteds: [ReflectedRenderable] = []
        for closeShot in self.closeShots {
            reflecteds.append(ReflectedRenderable(vao: closeShot.vao, geometryModel: closeShot.geometryModel, colorMap: closeShot.colorMap, textureScale: closeShot.textureScale))
        }
        return reflecteds
    }
    
}


struct DefaultScenes {
    
}