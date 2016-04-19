//
//  HouseOnCliffScene.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 14.04.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

extension DefaultScenes {
    static func houseOnCliffScene() -> Scene {
        
        // Light
        let directionalLight = DirectionalLight(lightDirection: GLKVector3Make(0, 0, -1))
        
        // Camera
        let camera: RemoteControlledCamera = RemoteControlledCamera()
        camera.zOffset = -10
        camera.xMouse = Float(M_PI_2)
        camera.yMouse = Float(M_PI_4)
        
        // VAOs
        let rockyGroundVao = VAO(obj: OBJLoader.objFromFileNamed("rocky_ground"))
        
        // Textures
        let rockyGroundColors = Texture(imageNamed: "cliff color")
        let rockyGroundNormals = Texture(imageNamed: "cliff normal")
        
        rockyGroundColors.bind()
        rockyGroundNormals.bind()
        
        // Close shots
        let rockyGround = CloseShotRenderable(vao: rockyGroundVao, geometryModel: StaticGeometryModel(orientation: GLKVector3Make(Float(-M_PI_2), 0, 0)), colorMap: rockyGroundColors, normalMap: rockyGroundNormals, textureScale: 3.0)
        
        return Scene(closeShots: [rockyGround], mediumShots: [], directionalLight: directionalLight, camera: camera)
    }
}