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

class Scene : NSObject {
    var renderables: [Renderable] = []
    var directionalLight: DirectionalLight! = nil
    var normalMap: Texture! = nil
    var camera: Camera! = nil
    
    
    override init() {
        super.init()
        
        // VAOs
        let torusVao: VAO = VAO(OBJ: OBJLoader.objFromFileNamed("paczek"))
        let cubeTexVao: VAO = VAO(OBJ: OBJLoader.objFromFileNamed("cube_tex"))
        let axesVao: VAO = VAO(OBJ: OBJLoader.objFromFileNamed("axes"))
        
        // Textures
        let bricksTexture = Texture(imageNamed: "bricks_colors")
        let blackTexture = Texture(color: UIColor.blackColor())
        bricksTexture.bind()
        blackTexture.bind()
        
        // Renderables
        self.renderables.append(Renderable(vao: torusVao, geometryModel: StaticGeometryModel(position: GLKVector3Make(-3, 0, 0)), texture: bricksTexture))
        self.renderables.append(Renderable(vao: axesVao, geometryModel: StaticGeometryModel(position: GLKVector3Make(0, 0, 0)), texture: blackTexture))
        self.renderables.append(Renderable(vao: cubeTexVao, geometryModel: StaticGeometryModel(position: GLKVector3Make(3, 0, 0)), texture: bricksTexture))
        
        // Light
        self.directionalLight = DirectionalLight(lightDirection: GLKVector3Make(0, -1, -1))
        
        // Normal map
        self.normalMap = Texture(imageNamed: "bricks_normals")
        self.normalMap.bind()
        
        // Camera
        let camera: RemoteControlledCamera = RemoteControlledCamera()
        camera.yOffset = -2
        camera.zOffset = -1
        camera.xMouse = Float(M_PI_2)
        camera.yMouse = Float(M_PI_4)
        self.camera = camera
    }
    
}