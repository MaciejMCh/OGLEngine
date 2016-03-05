//
//  GameViewController.m
//  OGLEngine
//
//  Created by Maciej Chmielewski on 24.02.2016.
//  Copyright © 2016 MaciejCh. All rights reserved.
//

#import "GameViewController.h"
#import <OpenGLES/ES2/glext.h>
#import "OBJ+samples.h"
#import "VAO.h"
#import "Texture.h"
#import "SpinningGeometryModel.h"
#import "BasicCamera.h"
#import "OBJLoader.h"
#import "StaticGeometryModel.h"
#import "FocusingCamera.h"
#import "Drawable.h"
#import "FocusingCamera.h"

@interface GameViewController () {
    GLuint _program;
}
@property (strong, nonatomic) EAGLContext *context;

//@property (nonatomic, strong) VAO *vao;
//@property (nonatomic, strong) Texture *texture;
//@property (nonatomic, strong) id<GeometryModel> geometryModel;
@property (nonatomic, strong) id<Camera> camera;
@property (nonatomic, strong) NSMutableArray<Drawable *> *drawables;

- (void)setupGL;
- (void)tearDownGL;

- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
@end

enum {
    uniformTexture,
    uniformModelViewProjectionMatrix,
    uniformNormalMatrix,
    uniformsCount
};
GLint uniforms[uniformsCount];

@implementation GameViewController

- (void)setupGL {
    [EAGLContext setCurrentContext:self.context];
    [self loadShaders];
    glUseProgram(_program);
    glEnable(GL_DEPTH_TEST);
    
    self.drawables = [NSMutableArray new];
    
    // Vaos
    VAO *torusVao = [[VAO alloc] initWithOBJ:[OBJLoader objFromFileNamed:@"paczek"]];
    VAO *cubeVao = [[VAO alloc] initWithOBJ:[OBJLoader objFromFileNamed:@"cube"]];
    
    // Textures
    Texture *orangeTexture = [[Texture alloc] initWithColor:[UIColor orangeColor]];
    Texture *grayTexture = [[Texture alloc] initWithColor:[UIColor grayColor]];
    [orangeTexture bind];
    
    // Geometry models
    SpinningGeometryModel *spinningGeometryModel = [[SpinningGeometryModel alloc] initWithPosition:GLKVector3Make(0, 0, 0)];
    StaticGeometryModel *originGeometryModel = [[StaticGeometryModel alloc] initWithModelMatrix:GLKMatrix4Identity];
    StaticGeometryModel *standingGeometryModel = [[StaticGeometryModel alloc] initWithModelMatrix:GLKMatrix4MakeTranslation(0, 0, 1)];
    
    // Drawables
    [self.drawables addObject:[[Drawable alloc] initWithVao:torusVao geometryModel:originGeometryModel texture:orangeTexture]];
    
    int gridRadius = 5;
    for (int i=-gridRadius; i<gridRadius; i++) {
            GLKMatrix4 model = GLKMatrix4MakeScale(.01, 10, .01);
            model = GLKMatrix4Translate(model, i * 100, 0, 0);
            StaticGeometryModel *geometry = [[StaticGeometryModel alloc] initWithModelMatrix:model];
            [self.drawables addObject:[[Drawable alloc] initWithVao:cubeVao geometryModel:geometry texture:grayTexture]];
    }
    for (int i=-gridRadius; i<gridRadius; i++) {
        GLKMatrix4 model = GLKMatrix4MakeScale(10, .01, .01);
        model = GLKMatrix4Translate(model, 0, i * 100, 0);
        StaticGeometryModel *geometry = [[StaticGeometryModel alloc] initWithModelMatrix:model];
        [self.drawables addObject:[[Drawable alloc] initWithVao:cubeVao geometryModel:geometry texture:grayTexture]];
    }
    
    // Camera
    self.camera = [[FocusingCamera alloc] initWithPosition:GLKVector3Make(0, 0, 0) hAngle:0 vAngle:0 distance:5];
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)handlePan:(UIPanGestureRecognizer *)panGesture {
    ((FocusingCamera *)self.camera).hAngle = [panGesture locationInView:self.view].x / 100;
    ((FocusingCamera *)self.camera).vAngle = [panGesture locationInView:self.view].y / 100;
}

- (void)update {
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    for (Drawable *drawable in self.drawables) {
        // Bind vao
        glBindVertexArrayOES(drawable.vao.vaoGLName);
        glEnableVertexAttribArray(VboIndexPositions);
        glEnableVertexAttribArray(VboIndexTexels);
        glEnableVertexAttribArray(VboIndexNormals);
        
        // Pass texture
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, drawable.texture.glName);
        glUniform1i(uniformTexture, 0);
        
        // Pass matrices
        GLKMatrix4 modelViewProjectionMatrix = GLKMatrix4Multiply([self.camera viewProjectionMatrix], [drawable.geometryModel modelMatrix]);
        glUniformMatrix4fv(uniforms[uniformModelViewProjectionMatrix], 1, 0, modelViewProjectionMatrix.m);
        
        GLKMatrix3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3([drawable.geometryModel modelMatrix]), NULL);
        glUniformMatrix3fv(uniforms[uniformNormalMatrix], 1, 0, normalMatrix.m);
        
        // Draw
        glDrawElements(GL_TRIANGLES, drawable.vao.vertexCount, GL_UNSIGNED_INT, 0);
        // Unbind vao
        glDisableVertexAttribArray(VboIndexPositions);
        glDisableVertexAttribArray(VboIndexTexels);
        glDisableVertexAttribArray(VboIndexNormals);
        glBindVertexArrayOES(0);
    }
    
}

#pragma mark -  OpenGL ES 2 shader compilation

- (BOOL)loadShaders {
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_program, VboIndexPositions, "aPosition");
    glBindAttribLocation(_program, VboIndexTexels, "aTexel");
    glBindAttribLocation(_program, VboIndexNormals, "aNormal");
    
    // Link program.
    if (![self linkProgram:_program]) {
        NSLog(@"Failed to link program: %d", _program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    uniforms[uniformTexture] = glGetUniformLocation(_program, "uTexture");
    uniforms[uniformModelViewProjectionMatrix] = glGetUniformLocation(_program, "uModelViewProjectionMatrix");
    uniforms[uniformNormalMatrix] = glGetUniformLocation(_program, "uNormalMatrix");
    
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)]];
    
    [self setupGL];
}

- (void)dealloc {
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }
    
    // Dispose of any resources that can be recreated.
}

- (void)tearDownGL {
    [EAGLContext setCurrentContext:self.context];
    
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
