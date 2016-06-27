//
//  SceneLoader.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 21.04.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation
import GLKit

struct LoadedGeometry {
    let position: GLKVector3
    let orientation: AxesRotation
    
    init(json: [String: AnyObject]) {
        let positionArray = json["position"] as! [Float]
        let orientationModel = json["rotation"] as! [String: Float]
        self.position = GLKVector3Make(positionArray[0], positionArray[1], positionArray[2])
        self.orientation = AxesRotation(angle: orientationModel["angle"]!, x: orientationModel["x"]!, y: orientationModel["y"]!, z: orientationModel["z"]!)
    }
}

enum RenderableType {
    case Default
    case Reflective
    
    static func serialzie(string: String) -> RenderableType {
        switch string {
        case "reflective": return .Reflective
        case "default": return .Default
        default: return .Default
        }
    }
}

struct LoadedRenderable {
    let name: String
    let mesh: String
    let material: String
    let geometry: LoadedGeometry
    let type: RenderableType
    
    init(json: [String: AnyObject]) {
        self.name = json["name"] as! String
        self.mesh = json["mesh"] as! String
        self.material = json["material"] as! String
        self.geometry = LoadedGeometry(json: json["transformation"] as! [String: AnyObject])
        self.type = RenderableType.serialzie(json["type"] as! String)
    }
}

extension Scene {
    static func loadScene(name: String) -> Scene! {
        guard let fileData = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("3dAssets/scenes/" + name, ofType: "scene")!) else {
            return nil
        }
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(fileData, options: .MutableContainers) as! [String: AnyObject]
            let jsonArray = json["renderables"]
            
            var loadedRenderables: [LoadedRenderable] = []
            for element in jsonArray as! NSArray {
                let loadedRenderable = LoadedRenderable(json: element as! [String : AnyObject])
                loadedRenderables.append(loadedRenderable)
            }
            
            var closeShotRenderables: [CloseShotRenderable] = []
            var mediumShotRenderables: [MediumShotRenderable] = []
            var reflectiveSurfaces: [ReflectiveSurfaceRenderable] = []
            for loadedRenderable in loadedRenderables {
                debugPrint("loading object \(loadedRenderable.name)")
                switch loadedRenderable.type {
                case .Default: closeShotRenderables.append(CloseShotRenderable(loadedRenderable: loadedRenderable))
                case .Reflective: reflectiveSurfaces.append(ReflectiveSurfaceRenderable(loadedRenderable: loadedRenderable))
                }
            }
            debugPrint("vaos ready")
            
            // Light
            let directionalLight = DirectionalLight(lightDirection:  GLKVector3Normalize(GLKVector3Make(0, 1, -1)))
            
            // Camera
            let camera = RemoteLookAtCamera()
            camera.lockAtPosition(GLKVector3Make(0, 0, 4))
            
            return Scene(closeShots: closeShotRenderables, mediumShots: mediumShotRenderables, reflectiveSurfaces: reflectiveSurfaces, directionalLight: directionalLight, camera: camera)
            
        } catch _ {
            return nil
        }
    }
}

extension CloseShotRenderable {
    init(loadedRenderable: LoadedRenderable) {
        self.vao = VAO(obj: OBJLoader.objFromFileNamed(loadedRenderable.mesh))
        self.geometryModel = AxesGeometryModel(position: loadedRenderable.geometry.position, axesRotation: loadedRenderable.geometry.orientation)
        
        self.colorMap = ImageTexture(imageNamed: "3dAssets/materials/" + loadedRenderable.material + "/diffuse.png")
        self.colorMap.bind()
        self.normalMap = ImageTexture(imageNamed: "3dAssets/materials/" + loadedRenderable.material + "/normal.png")
        self.normalMap.bind()
        self.specularMap = ImageTexture(imageNamed: "3dAssets/materials/" + loadedRenderable.material + "/specular.png")
        self.specularMap.bind()
    }
}

extension MediumShotRenderable {
    init(loadedRenderable: LoadedRenderable) {
        self.vao = VAO(obj: OBJLoader.objFromFileNamed(loadedRenderable.mesh))
        self.geometryModel = AxesGeometryModel(position: loadedRenderable.geometry.position, axesRotation: loadedRenderable.geometry.orientation)
        
        self.colorMap = ImageTexture(imageNamed: "3dAssets/materials/" + loadedRenderable.material + "/diffuse.png")
        self.colorMap.bind()
    }
}

extension ReflectiveSurfaceRenderable {
    init(loadedRenderable: LoadedRenderable) {
        let obj = OBJLoader.objFromFileNamed(loadedRenderable.mesh)
        self.vao = VAO(obj: obj)
        self.geometryModel = AxesGeometryModel(position: loadedRenderable.geometry.position, axesRotation: loadedRenderable.geometry.orientation)
        self.reflectionColorMap = RenderedTexture()
    }
}
