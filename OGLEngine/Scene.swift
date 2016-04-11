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
    
    var closeShots: [CloseShotRenderable] = []
    var mediumShots: [MediumShotRenderable] = []
    
    var directionalLight: DirectionalLight! = nil
    var camera: Camera! = nil
    
    
    init() {
        
        // Light
        self.directionalLight = DirectionalLight(lightDirection: GLKVector3Make(0, -1, -1))
        
        // Camera
        let camera: RemoteControlledCamera = RemoteControlledCamera()
        camera.yOffset = -2
        camera.zOffset = -1
        camera.xMouse = Float(M_PI_2)
        camera.yMouse = Float(M_PI_4)
        self.camera = camera
        
        // VAOs
        let torusVao: VAO = VAO(obj: OBJLoader.objFromFileNamed("paczek"))
        let cubeVao: VAO = VAO(obj: OBJLoader.objFromFileNamed("cube_tex"))
        let axesVao: VAO = VAO(obj: OBJLoader.objFromFileNamed("axes"))
        
        // Textures
        let bricksColorMap = Texture(imageNamed: "bricks_colors")
        let blackColorMap = Texture(color: UIColor.blackColor())
        let bricksNormalMap = Texture(imageNamed: "bricks_normals")
        bricksColorMap.bind()
        blackColorMap.bind()
        bricksNormalMap.bind()
        
        // Renderables
        
        // Medium shots
        let axes = MediumShotRenderable(vao: axesVao, geometryModel: StaticGeometryModel(position: GLKVector3Make(0, 0, 0)), colorMap: blackColorMap)
        let mediumShotTorus = MediumShotRenderable(vao: torusVao, geometryModel: StaticGeometryModel(position: GLKVector3Make(-3, 0, 0)), colorMap: bricksColorMap)
        let mediumShotCube =  MediumShotRenderable(vao: cubeVao, geometryModel: StaticGeometryModel(position: GLKVector3Make(3, 0, 0)), colorMap: bricksColorMap)
        
        // Close shots
        let closeShotTorus = CloseShotRenderable(vao: torusVao, geometryModel: StaticGeometryModel(position: GLKVector3Make(-3, 0, 3)), colorMap: bricksColorMap, normalMap: bricksNormalMap)
        let closeShotCube = CloseShotRenderable(vao: cubeVao, geometryModel: StaticGeometryModel(position: GLKVector3Make(3, 0, 3)), colorMap: bricksColorMap, normalMap: bricksNormalMap)
        
        
        self.mediumShots = [axes, mediumShotTorus, mediumShotCube]
        self.closeShots = [closeShotTorus, closeShotCube]
        
    }
    
}