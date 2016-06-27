//
//  MaterialsPreviewScene.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 27.06.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

extension Scene {
    static func MaterialsPreviewScene(meshName: String) -> Scene {
        let vao = VAO(obj: OBJLoader.objFromFileNamed(meshName))
        
        var materialNames: [String] = []
        do {
            let names = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(NSBundle.mainBundle().pathForResource("3dAssets/materials", ofType: nil)!)
            materialNames.appendContentsOf(names)
        } catch {
            assert(false, "could not read mesh directory")
        }
        
        var renderables: [CloseShotRenderable] = []
        var index = Int(0)
        for materialName in materialNames {
            let materialDirectoryPath = "3dAssets/materials/\(materialName)"
            var bitmapCount = 0
            do {
                bitmapCount = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(NSBundle.mainBundle().pathForResource(materialDirectoryPath, ofType: nil)!).count
            } catch {}
            if bitmapCount < 3 {
                continue
            }
            
            let diffuse = ImageTexture(imageNamed: materialDirectoryPath + "/diffuse.png")
            diffuse.bind()
            let normal = ImageTexture(imageNamed: materialDirectoryPath + "/normal.png")
            normal.bind()
            let specular = ImageTexture(imageNamed: materialDirectoryPath + "/specular.png")
            specular.bind()
            
            let geometryModel = StaticGeometryModel(position: GLKVector3Make(Float(3 * index), 0, 0))
            index += 1
            renderables.append(CloseShotRenderable(vao: vao, geometryModel: geometryModel, colorMap: diffuse, normalMap: normal, specularMap: specular))
        }
        
        return Scene(closeShots: renderables, mediumShots: [], reflectiveSurfaces: [], directionalLight: DirectionalLight(), camera: RemoteLookAtCamera())
    }
}