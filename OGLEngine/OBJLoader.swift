//
//  OBJLoader.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 24.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation
import GLKit

struct Vec3 {
    let x: Float
    let y: Float
    let z: Float
    
    init(line: String) {
        let c = line.componentsSeparatedByString(" ")
        self.x = Float(c[1])!
        self.y = Float(c[2])!
        self.z = Float(c[3])!
    }
    
    func sub(vec3: Vec3) -> Vec3 {
        return self
    }
    
    func scale(s: Float) -> Vec3 {
        return self
    }
}

struct Vec2 {
    let u: Float
    let v: Float
    
    init(line: String) {
        let c = line.componentsSeparatedByString(" ")
        self.u = Float(c[1])!
        self.v = Float(c[2])!
    }
    
    func sub(vec2: Vec2) -> Vec2 {
        return self
    }
}

struct Vertex {
    let indexIdentifier: String
    let position: Vec3
    let texel: Vec2
    let normal: Vec3
    let tangent: Vec3?
}

struct VertexIndices {
    let p: Int
    let t: Int
    let n: Int
    
    init(line: String) {
        let c = line.componentsSeparatedByString("/")
        self.p = Int(c[0])!
        self.t = Int(c[1])!
        self.n = Int(c[2])!
    }
    
    func indexIdentifier() -> String {
        return "\(self.p)/\(self.t)/\(self.n)"
    }
}

struct FaceIndices {
    let v1: VertexIndices
    let v2: VertexIndices
    let v3: VertexIndices
    
    init(line: String) {
        let c = line.componentsSeparatedByString(" ")
        self.v1 = VertexIndices(line: c[1])
        self.v2 = VertexIndices(line: c[2])
        self.v3 = VertexIndices(line: c[3])
    }
}

struct Face {
    let v1: Vertex
    let v2: Vertex
    let v3: Vertex
}

class OBJLoader : NSObject {
    
    class func objFromFileNamed(fileName: String) -> OBJ {
        let filePath: String = NSBundle.mainBundle().pathForResource("3dAssets/meshes/" + fileName, ofType: "obj")!
        
        var payload = ""
        do {
            try payload = String(contentsOfFile: filePath)
        } catch _ {
        }
        let lines: [String] = payload.componentsSeparatedByString("\n")
        
        var positions: [Vec3] = []
        var texels: [Vec2] = []
        var normals: [Vec3] = []
        var facesIndices: [FaceIndices] = []
        
        for line in lines {
            if line.startIndex.distanceTo(line.endIndex) < 2 {
                continue
            }
            switch line.substringToIndex(line.startIndex.advancedBy(2)) {
            case "v ": positions.append(Vec3(line: line))
            case "vt": texels.append(Vec2(line: line))
            case "vn": normals.append(Vec3(line: line))
            case "f ": facesIndices.append(FaceIndices(line: line))
            default: break
            }
        }
        
        let indicesToVertex = { (indices: VertexIndices) -> Vertex in
            return Vertex(indexIdentifier: indices.indexIdentifier(),
                          position: positions[indices.p - 1],
                          texel: texels[indices.t - 1],
                          normal: normals[indices.n - 1],
                          tangent: nil)
        }
        
        let faces = facesIndices.map{
            Face(v1: indicesToVertex($0.v1), v2: indicesToVertex($0.v2), v3: indicesToVertex($0.v3))
        }
        
        
        let tangentFaces = faces.map { (let face) -> Face in
            let tangent = calculateTangents(face.v1, v1: face.v2, v2: face.v3)
                return Face(
                    v1: Vertex(
                        indexIdentifier: face.v1.indexIdentifier,
                        position: face.v1.position,
                        texel: face.v1.texel,
                        normal: face.v1.normal,
                        tangent: tangent),
                    v2: Vertex(
                        indexIdentifier: face.v2.indexIdentifier,
                        position: face.v2.position,
                        texel: face.v2.texel,
                        normal: face.v2.normal,
                        tangent: tangent),
                    v3: Vertex(
                        indexIdentifier: face.v3.indexIdentifier,
                        position: face.v3.position,
                        texel: face.v3.texel,
                        normal: face.v3.normal,
                        tangent: tangent))
        }
        
        let verticesInOrder = tangentFaces.map{[$0.v1, $0.v2, $0.v3]}.stomp()
        
        var vertexDrawOrder: [Int] = []
        var drawnVertices: [String] = []
        
        let nonRepeatingVerticesInOrder = verticesInOrder.filter{
            if (drawnVertices.contains($0.indexIdentifier)) {
                let existingIndex = drawnVertices.indexOf($0.indexIdentifier)!
                vertexDrawOrder.append(existingIndex)
                return false
            } else {
                drawnVertices.append($0.indexIdentifier)
                vertexDrawOrder.append(drawnVertices.count - 1)
                return true
            }
        }
        
        let positionsArray = nonRepeatingVerticesInOrder.map{$0.position}.map{[$0.x, $0.y, $0.z]}.stomp()
        let texelsArray = nonRepeatingVerticesInOrder.map{$0.texel}.map{[$0.u, $0.v]}.stomp()
        let normalsArray = nonRepeatingVerticesInOrder.map{$0.normal}.map{[$0.x, $0.y, $0.z]}.stomp()
        let tangentsArray = nonRepeatingVerticesInOrder.map{$0.tangent}.map{[$0!.x, $0!.y, $0!.z]}.stomp()
        
        return OBJ(indices: vertexDrawOrder, positions: positionsArray, texels: texelsArray, normals: normalsArray, tangents: tangentsArray)
    }
    
}

func calculateTangents(v0: Vertex, v1: Vertex, v2: Vertex) -> Vec3 {
    var delatPos1 = v1.position.sub(v0.position)
//    Vector3f delatPos1 = Vector3f.sub(v1.getPosition(), v0.getPosition(), null);
    var delatPos2 = v2.position.sub(v0.position)
//    Vector3f delatPos2 = Vector3f.sub(v2.getPosition(), v0.getPosition(), null);
    
//    Vector2f uv0 = textures.get(v0.getTextureIndex());
//    Vector2f uv1 = textures.get(v1.getTextureIndex());
//    Vector2f uv2 = textures.get(v2.getTextureIndex());
    let deltaUv1 = v1.texel.sub(v0.texel)
//    Vector2f deltaUv1 = Vector2f.sub(uv1, uv0, null);
    let deltaUv2 = v2.texel.sub(v0.texel)
//    Vector2f deltaUv2 = Vector2f.sub(uv2, uv0, null);
//    
//    float r = 1.0f / (deltaUv1.x * deltaUv2.y - deltaUv1.y * deltaUv2.x);
    let r = 1 / (deltaUv1.u * deltaUv2.v - deltaUv1.v * deltaUv2.u)
//    delatPos1.scale(deltaUv2.y);
    delatPos1 = delatPos1.scale(deltaUv2.v)
//    delatPos2.scale(deltaUv1.y);
    delatPos2 = delatPos2.scale(deltaUv1.v)
//    Vector3f tangent = Vector3f.sub(delatPos1, delatPos2, null);
    var tangent = delatPos1.sub(delatPos2)
//    tangent.scale(r);
    tangent = tangent.scale(r)
//    v0.addTangent(tangent);
//    v1.addTangent(tangent);
//    v2.addTangent(tangent);
    
    return tangent
}

func rotationFromVector(formVector: GLKVector3, toVector: GLKVector3) -> GLKMatrix3 {
    let dot = GLKVector3DotProduct(formVector, toVector);
    switch dot {
    case 1: return GLKMatrix3Identity
    case -1: return GLKMatrix3MakeRotation(Float(M_PI), 1, 0, 0)
    default: break
    }
    
    let axis = GLKVector3Normalize(GLKVector3CrossProduct(formVector, toVector));
    let radians = acosf(dot);
    let mat = GLKMatrix3RotateWithVector3(GLKMatrix3Identity, radians, axis);
    return mat;
}

extension Array where Element : CollectionType {
    func stomp() -> [Element.Generator.Element] {
        var result: [Element.Generator.Element] = []
        for element in self {
            result.appendContentsOf(element)
        }
        return result
    }
}
