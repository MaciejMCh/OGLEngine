//
//  Renderer.swift
//  OGLEngine
//
//  Created by Maciej Chmielewski on 22.03.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

import Foundation
import GLKit

class Renderer : NSObject {
    
    
    class func bind(renderable: Renderable) {
        glBindVertexArrayOES(renderable.vao.vaoGLName)
        glEnableVertexAttribArray(GLuint(VboIndex.Positions.rawValue))
        glEnableVertexAttribArray(GLuint(VboIndex.Texels.rawValue))
        glEnableVertexAttribArray(GLuint(VboIndex.Normals.rawValue))
        glEnableVertexAttribArray(GLuint(VboIndex.Tangents.rawValue))
        glEnableVertexAttribArray(GLuint(VboIndex.Bitangents.rawValue))
    }
    
    class func unbind(renderable: Renderable) {
        glDisableVertexAttribArray(GLuint(VboIndex.Positions.rawValue))
        glDisableVertexAttribArray(GLuint(VboIndex.Texels.rawValue))
        glDisableVertexAttribArray(GLuint(VboIndex.Normals.rawValue))
        glDisableVertexAttribArray(GLuint(VboIndex.Tangents.rawValue))
        glDisableVertexAttribArray(GLuint(VboIndex.Bitangents.rawValue))
        
        glBindVertexArrayOES(0);
    }
    
    class func bindTexture(renderable: Renderable, normalMap: Texture) {
        glActiveTexture(GLenum(GL_TEXTURE0));
        glBindTexture(GLenum(GL_TEXTURE_2D), renderable.texture.glName)
        glActiveTexture(GLenum(GL_TEXTURE1));
        glBindTexture(GLenum(GL_TEXTURE_2D), normalMap.glName);
        glUniform1i(Program.ProgramUniformTexture, 0);
        glUniform1i(Program.ProgramUniformNormalMap, 1);
    }
    
    class func passMatrices(renderable: Renderable, camera: Camera) {
        var modelMatrix = renderable.geometryModel.modelMatrix()
        var viewMatrix = camera.viewMatrix()
        var projectionMatrix = camera.projectionMatrix()
        
        withUnsafePointer(&modelMatrix, {
            glUniformMatrix4fv(Program.ProgramUniformModelMatrix, 1, 0, UnsafePointer($0))
        })
        withUnsafePointer(&viewMatrix, {
            glUniformMatrix4fv(Program.ProgramUniformViewMatrix, 1, 0, UnsafePointer($0))
        })
        withUnsafePointer(&projectionMatrix, {
            glUniformMatrix4fv(Program.ProgramUniformProjectionMatrix, 1, 0, UnsafePointer($0))
        })
        
        var normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(renderable.geometryModel.modelMatrix()), nil);
        withUnsafePointer(&normalMatrix, {
            glUniformMatrix3fv(Program.ProgramUniformNormalMatrix, 1, 0, UnsafePointer($0))
        })

    }
    
    class func draw(renderable: Renderable) {
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(renderable.vao.vertexCount), GLenum(GL_UNSIGNED_INT), nil);
    }
    
    class func render(renderables: [Renderable], camera: Camera, normalMap: Texture) {
        for renderable in renderables {
            // Bind vao
            glBindVertexArrayOES(renderable.vao.vaoGLName)
            glEnableVertexAttribArray(GLuint(VboIndex.Positions.rawValue))
            glEnableVertexAttribArray(GLuint(VboIndex.Texels.rawValue))
            glEnableVertexAttribArray(GLuint(VboIndex.Normals.rawValue))
            glEnableVertexAttribArray(GLuint(VboIndex.Tangents.rawValue))
            glEnableVertexAttribArray(GLuint(VboIndex.Bitangents.rawValue))

            // Pass texture
            glActiveTexture(GLenum(GL_TEXTURE0));
            glBindTexture(GLenum(GL_TEXTURE_2D), renderable.texture.glName)
            glActiveTexture(GLenum(GL_TEXTURE1));
            glBindTexture(GLenum(GL_TEXTURE_2D), normalMap.glName);
            glUniform1i(Program.ProgramUniformTexture, 0);
            glUniform1i(Program.ProgramUniformNormalMap, 1);

            // Pass matrices
            var modelMatrix = renderable.geometryModel.modelMatrix()
            var viewMatrix = camera.viewMatrix()
            var projectionMatrix = camera.projectionMatrix()
            
            
            withUnsafePointer(&modelMatrix, {
                glUniformMatrix4fv(Program.ProgramUniformModelMatrix, 1, 0, UnsafePointer($0))
            })
            withUnsafePointer(&viewMatrix, {
                glUniformMatrix4fv(Program.ProgramUniformViewMatrix, 1, 0, UnsafePointer($0))
            })
            withUnsafePointer(&projectionMatrix, {
                glUniformMatrix4fv(Program.ProgramUniformProjectionMatrix, 1, 0, UnsafePointer($0))
            })
            
            var normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(renderable.geometryModel.modelMatrix()), nil);
            withUnsafePointer(&normalMatrix, {
                glUniformMatrix3fv(Program.ProgramUniformNormalMatrix, 1, 0, UnsafePointer($0))
            })
            
            // Draw
            glDrawElements(GLenum(GL_TRIANGLES), GLsizei(renderable.vao.vertexCount), GLenum(GL_UNSIGNED_INT), nil);
            
            // Unbind vao
            glDisableVertexAttribArray(GLuint(VboIndex.Positions.rawValue))
            glDisableVertexAttribArray(GLuint(VboIndex.Texels.rawValue))
            glDisableVertexAttribArray(GLuint(VboIndex.Normals.rawValue))
            glDisableVertexAttribArray(GLuint(VboIndex.Tangents.rawValue))
            glDisableVertexAttribArray(GLuint(VboIndex.Bitangents.rawValue))
            
            glBindVertexArrayOES(0);
        }
    }
    
}