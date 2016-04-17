//
//  TestScene.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 14.04.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

extension DefaultScenes {
    static func testScene() -> Scene {
        // Light
        let directionalLight = DirectionalLight(lightDirection: GLKVector3Make(0, -1, -1))
        
        // Camera
        let camera: RemoteControlledCamera = RemoteControlledCamera()
        camera.yOffset = -2
        camera.zOffset = -1
        camera.xMouse = Float(M_PI_2)
        camera.yMouse = Float(M_PI_4)
        
        // VAOs
        let torusVao: VAO = VAO(obj: OBJLoader.objFromFileNamed("paczek"))
        let cubeVao: VAO = VAO(obj: OBJLoader.objFromFileNamed("cube_tex"))
        let axesVao: VAO = VAO(obj: OBJLoader.objFromFileNamed("axes"))
        let rockVao = VAO(obj: OBJLoader.objFromFileNamed("Rock"))
        
        // Textures
        let bricksColorMap = Texture(imageNamed: "cliff color")
        let blackColorMap = Texture(color: UIColor.blackColor())
        let bricksNormalMap = Texture(imageNamed: "cliff normal")
        bricksColorMap.bind()
        blackColorMap.bind()
        bricksNormalMap.bind()
        
        // Renderables
        
        // Medium shots
        let axes = MediumShotRenderable(vao: axesVao, geometryModel: StaticGeometryModel(position: GLKVector3Make(0, 0, 0)), colorMap: blackColorMap)
        let mediumShotTorus = MediumShotRenderable(vao: torusVao, geometryModel: StaticGeometryModel(position: GLKVector3Make(-3, 0, 0)), colorMap: bricksColorMap)
        let mediumShotCube =  MediumShotRenderable(vao: cubeVao, geometryModel: SpinningGeometryModel(), colorMap: bricksColorMap)
        
        // Close shots
        let closeShotTorus = CloseShotRenderable(vao: torusVao, geometryModel: StaticGeometryModel(position: GLKVector3Make(-3, 0, 3)), colorMap: bricksColorMap, normalMap: bricksNormalMap)
        let closeShotCube = CloseShotRenderable(vao: cubeVao, geometryModel: StaticGeometryModel(position: GLKVector3Make(3, 0, 3)), colorMap: bricksColorMap, normalMap: bricksNormalMap)
        let rock = CloseShotRenderable(vao: rockVao, geometryModel: StaticGeometryModel(position: GLKVector3Make(0, 3, 0)), colorMap: bricksColorMap, normalMap: bricksNormalMap)
        
        let closeShotBaldCube = CloseShotRenderable(vao: cubeVao, geometryModel: SpinningGeometryModel(), colorMap: bricksColorMap, normalMap: bricksNormalMap)
        
        return Scene(closeShots: [closeShotTorus, closeShotCube, rock, closeShotBaldCube], mediumShots: [axes, mediumShotTorus], directionalLight: directionalLight, camera: camera)
    }
}