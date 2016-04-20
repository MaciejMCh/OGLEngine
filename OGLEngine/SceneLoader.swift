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
        let orientationArray = json["orientation"] as! [Float]
        self.position = GLKVector3Make(positionArray[0], positionArray[1], positionArray[2])
        self.orientation = GLKVector3Make(GLKMathDegreesToRadians(orientationArray[0]), GLKMathDegreesToRadians(orientationArray[1]), GLKMathDegreesToRadians(orientationArray[2]))
    }
}

struct LoadedRenderable {
    let name: String
    let mesh: String
    let material: String
    let geometry: LoadedGeometry
    
    init(json: [String: AnyObject]) {
        self.name = json["name"] as! String
        self.mesh = json["mesh"] as! String
        self.material = json["material"] as! String
        self.geometry = LoadedGeometry(json: json["geometry"] as! [String: AnyObject])
    }
}

extension Scene {
    static func loadScene(name: String) -> Scene! {
        guard let fileData = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource(name, ofType: "json")!) else {
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
            for loadedRenderable in loadedRenderables {
                closeShotRenderables.append(CloseShotRenderable(loadedRenderable: loadedRenderable))
            }
            
            // Light
            let directionalLight = DirectionalLight(lightDirection: GLKVector3Make(0, 0, -1))
            
            // Camera
            let camera: RemoteControlledCamera = RemoteControlledCamera()
            camera.zOffset = -1
            camera.xMouse = Float(M_PI_2)
            camera.yMouse = Float(M_PI_4)
            
            return Scene(closeShots: closeShotRenderables, mediumShots: [], directionalLight: directionalLight, camera: camera)
            
        } catch _ {
            return nil
        }
    }
}

extension CloseShotRenderable {
    init(loadedRenderable: LoadedRenderable) {
        self.vao = VAO(obj: OBJLoader.objFromFileNamed(loadedRenderable.mesh))
        self.geometryModel = StaticGeometryModel(position: loadedRenderable.geometry.orientation, orientation: loadedRenderable.geometry.orientation)
        
        self.colorMap = Texture(imageNamed: loadedRenderable.material + "_diffuse")
        self.colorMap.bind()
        self.normalMap = Texture(imageNamed: loadedRenderable.material + "_normal")
        self.normalMap.bind()
        self.textureScale = 1
    }
}
