//
//  VAO.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 21.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation
import GLKit

enum VBOType {
    
    case Position
    case Texel
    case Normal
    case TangentMatrixCol1
    case TangentMatrixCol2
    case TangentMatrixCol3
    
    func perVertexCount() -> GLint {
        switch self {
        case .Position: return 3
        case .Texel: return 2
        case .Normal: return 3
        case .TangentMatrixCol1: return 3
        case .TangentMatrixCol2: return 3
        case .TangentMatrixCol3: return 3
        }
    }
    
    func index() -> GLuint {
        switch self {
        case .Position: return 0
        case .Texel: return 1
        case .Normal: return 2
        case .TangentMatrixCol1: return 3
        case .TangentMatrixCol2: return 4
        case .TangentMatrixCol3: return 5
        }
    }
    
}

struct VBO {
    let type: VBOType
    let glName: GLuint
    let data: GLFloatArray
}

class VAO {
    
    var VBOTypes: [VBOType]!
    var obj: OBJ!
    var vbos: [VBO] = []
    
    var vertexCount: UInt = 0
    var vaoGLName: GLuint = 0
    var indicesVboGLName: GLuint = 0
    
    convenience init(obj: OBJ) {
        self.init()
        self.VBOTypes = [.Position, .Texel, .Normal, .TangentMatrixCol1, .TangentMatrixCol2, .TangentMatrixCol3]
        self.obj = obj
        
        self.setup()
    }
    
    private func setup() {
        self.vertexCount = UInt(self.obj.indices.count)
        
        var vaoGLName: GLuint = 0
        glGenVertexArraysOES(1, &vaoGLName)
        glBindVertexArrayOES(vaoGLName)
        self.vaoGLName = vaoGLName
        
        var indicesVboGLName: GLuint = 0
        glGenBuffers(1, &indicesVboGLName)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indicesVboGLName)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), Int(obj.indices.count) * sizeof(GLuint), obj.indices.data, GLenum(GL_STATIC_DRAW))
        
        self.vbos = self.VBOTypes.map{return self.generateVbo($0, data: obj.dataOfType($0))}
        
        glBindVertexArrayOES(0)
    }
    
    func generateVbo(type: VBOType, data: GLFloatArray) -> VBO {
        var vboGLName: GLuint = 0
        glGenBuffers(1, &vboGLName)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vboGLName)
        glBufferData(GLenum(GL_ARRAY_BUFFER), Int(data.count) * sizeof(GLfloat), data.data, GLenum(GL_STATIC_DRAW))
        glVertexAttribPointer(type.index(), type.perVertexCount(), GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, nil)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        return VBO(type: type, glName: vboGLName, data: data)
    }
}