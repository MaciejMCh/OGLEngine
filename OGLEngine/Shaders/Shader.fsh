//
//  Shader.fsh
//  OGLEngine
//
//  Created by Maciej Chmielewski on 24.02.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
