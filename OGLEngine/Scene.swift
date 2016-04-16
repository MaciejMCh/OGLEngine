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
    
    var directionalLight: DirectionalLight
    var camera: Camera
    
    init(closeShots: [CloseShotRenderable], mediumShots: [MediumShotRenderable], directionalLight: DirectionalLight, camera: Camera) {
        self.closeShots = closeShots
        self.mediumShots = mediumShots
        self.directionalLight = directionalLight
        self.camera = camera
    }
    
}


struct DefaultScenes {
    
}