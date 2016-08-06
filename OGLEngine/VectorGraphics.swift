//
//  VectorGraphics.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 06.08.2016.
//  Copyright © 2016 Maciej Chmielewski. All rights reserved.
//

import Foundation

typealias Line = (a: Float, b: Float)
typealias PlaneBound = (lhsLine: Line, rhsLine: Line)

enum VectorGraphicsRoutine {
    case Terminate
    case SetColor(r: Float, g: Float, b: Float, a: Float)
    case AddQuad(b1: PlaneBound, b2: PlaneBound)
    case AddCircle(x: Float, y: Float, r: Float)
    
    func routineIdentifier() -> UInt8 {
        switch self {
        case .Terminate: return 0
        case .SetColor: return 1
        case .AddQuad: return 2
        case .AddCircle: return 3
        }
    }
    
    func dataCount() -> UInt8 {
        return UInt8(data().count)
    }
    
    func header() -> UInt16 {
        let identifier = UInt16(routineIdentifier())
        var count = UInt16(dataCount())
        count = count << 8
        let header: UInt16 = identifier | count
        return header
    }
    
    func data() -> [Float32] {
        switch self {
        case .Terminate: return []
        case .SetColor(let color): return [color.r, color.g, color.b, color.a]
        case .AddQuad(let quadBounds): return [
            quadBounds.b1.lhsLine.a,
            quadBounds.b1.lhsLine.b,
            quadBounds.b1.rhsLine.a,
            quadBounds.b1.rhsLine.b,
            quadBounds.b2.lhsLine.a,
            quadBounds.b2.lhsLine.b,
            quadBounds.b2.rhsLine.a,
            quadBounds.b2.rhsLine.b,
            ]
        case .AddCircle(let circle): return [circle.x, circle.y, circle.r]
        }
    }
}

public struct VectorGraphics {
    let routines: [VectorGraphicsRoutine]
}
