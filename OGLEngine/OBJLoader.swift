//
//  OBJLoader.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 24.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation

class OBJLoader : NSObject {
    
    class func objFromFileNamed(fileName: String) -> OBJ {
        let filePath: String = NSBundle.mainBundle().pathForResource(fileName, ofType: "obj")!
        
        var payload = ""
        do {
            try payload = String(contentsOfFile: filePath)
        } catch _ {
        }
        let lines: [String] = payload.componentsSeparatedByString("\n")
        
        typealias Position = (x: Float, y: Float, z: Float)
        typealias Normal = (x: Float, y: Float, z: Float)
        typealias Texel = (u: Float, v: Float)
        
        var positions: [Position] = []
        var texels: [Texel] = []
        var normals: [Normal] = []
        
        typealias VertexIndices = (p: Int, t: Int, n: Int)
        typealias FaceIndices = (v1: VertexIndices, v2: VertexIndices, v3: VertexIndices)
        
        var facesIndices: [FaceIndices] = []
        
        let stringToVec3 = { (string: String) -> (Float, Float, Float) in
            let c = string.componentsSeparatedByString(" ")
            return (Float(c[1])!, Float(c[2])!, Float(c[3])!)
        }
        let stringToVec2 = { (string: String) -> (Float, Float) in
            let c = string.componentsSeparatedByString(" ")
            return (Float(c[1])!, Float(c[2])!)
        }
        
        let stringToStrideIndices = { (string: String) -> (Int, Int, Int) in
            let c = string.componentsSeparatedByString("/")
            return (Int(c[0])!, Int(c[1])!, Int(c[2])!)
        }
        let stringToFace = { (string: String) -> FaceIndices in
            let c = string.componentsSeparatedByString(" ")
            return (stringToStrideIndices(c[1]), stringToStrideIndices(c[2]), stringToStrideIndices(c[3]))
        }
        
        
        for line in lines {
            if line.startIndex.distanceTo(line.endIndex) < 2 {
                continue
            }
            switch line.substringToIndex(line.startIndex.advancedBy(2)) {
            case "v ": positions.append(stringToVec3(line))
            case "vt": texels.append(stringToVec2(line))
            case "vn": normals.append(stringToVec3(line))
            case "f ": facesIndices.append(stringToFace(line))
            default: break
            }
        }
        
        typealias Stride = (p: Position, t: Texel, n: Normal)
        
        let strideToIndices = { (indices: VertexIndices) -> Stride in
            return Stride(p: positions[indices.p - 1], t: texels[indices.t - 1], n: normals[indices.n - 1])
        }
        
        var strides: [Stride] = []
        
        for faceIndices in facesIndices {
            strides.append(strideToIndices(faceIndices.v1))
            strides.append(strideToIndices(faceIndices.v2))
            strides.append(strideToIndices(faceIndices.v3))
        }
        
        let vec3Identifier = { (e1: Position, e2: Position) -> Bool in
            return e1.x == e2.x && e1.y == e2.y && e1.z == e2.z
        }
        
        let vec2Identifier = { (e1: Texel, e2: Texel) -> Bool in
            return e1.u == e2.u && e1.v == e2.v
        }
        
//        let ps = strides.map {return $0.p}.filterDuplicates(vec3Identifier).map {return [$0.x, $0.y, $0.z]}.stomp()
//        let ts = strides.map {return $0.t}.filterDuplicates(vec2Identifier).map {return [$0.u, $0.v]}.stomp()
//        let ns = strides.map {return $0.n}.filterDuplicates(vec3Identifier).map {return [$0.x, $0.y, $0.z]}.stomp()
        
        var ps: [Position] = []
        var ts: [Texel] = []
        var ns: [Normal] = []
        
        var usedStrides: [Stride] = []
        var indexes: [Int] = []
        
//        for stride in strides {
//            if let index = usedStrides.firstOccurence(stride, identificator: { (e1, e2) -> (Bool) in
//            return e1.p == e2.p && e1.t == e2.t && e1.n == e2.n
//            }) {
//                indexes.append(index)
//            } else {
//                indexes.append
//            }
//        }
        
        NSLog("counts: %d %d %d", positions.count, texels.count, normals.count)
        
        let strideIndices = facesIndices.map{return [$0.v1, $0.v2, $0.v3]}.stomp()
        
        let indicesComparator = { (e1: VertexIndices, e2: VertexIndices) -> (Bool) in
            return e1.p == e2.p && e1.t == e2.t && e1.n == e2.n
        }
        let indicesProcessor = { (entity: VertexIndices) -> (Void) in
            NSLog("%d %d %d", entity.p, entity.t, entity.n)
            ps.append(positions[entity.p - 1])
            ts.append(texels[entity.t - 1])
            ns.append(normals[entity.n - 1])
        }
        
        
        let pss = ps.map {return [$0.x, $0.y, $0.z]}.stomp()
        let tss = ts.map {return [$0.u, $0.v]}.stomp()
        let nss = ps.map {return [$0.x, $0.y, $0.z]}.stomp()
        
        
        let indices: [Int] = strideIndices.indexify(indicesComparator, processor: indicesProcessor)
        
        let arrayToArray = { (array: [Int]) -> GLIntArray in
            var glArray = GLIntArray()
            glArray.data = array.map{return UInt($0)}
            glArray.count = UInt(array.count)
            return glArray
        }
        
        let floatArrayToArray = { (array: [Float]) -> GLFloatArray in
            var glArray = GLFloatArray()
            glArray.data = array
            glArray.count = UInt(array.count)
            return glArray
        }
        
        var obj = OBJ()
        obj.indices = arrayToArray(indices)
        obj.positions = floatArrayToArray(pss)
        obj.texels = floatArrayToArray(tss)
        obj.normals = floatArrayToArray(nss)
        
        NSLog("indexed counts: %d %d %d", ps.count, ts.count, ns.count)
        NSLog("stomped counts: %d %d %d", pss.count, tss.count, nss.count)
        
        var pz = ps.map { (position: (x: Float, y: Float, z: Float)) -> [Float] in
            return [position.x, position.y, position.z]
        }.stomp()
        var tz = ts.map { (texel: (u: Float, v: Float)) -> [Float] in
            return [texel.u, texel.v]
        }.stomp()
        var nz = ns.map { (normal: (x: Float, y: Float, z: Float)) -> [Float] in
            return [normal.x, normal.y, normal.z]
        }.stomp()
        
        obj.positions = floatArrayToArray(pz)
        obj.texels = floatArrayToArray(tz)
        obj.normals = floatArrayToArray(nz)
        
        return obj
    }
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

extension Array {
    func indexify(identificator: ((e1: Element, e2: Element)->(Bool)), processor: (processingEntity: Element) -> (Void)) -> [Int] {
        var indices: [Int] = []
        var stack: [Element] = []
        
        for element in self {
            if let index = stack.firstOccurence(element, identificator: identificator) {
                indices.append(index)
            } else {
                indices.append(stack.count)
                stack.append(element)
                processor(processingEntity: element)
            }
        }
        
        return indices
    }
    
    func filterDuplicates(identificator: ((e1: Element, e2: Element)->(Bool))) -> [Element] {
        var result: [Element] = []
        var i: Int = 0
        for element in self {
            if self.firstOccurence(element, identificator: identificator) == i {
                result.append(element)
            }
            i++
        }
        return result
    }

    func firstOccurence(element: Element, identificator: ((e1: Element, e2: Element)->(Bool))) -> Int? {
        var i: Int = 0
        for iteratingElement in self {
            if (identificator(e1: element, e2: iteratingElement)) {
                return i;
            }
            i++
        }
        return nil
    }
}