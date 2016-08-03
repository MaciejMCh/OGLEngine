//
//  MaterialBallScene.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 31.07.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

extension Scene {
    static func materialBallSceneWithMaterial(material: String, creatorMode: Bool) -> Scene {
        let pathToResource = "3dAssets/materials/\(material)/"
        let diffuse = ImageTexture(imageNamed: pathToResource + "diffuse.png")
        let normal = ImageTexture(imageNamed: pathToResource + "normal.png")
        let specular = ImageTexture(imageNamed: pathToResource + "specular.png")
        
        diffuse.bind()
        normal.bind()
        specular.bind()
        
        let geometryModel = StaticGeometryModel(position: GLKVector3Make(1.5, 3.0, -3.0))
        let materialProperties = creatorMode ? CreatingMaterialProperties() : MaterialProperties(materialName: material)
        
        let core = LighModelIdeaRenderable(
            vao: VAO(obj: OBJLoader.objFromFileNamed("material_core")),
            geometryModel: geometryModel,
            colorMap: diffuse,
            normalMap: normal,
            specularMap: specular,
            rayBoxColorMap: RayBox.instance.colorMap,
            materialProperties: materialProperties)
        
        let surface = LighModelIdeaRenderable(
            vao: VAO(obj: OBJLoader.objFromFileNamed("material_surface")),
            geometryModel: geometryModel,
            colorMap: diffuse,
            normalMap: normal,
            specularMap: specular,
            rayBoxColorMap: RayBox.instance.colorMap,
            materialProperties: materialProperties)
        
        var scene = Scene(
            closeShots: [],
            mediumShots: [],
            reflectiveSurfaces: [],
            directionalLight: DirectionalLight(),
            camera: RemoteLookAtCamera())
        
        scene.idealRenderables = [core, surface]
        return scene
    }
}

class CreatingMaterialProperties: MaterialProperties {
    init() {
        super.init(specularPower: -1.0, specularSharpness: -1.0, fresnelA: -1.0, fresnelB: -1.0)
        RemotePropertiesCenter.sharedInstance.listenToPropertyChange("power") { (property) in
            self.specularPower = property as! Float
        }
        RemotePropertiesCenter.sharedInstance.listenToPropertyChange("width") { (property) in
            self.specularSharpness = property as! Float
        }
        RemotePropertiesCenter.sharedInstance.listenToPropertyChange("fresnelA") { (property) in
            self.fresnelA = property as! Float
        }
        RemotePropertiesCenter.sharedInstance.listenToPropertyChange("fresnelB") { (property) in
            self.fresnelB = property as! Float
        }
    }
}