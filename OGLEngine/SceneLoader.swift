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
    let orientation: GLKVector3
    
    init(json: [String: AnyObject]) {
        let positionArray = json["position"] as! [Float]
        let orientationArray = json["rotation"] as! [Float]
        self.position = GLKVector3Make(positionArray[0], positionArray[1], positionArray[2])
        self.orientation = GLKVector3Make(orientationArray[0], orientationArray[1], orientationArray[2])
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
                switch loadedRenderable.type {
//                case .Default: closeShotRenderables.append(CloseShotRenderable(loadedRenderable: loadedRenderable))
                case .Default: mediumShotRenderables.append(MediumShotRenderable(loadedRenderable: loadedRenderable))
                case .Reflective: reflectiveSurfaces.append(ReflectiveSurfaceRenderable(loadedRenderable: loadedRenderable))
                }
            }
            
            // Light
            let directionalLight = DirectionalLight(lightDirection: GLKVector3Make(0, 0, -1))
            
            // Camera
            let camera = LookAtCamera()
            
            return Scene(closeShots: closeShotRenderables, mediumShots: mediumShotRenderables, reflectiveSurfaces: reflectiveSurfaces, directionalLight: directionalLight, camera: camera)
            
        } catch _ {
            return nil
        }
    }
}

extension CloseShotRenderable {
    init(loadedRenderable: LoadedRenderable) {
        self.vao = VAO(obj: OBJLoader.objFromFileNamed(loadedRenderable.mesh))
        self.geometryModel = SpinningGeometryModel(position: loadedRenderable.geometry.position, orientation: loadedRenderable.geometry.orientation)
        
        self.colorMap = Texture(imageNamed: "3dAssets/materials/" + loadedRenderable.material + "/diffuse.png")
        self.colorMap.bind()
        self.normalMap = Texture(imageNamed: "3dAssets/materials/" + loadedRenderable.material + "/normal.png")
        self.normalMap.bind()
        self.textureScale = 1
    }
}

extension MediumShotRenderable {
    init(loadedRenderable: LoadedRenderable) {
        self.vao = VAO(obj: OBJLoader.objFromFileNamed(loadedRenderable.mesh))
        self.geometryModel = SpinningGeometryModel(position: loadedRenderable.geometry.position, orientation: loadedRenderable.geometry.orientation)
        
        self.colorMap = Texture(imageNamed: "3dAssets/materials/" + loadedRenderable.material + "/diffuse.png")
        self.colorMap.bind()
        self.textureScale = 1
    }
}

extension ReflectiveSurfaceRenderable {
    init(loadedRenderable: LoadedRenderable) {
        let obj = OBJLoader.objFromFileNamed(loadedRenderable.mesh)
        self.vao = VAO(obj: obj)
        self.geometryModel = StaticGeometryModel(position: loadedRenderable.geometry.position, orientation: loadedRenderable.geometry.orientation)
        self.reflectionColorMap = RenderedTexture()
        
        let p1 = transformVector(GLKVector3Make(obj.positions[0], obj.positions[1], obj.positions[2]), transformation: self.geometryModel.modelMatrix())
        let p2 = transformVector(GLKVector3Make(obj.positions[3], obj.positions[4], obj.positions[5]), transformation: self.geometryModel.modelMatrix())
        let p3 = transformVector(GLKVector3Make(obj.positions[6], obj.positions[7], obj.positions[8]), transformation: self.geometryModel.modelMatrix())
        self.reflectionPlane = ReflectionPlane( p1: p1, p2: p2, p3: p3)
    }
}
