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
    
    class func render(renderables: [Renderable]) {
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
            glBindTexture(GLenum(GL_TEXTURE_2D), renderable.texture.glName);
            glActiveTexture(GLenum(GL_TEXTURE1));
//            glBindTexture(GLenum(GL_TEXTURE_2D), self.normalMap.glName);
//            glUniform1i(uniforms[uniformTexture], 0);
//            glUniform1i(uniforms[uniformNormalMap], 1);

            // Pass matrices
//            let modelMatrix = [renderable.geometryModel modelMatrix];
//            GLKMatrix4 viewMatrix = [self.camera viewMatrix];
//            GLKMatrix4 projectionMatrix = [self.camera projectionMatrix];
//
//            glUniformMatrix4fv(uniforms[uniformModelMatrix], 1, 0, modelMatrix.m);
//            glUniformMatrix4fv(uniforms[uniformViewMatrix], 1, 0, viewMatrix.m);
//            glUniformMatrix4fv(uniforms[uniformProjectionMatrix], 1, 0, projectionMatrix.m);
//            
//            GLKMatrix3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3([renderable.geometryModel modelMatrix]), NULL);
//            glUniformMatrix3fv(uniforms[uniformNormalMatrix], 1, 0, normalMatrix.m);
//            
//            // Draw
//            glDrawElements(GL_TRIANGLES, renderable.vao.vertexCount, GL_UNSIGNED_INT, 0);
//            
//            // Unbind vao
//            glDisableVertexAttribArray(VboIndexPositions);
//            glDisableVertexAttribArray(VboIndexTexels);
//            glDisableVertexAttribArray(VboIndexNormals);
//            glDisableVertexAttribArray(VboIndexTangents);
//            glDisableVertexAttribArray(VboIndexBitangents);
//            
//            glBindVertexArrayOES(0);
        }
    }
    
}