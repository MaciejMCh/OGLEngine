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
    case Emitter
    
    static func serialzie(string: String) -> RenderableType {
        switch string {
        case "REFLECTIVE_SURFACE": return .Reflective
        case "emitter": return .Emitter
        case "REGULAR": return .Default
        default:
            assert(false, "unsuppoerted renderable type")
            return .Default
        }
    }
}

struct LoadedRenderable {
    let name: String
    let mesh: String
    let material: String!
    let geometry: LoadedGeometry
    let type: RenderableType
    let color: Color!
    
    init(json: [String: AnyObject]) {
        self.name = json["name"] as! String
        self.mesh = json["mesh"] as! String
        self.material = json["material"] as? String
        self.geometry = LoadedGeometry(json: json["transformation"] as! [String: AnyObject])
        self.type = RenderableType.serialzie(json["type"] as! String)
        if var color = json["color"] as? [Float] {
            self.color = (r: color[0], g: color[1], b: color[2], a: color[3])
        } else {
            self.color = nil
        }
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
            var emitterRenderables: [EmitterRenderable] = []
            var idealRenderables: [LighModelIdeaRenderable] = []
            for loadedRenderable in loadedRenderables {
                switch loadedRenderable.type {
//                case .Default: mediumShotRenderables.append(MediumShotRenderable(loadedRenderable: loadedRenderable))
//                case .Default: closeShotRenderables.append(CloseShotRenderable(loadedRenderable: loadedRenderable))
                case .Default: idealRenderables.append(LighModelIdeaRenderable(loadedRenderable: loadedRenderable))
                case .Reflective: reflectiveSurfaces.append(ReflectiveSurfaceRenderable(loadedRenderable: loadedRenderable))
                case .Emitter: emitterRenderables.append(EmitterRenderable(loadedRenderable: loadedRenderable))
                }
            }
            
            // Light
            let directionalLight = DirectionalLight(lightDirection:  GLKVector3Normalize(GLKVector3Make(0, 1, -1)))
            
            // Camera
            let camera = RemoteLookAtCamera()
            camera.lockAtPosition(GLKVector3Make(0, 0, 4))
            
            var scene = Scene(
                closeShots: closeShotRenderables,
                mediumShots: mediumShotRenderables,
                reflectiveSurfaces: reflectiveSurfaces,
                emitterRenderables: emitterRenderables,
                directionalLight: directionalLight,
                camera: camera)
            scene.idealRenderables = idealRenderables
            return scene
            
        } catch _ {
            return nil
        }
    }
}

extension MaterialProperties {
    convenience init!(materialName: String) {
        guard let fileData = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("3dAssets/materials/\(materialName)/properties", ofType: "material")!) else {return nil}
        guard let json = try? NSJSONSerialization.JSONObjectWithData(fileData, options: .MutableContainers) as! [String: AnyObject] else {return nil}
        let specularPower = json["specular_power"] as? Float ?? -1.0
        let specularSharpness = json["specular_sharpness"] as? Float ?? -1.0
        let fresnelA = json["fresnel_a"] as? Float ?? -1.0
        let fresnelB = json["fresnel_b"] as? Float ?? -1.0
        self.init(specularPower: specularPower, specularSharpness: specularSharpness, fresnelA: fresnelA, fresnelB: fresnelB)
    }
}

extension LighModelIdeaRenderable {
    convenience init(loadedRenderable: LoadedRenderable) {
        let vao = VAO(obj: OBJLoader.objFromFileNamed("3dAssets/meshes/" + loadedRenderable.mesh))
        let geometryModel = AxesGeometryModel(position: loadedRenderable.geometry.position, axesRotation: loadedRenderable.geometry.orientation)
        
        let colorMap = ImageTexture(imageNamed: "3dAssets/materials/" + loadedRenderable.material + "/diffuse.png")
        colorMap.bind()
        let normalMap = ImageTexture(imageNamed: "3dAssets/materials/" + loadedRenderable.material + "/normal.png")
        normalMap.bind()
        let specularMap = ImageTexture(imageNamed: "3dAssets/materials/" + loadedRenderable.material + "/specular.png")
        specularMap.bind()
        let materialProperties = MaterialProperties(materialName: loadedRenderable.material)
        self.init(vao: vao, geometryModel: geometryModel, colorMap: colorMap, normalMap: normalMap, specularMap: specularMap, rayBoxColorMap: RayBox.instance.colorMap, materialProperties: materialProperties)
    }
}

extension CloseShotRenderable {
    init(loadedRenderable: LoadedRenderable) {
        self.vao = VAO(obj: OBJLoader.objFromFileNamed("3dAssets/meshes/" + loadedRenderable.mesh))
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
        self.vao = VAO(obj: OBJLoader.objFromFileNamed("3dAssets/meshes/" + loadedRenderable.mesh))
        self.geometryModel = AxesGeometryModel(position: loadedRenderable.geometry.position, axesRotation: loadedRenderable.geometry.orientation)
        
        self.colorMap = ImageTexture(imageNamed: "3dAssets/materials/" + loadedRenderable.material + "/diffuse.png")
        self.colorMap.bind()
    }
}

extension ReflectiveSurfaceRenderable {
    init(loadedRenderable: LoadedRenderable) {
        let obj = OBJLoader.objFromFileNamed("3dAssets/meshes/" + loadedRenderable.mesh)
        self.vao = VAO(obj: obj)
        self.geometryModel = AxesGeometryModel(position: loadedRenderable.geometry.position, axesRotation: loadedRenderable.geometry.orientation)
        self.reflectionColorMap = RenderedTexture()
    }
}

extension EmitterRenderable {
    convenience init(loadedRenderable: LoadedRenderable) {
        let obj = OBJLoader.objFromFileNamed("3dAssets/meshes/" + loadedRenderable.mesh)
        let vao = VAO(obj: obj)
        let geometryModel = AxesGeometryModel(position: loadedRenderable.geometry.position, axesRotation: loadedRenderable.geometry.orientation)
        let emittingColor = loadedRenderable.color
        
        self.init(vao: vao, geometryModel: geometryModel, emittingColor: emittingColor)
    }
}