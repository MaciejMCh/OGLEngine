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
        var cubeVao: VAO = VAO(OBJ: OBJLoader.objFromFileNamed("cube"))
        var torusVao: VAO = VAO(OBJ: OBJLoader.objFromFileNamed("paczek"))
        var cubeTexVao: VAO = VAO(OBJ: OBJLoader.objFromFileNamed("cube_tex"))
        var axesVao: VAO = VAO(OBJ: OBJLoader.objFromFileNamed("axes"))
        //    VAO *groundVao = [[VAO alloc] initWithOBJ:[OBJ square]];
        // Textures
        var orangeTexture: Texture = Texture(color: UIColor.orangeColor())
        var grayTexture: Texture = Texture(color: UIColor.grayColor())
        var axesTexture: Texture = Texture(imageNamed: "axes_rgb")
        var groundTexture: Texture = Texture(color: UIColor.brownColor())
        orangeTexture.bind()
        grayTexture.bind()
        axesTexture.bind()
        groundTexture.bind()
        // Geometry models
        var spinningGeometryModel: SpinningGeometryModel = SpinningGeometryModel(position: GLKVector3Make(0, 0, 0))
        var originGeometryModel: StaticGeometryModel = StaticGeometryModel(position: GLKVector3Make(0, 0, 0))
        var mat: GLKMatrix4 = originGeometryModel.modelMatrix()
        //    [originGeometryModel wtf:GLKMatrix4Identity];
        var xGeometryModel: StaticGeometryModel = StaticGeometryModel(position: GLKVector3Make(1, 0, 0))
        var yGeometryModel: StaticGeometryModel = StaticGeometryModel(position: GLKVector3Make(0, 1, 0))
        var zGeometryModel: StaticGeometryModel = StaticGeometryModel(position: GLKVector3Make(0, 0, 1))
        var standingGeometryModel: StaticGeometryModel = StaticGeometryModel(position: GLKVector3Make(5, 0, 0))
        //    StaticGeometryModel *groundGeometryModel = [[StaticGeometryModel alloc] initWithModelMatrix:GLKMatrix4MakeScale(100, 100, 0.01)];
        // Renderables
        self.renderables.append(Renderable(vao: torusVao, geometryModel: standingGeometryModel, texture: orangeTexture))
        self.renderables.append(Renderable(vao: axesVao, geometryModel: originGeometryModel, texture: axesTexture))
        //    [self.renderables addObject:[[Renderable alloc] initWithVao:axesVao geometryModel:xGeometryModel texture:axesTexture]];
        //    [self.renderables addObject:[[Renderable alloc] initWithVao:axesVao geometryModel:yGeometryModel texture:axesTexture]];
        //    [self.renderables addObject:[[Renderable alloc] initWithVao:axesVao geometryModel:zGeometryModel texture:axesTexture]];
        //    [self.renderables addObject:[[Renderable alloc] initWithVao:groundVao geometryModel:originGeometryModel texture:groundTexture]];
        self.renderables.append(Renderable(vao: cubeTexVao, geometryModel: originGeometryModel, texture: orangeTexture))
        var gridRadius: Int = 5
        for var i = -gridRadius; i < gridRadius; i++ {
            var model: GLKMatrix4 = GLKMatrix4MakeScale(0.01, 10, 0.01)
            model = GLKMatrix4Translate(model, Float(i) * 100, 0, 0)
            //        StaticGeometryModel *geometry = [[StaticGeometryModel alloc] initWithPosition:GLKVector3Make(i * 100, 0, 0) scale:GLKVector3Make(.01, 10, .01)];
            //            [self.renderables addObject:[[Renderable alloc] initWithVao:cubeVao geometryModel:geometry texture:grayTexture]];
        }
        for var i = -gridRadius; i < gridRadius; i++ {
            var model: GLKMatrix4 = GLKMatrix4MakeScale(10, 0.01, 0.01)
            model = GLKMatrix4Translate(model, 0, Float(i) * 100, 0)
            //        StaticGeometryModel *geometry = [[StaticGeometryModel alloc] initWithModelMatrix:model];
            //        [self.renderables addObject:[[Renderable alloc] initWithVao:cubeVao geometryModel:geometry texture:grayTexture]];
        }
        // Light
        self.directionalLight = DirectionalLight(lightDirection: GLKVector3Make(0, -1, -1))
        // Normal map
        self.normalMap = Texture(imageNamed: "normalMap")
        self.normalMap.bind()
        // Camera
        var camera: RemoteControlledCamera = RemoteControlledCamera()
        camera.yOffset = -2
        camera.zOffset = -1
        camera.xMouse = Float(M_PI_2)
        camera.yMouse = Float(M_PI_4)
        self.camera = camera
//        self.camera = BasicCamera2(position: GLKVector3Make(0, 0, -3), orientation:GLKVector3Make(0, 0, 0))
    }
    
}