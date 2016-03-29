//
//  VAO.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 21.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation
import GLKit

@objc enum VboIndex : GLuint {
    case Positions = 0
    case Texels
    case Normals
    case Tangents
    case Bitangents
    case VbosCount
}

class VAO : NSObject {
    
    var obj: OBJ!
    var vertexCount: UInt = 0
    var vaoGLName: GLuint = 0
    var indicesVboGLName: GLuint = 0
    var positionsVboGLName: GLuint = 0
    var texelsVboGLName: GLuint = 0
    var normalsVboGLName: GLuint = 0
    var tangentsVboGLName: GLuint = 0
    var bitangentsVboGLName: GLuint = 0
    
    convenience init(OBJ obj: OBJ) {
        self.init()
        self.obj = obj
        self.vertexCount = UInt(obj.indices.count)
        
        var vaoGLName: GLuint = 0
        glGenVertexArraysOES(1, &vaoGLName)
        glBindVertexArrayOES(vaoGLName)
        self.vaoGLName = vaoGLName
        
        var indicesVboGLName: GLuint = 0
        glGenBuffers(1, &indicesVboGLName)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indicesVboGLName)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), Int(obj.indices.count) * sizeof(GLuint), obj.indices.data, GLenum(GL_STATIC_DRAW))
        
        self.positionsVboGLName = self.generateVboAtIndex(.Positions, data: obj.positions, perVertexCount: 3)
        self.texelsVboGLName = self.generateVboAtIndex(.Texels, data: obj.texels, perVertexCount: 2)
        self.normalsVboGLName = self.generateVboAtIndex(.Normals, data: obj.normals, perVertexCount: 3)
//        self.tangentsVboGLName = self.generateVboAtIndex(.Tangents, data: obj.tangents, perVertexCount: 3)
//        self.bitangentsVboGLName = self.generateVboAtIndex(.Bitangents, data: obj.bitangents, perVertexCount: 3)
        glBindVertexArrayOES(0)
    }
    
    func generateVboAtIndex(index: VboIndex, data: GLFloatArray, perVertexCount: UInt) -> GLuint {
        var vboGLName: GLuint = 0
        glGenBuffers(1, &vboGLName)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vboGLName)
        glBufferData(GLenum(GL_ARRAY_BUFFER), Int(data.count) * sizeof(GLfloat), data.data, GLenum(GL_STATIC_DRAW))
        glVertexAttribPointer(GLuint(index.rawValue), GLint(perVertexCount), GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, nil)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        return vboGLName
    }
}