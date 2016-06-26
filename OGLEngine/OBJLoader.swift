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
    
    init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    func sub(vec3: Vec3) -> Vec3 {
        return Vec3(x: self.x - vec3.x,
                    y: self.y - vec3.y,
                    z: self.z - vec3.z)
    }
    
    func scale(s: Float) -> Vec3 {
        return Vec3(x: self.x * s,
                    y: self.y * s,
                    z: self.z * s)
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
    
    init(u: Float, v: Float) {
        self.u = u
        self.v = v
    }
    
    func sub(vec2: Vec2) -> Vec2 {
        return Vec2(u: self.u - vec2.u, v: self.v - vec2.v)
    }
}

struct Vertex {
    let indexIdentifier: VertexIndices
    let position: Vec3
    let texel: Vec2
    let normal: Vec3
    let tangent: Vec3?
}

func normalVersor(v1: Vec3, v2: Vec3) -> Vec3 {
    let gv1 = GLKVector3Make(v1.x, v1.y, v1.z)
    let gv2 = GLKVector3Make(v2.x, v2.y, v2.z)
    let res = GLKVector3Normalize(GLKVector3CrossProduct(gv1, gv2))
    return Vec3(x: res.x, y: res.y, z: res.z)
}

func dot(v1: Vec3, gv2: GLKVector3) -> Float {
    let gv1 = GLKVector3Make(v1.x, v1.y, v1.z)
    return GLKVector3DotProduct(gv1, gv2)
}


public func ==(lhs: VertexIndices, rhs: VertexIndices) -> Bool {
    if (lhs.p != rhs.p) {
        return false
    }
    if (lhs.t != rhs.t) {
        return false
    }
    if (lhs.n != rhs.n) {
        return false
    }
    return true
}

public struct VertexIndices: Equatable {
    let p: Int
    let t: Int
    let n: Int
    
    init(line: String) {
        let c = line.componentsSeparatedByString("/")
        self.p = Int(c[0])!
        self.t = Int(c[1])!
        self.n = Int(c[2])!
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
        debugPrint(" will load obj")
        let filePath: String = NSBundle.mainBundle().pathForResource("3dAssets/meshes/" + fileName, ofType: "obj")!
        
        var payload = ""
        do {
            try payload = String(contentsOfFile: filePath)
        } catch _ {
            assert(false, "Could not read file")
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
        debugPrint("  did read file")
        let indicesToVertex = { (indices: VertexIndices) -> Vertex in
            return Vertex(indexIdentifier: indices,
                          position: positions[indices.p - 1],
                          texel: texels[indices.t - 1],
                          normal: normals[indices.n - 1],
                          tangent: nil)
        }
        
        let faces = facesIndices.map{
            Face(v1: indicesToVertex($0.v1), v2: indicesToVertex($0.v2), v3: indicesToVertex($0.v3))
        }
        
        
        let tangentFaces = faces.map { (let face) -> Face in
            let independent = Vec3(x: 0, y: 0, z: 1)
            let tangent1 = normalVersor(face.v1.normal, v2: independent)
            let tangent2 = normalVersor(face.v2.normal, v2: independent)
            let tangent3 = normalVersor(face.v3.normal, v2: independent)
                return Face(
                    v1: Vertex(
                        indexIdentifier: face.v1.indexIdentifier,
                        position: face.v1.position,
                        texel: face.v1.texel,
                        normal: face.v1.normal,
                        tangent: tangent1),
                    v2: Vertex(
                        indexIdentifier: face.v2.indexIdentifier,
                        position: face.v2.position,
                        texel: face.v2.texel,
                        normal: face.v2.normal,
                        tangent: tangent2),
                    v3: Vertex(
                        indexIdentifier: face.v3.indexIdentifier,
                        position: face.v3.position,
                        texel: face.v3.texel,
                        normal: face.v3.normal,
                        tangent: tangent3))
        }
        debugPrint("  did calculate tangents")
        
        let verticesInOrder = tangentFaces.map{[$0.v1, $0.v2, $0.v3]}.stomp()
        debugPrint("  did sort vertices")
        
        var vertexDrawOrder: [Int] = []
        var drawnVertices: [VertexIndices] = []
        
//        let count = verticesInOrder.count
//        var i = 0
        let nonRepeatingVerticesInOrder = verticesInOrder.filter{
//            debugPrint("\(i)/\(count)")
//            i += 1;
//            if let index = drawnVertices.indexOf($0.indexIdentifier) {
//                vertexDrawOrder.append(index)
//                return false
//            } else {
                drawnVertices.append($0.indexIdentifier)
                vertexDrawOrder.append(drawnVertices.count - 1)
                return true
//            }
        }
        debugPrint("  did calculate indices")
        let positionsArray = nonRepeatingVerticesInOrder.map{$0.position}.map{[$0.x, $0.y, $0.z]}.stomp()
        let texelsArray = nonRepeatingVerticesInOrder.map{$0.texel}.map{[$0.u, $0.v]}.stomp()
        let normalsArray = nonRepeatingVerticesInOrder.map{$0.normal}.map{[$0.x, $0.y, $0.z]}.stomp()
        let tangentsArray = nonRepeatingVerticesInOrder.map{$0.tangent}.map{[$0!.x, $0!.y, $0!.z]}.stomp()
        
        debugPrint("did load obj")
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
