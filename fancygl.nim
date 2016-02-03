import opengl, glm, strutils, nre, macros, macroutils, sdl2, sdl2/image

#### glm additions ####

type Vec4f* = Vec4[float32]
type Vec3f* = Vec3[float32]
type Vec2f* = Vec2[float32]
type Vec4d* = Vec4[float64]
type Vec3d* = Vec3[float64]
type Vec2d* = Vec2[float64]

proc vec4f*(x,y,z,w: float32) : Vec4f = [x,y,z,w].Vec4f
proc vec4f*(v:Vec3f,w:float32): Vec4f = [v.x,v.y,v.z,w].Vec4f
proc vec3f*(x,y,z:   float32) : Vec3f = [x,y,z].Vec3f
proc vec2f*(x,y:     float32) : Vec2f = [x,y].Vec2f
proc vec4d*(x,y,z,w: float64) : Vec4d = [x,y,z,w].Vec4d
proc vec4d*(v:Vec3d,w:float64): Vec4d = [v.x,v.y,v.z,w].Vec4d
proc vec3d*(x,y,z:   float64) : Vec3d = [x,y,z].Vec3d
proc vec2d*(x,y:     float64) : Vec2d = [x,y].Vec2d

proc vec4f*(v: Vec4d) : Vec4f = [v.x.float32,v.y.float32,v.z.float32,v.w.float32].Vec4f
proc vec3f*(v: Vec3d) : Vec3f = [v.x.float32,v.y.float32,v.z.float32].Vec3f
proc vec2f*(v: Vec2d) : Vec2f = [v.x.float32,v.y.float32].Vec2f
proc vec4d*(v: Vec4f) : Vec4d = [v.x.float64,v.y.float64,v.z.float64,v.w.float64].Vec4d
proc vec3d*(v: Vec3f) : Vec3d = [v.x.float64,v.y.float64,v.z.float64].Vec3d
proc vec2d*(v: Vec2f) : Vec2d = [v.x.float64,v.y.float64].Vec2d

type Mat4f* = Mat4x4[float32]
type Mat3f* = Mat3x3[float32]
type Mat2f* = Mat2x2[float32]
type Mat4d* = Mat4x4[float64]
type Mat3d* = Mat3x3[float64]
type Mat2d* = Mat2x2[float64]

proc mat4f*(mat: Mat4d): Mat4f =
  for i in 0..<4:
   for j in 0..<4:
     result[i][j] = mat[i][j]

proc I4*() : Mat4d = mat4x4(
  vec4d(1, 0, 0, 0),
  vec4d(0, 1, 0, 0),
  vec4d(0, 0, 1, 0),
  vec4d(0, 0, 0, 1)
)

proc I4f*() : Mat4f = mat4x4[float32](
  vec4f(1, 0, 0, 0),
  vec4f(0, 1, 0, 0),
  vec4f(0, 0, 1, 0),
  vec4f(0, 0, 0, 1)
)

#### Sampler Types ####

macro nilName(name:expr) : expr =
  name.expectKind(nnkIdent)
  !!("nil_" & $name)

template textureTypeTemplate(name, nilName, target:expr, shadername:string): stmt =
  type name* = distinct GLuint
  const nilName* = name(0)
  proc bindIt*(texture: name) =
    glBindTexture(target, GLuint(texture))


template textureTypeTemplate(name: expr, target:expr, shadername:string): stmt =
  textureTypeTemplate(name, nilName(name), target, shadername)

proc geometryNumVerts(mode: GLenum): int =
  case mode
  of GL_POINTS: 1
  of GL_LINE_STRIP: 2
  of GL_LINE_LOOP: 2
  of GL_LINES: 2
  of GL_LINE_STRIP_ADJACENCY: 4
  of GL_LINES_ADJACENCY: 4
  of GL_TRIANGLE_STRIP: 3
  of GL_TRIANGLE_FAN: 3
  of GL_TRIANGLES: 3
  of GL_TRIANGLE_STRIP_ADJACENCY: 6
  of GL_TRIANGLES_ADJACENCY: 6
  of GL_PATCHES: -1
  else: -1128

proc geometryPrimitiveLayout(mode: GLenum): string =
  case mode
  of GL_POINTS:
    "points"
  of GL_LINE_STRIP, GL_LINE_LOOP, GL_LINES:
    "lines"
  of GL_LINE_STRIP_ADJACENCY, GL_LINES_ADJACENCY:
    "lines_adjacency"
  of GL_TRIANGLE_STRIP, GL_TRIANGLE_FAN, GL_TRIANGLES:
    "triangles"
  of GL_TRIANGLE_STRIP_ADJACENCY, GL_TRIANGLES_ADJACENCY:
    "triangles_adjacency"
  else:
    ""


textureTypeTemplate(Texture1D,                 nil_Texture1D,
    GL_TEXTURE_1D, "sampler1D")
textureTypeTemplate(Texture2D,                 nil_Texture2D,
    GL_TEXTURE_2D, "sampler2D")
textureTypeTemplate(Texture3D,                 nil_Texture3D,
    GL_TEXTURE_3D, "sampler3D")
textureTypeTemplate(Texture1DArray,             nil_Texture1DArray,
    GL_Texture_1D_ARRAY, "sampler1DArray")
textureTypeTemplate(Texture2DArray,            nil_Texture2DArray,
    GL_TEXTURE_2D_ARRAY, "sampler2DArray")
textureTypeTemplate(TextureRectangle,          nil_TextureRectangle,
    GL_TEXTURE_RECTANGLE, "sampler2DRect")
textureTypeTemplate(TextureCubeMap,            nil_TextureCubeMap,
    GL_TEXTURE_CUBE_MAP, "samplerCube")
textureTypeTemplate(TextureCubeMapArray,       nil_TextureCubeMapArray,
    GL_TEXTURE_CUBE_MAP_ARRAY , "samplerCubeArray")
textureTypeTemplate(TextureBuffer,             nil_TextureBuffer,
    GL_TEXTURE_BUFFER, "samplerBuffer")
textureTypeTemplate(Texture2DMultisample,      nil_Texture2DMultisample,
    GL_TEXTURE_2D_MULTISAMPLE, "sampler2DMS")
textureTypeTemplate(Texture2DMultisampleArray, nil_Texture2DMultisampleArray,
    GL_TEXTURE_2D_MULTISAMPLE_ARRAY, "sampler2DMSArray")


textureTypeTemplate(Texture1DShadow,        nil_Texture1DShadow,        GL_TEXTURE_1D,             "sampler1DShadow​")
textureTypeTemplate(Texture2DShadow,        nil_Texture2DShadow,        GL_TEXTURE_2D,             "sampler2DShadow​")
textureTypeTemplate(TextureCubeShadow,      nil_TextureCubeShadow,      GL_TEXTURE_CUBE_MAP,       "samplerCubeShadow​")
textureTypeTemplate(Texture2DRectShadow,    nil_Texture2DRectShadow,    GL_TEXTURE_RECTANGLE,      "sampler2DRectShadow​")
textureTypeTemplate(Texture1DArrayShadow,   nil_Texture1DArrayShadow,   GL_TEXTURE_1D_ARRAY,       "sampler1DArrayShadow​")
textureTypeTemplate(Texture2DArrayShadow,   nil_Texture2DArrayShadow,   GL_TEXTURE_2D_ARRAY,       "sampler2DArrayShadow​")
textureTypeTemplate(TextureCubeArrayShadow, nil_TextureCubeArrayShadow, GL_TEXTURE_CUBE_MAP_ARRAY, "samplerCubeArrayShadow​")


proc loadAndBindTextureRectangleFromFile*(filename: string): TextureRectangle =
  let surface = image.load(filename)
  defer: freeSurface(surface)
  let surface2 = sdl2.convertSurfaceFormat(surface, SDL_PIXELFORMAT_RGBA8888, 0)
  defer: freeSurface(surface2)
  glGenTextures(1, cast[ptr GLuint](result.addr))
  result.bindIt()
  glTexImage2D(GL_TEXTURE_RECTANGLE, 0, GL_RGBA, surface2.w, surface2.h, 0, GL_RGBA, GL_UNSIGNED_INT_8_8_8_8, surface2.pixels)
  glTexParameteri(GL_TEXTURE_RECTANGLE, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
  glTexParameteri(GL_TEXTURE_RECTANGLE, GL_TEXTURE_MAG_FILTER, GL_LINEAR)

proc loadAndBindTexture2DFromFile*(filename: string): Texture2D =
  let surface = image.load(filename)
  defer: freeSurface(surface)
  let surface2 = sdl2.convertSurfaceFormat(surface, SDL_PIXELFORMAT_RGBA8888, 0)
  defer: freeSurface(surface2)
  glGenTextures(1, cast[ptr GLuint](result.addr))
  result.bindIt()
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, surface2.w, surface2.h, 0, GL_RGBA, GL_UNSIGNED_INT_8_8_8_8, surface2.pixels)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
  glGenerateMipmap(GL_TEXTURE_2D)

proc size*(tex: Texture2D): Vec2f =
  var outer_tex : GLint
  glGetIntegerv(GL_TEXTURE_BINDING_2D, outer_tex.addr)
  tex.bindIt
  var w,h: GLint
  glGetTexLevelParameteriv(GL_TEXTURE_2D, 0, GL_TEXTURE_WIDTH, w.addr)
  glGetTexLevelParameteriv(GL_TEXTURE_2D, 0, GL_TEXTURE_HEIGHT, h.addr)
  result = vec2f(w.float32, h.float32)
  glBindTexture(GL_TEXTURE_2D, outer_tex.GLuint)

#proc `size=`(tex: Texture2D, size: Vec2f) =
#  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, size.x.GLsizei, size.y.GLsizei, 0,GL_RGB, cGL_UNSIGNED_BYTE, nil)

proc createAndBindEmptyTexture2D*(size: Vec2f) : Texture2D =
  glGenTextures(1, cast[ptr GLuint](result.addr))
  result.bindIt
  glTexImage2D(GL_TEXTURE_2D, 0,GL_RGB, size.x.GLsizei, size.y.GLsizei, 0,GL_RGB, cGL_UNSIGNED_BYTE, nil)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST)


proc size*(tex: TextureRectangle): Vec2f =
  var outer_tex : GLint
  glGetIntegerv(GL_TEXTURE_BINDING_RECTANGLE, outer_tex.addr)
  tex.bindIt
  var w,h: GLint
  glGetTexLevelParameteriv(GL_TEXTURE_RECTANGLE, 0, GL_TEXTURE_WIDTH, w.addr)
  glGetTexLevelParameteriv(GL_TEXTURE_RECTANGLE, 0, GL_TEXTURE_HEIGHT, h.addr)
  result = vec2f(w.float32, h.float32)
  glBindTexture(GL_TEXTURE_RECTANGLE, outer_tex.GLuint)

proc saveToBmpFile*(tex: Texture2D, filename: string): void =
  tex.bindIt
  let s = tex.size
  var surface = createRGBSurface(0, s.x.int32, s.y.int32, 32, 0xff000000.uint32, 0x00ff0000, 0x0000ff00, 0x000000ff)  # no alpha, rest default
  glGetTexImage(GL_TEXTURE_2D, 0, GL_RGBA, GL_UNSIGNED_INT_8_8_8_8, surface.pixels)
  saveBMP(surface, filename)

proc saveToBmpFile*(tex: TextureRectangle, filename: string): void =
  tex.bindIt
  let s = tex.size
  var surface = createRGBSurface(0, s.x.int32, s.y.int32, 32, 0xff000000.uint32, 0x00ff0000, 0x0000ff00, 0x000000ff)  # no alpha, rest default
  glGetTexImage(GL_TEXTURE_2D, 0, GL_RGBA, GL_UNSIGNED_INT_8_8_8_8, surface.pixels)
  saveBMP(surface, filename)

#### framebuffer ####

type DepthRenderbuffer* = distinct GLuint

proc bindIt*(drb: DepthRenderbuffer): void =
  glBindRenderbuffer(GL_RENDERBUFFER, drb.GLuint)

proc createAndBindDepthRenderBuffer*(size: Vec2f) : DepthRenderbuffer =
  glGenRenderbuffers(1, cast[ptr GLuint](result.addr))
  glBindRenderbuffer(GL_RENDERBUFFER, result.GLuint)
  glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT, size.x.GLsizei, size.y.GLsizei)

type FrameBuffer* = distinct GLuint

proc bindIt*(fb: FrameBuffer): void =
  glBindFramebuffer(GL_FRAMEBUFFER, fb.GLuint)

proc createFrameBuffer*(): FrameBuffer =
  glGenFramebuffers(1, cast[ptr GLuint](result.addr))

proc drawBuffers*(args : varargs[GLenum]) =
  var tmp = newSeq[GLenum](args.len)
  for i, arg in args:
    tmp[i] = arg

  if tmp.len > 0:
    glDrawBuffers(tmp.len.GLsizei, tmp[0].addr)

#let renderedTexture = createAndBindEmptyTexture2D( windowsize )

#var depthrenderbuffer: GLuint

#glBindRenderbuffer(GL_RENDERBUFFER, depthrenderbuffer)
#glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT, windowsize.x.GLsizei, windowsize.y.GLsizei)

#glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthrenderbuffer)
#glFramebufferTexture(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, renderedTexture.GLuint, 0)

#var drawBuffers: array[1, GLenum] = [ GL_COLOR_ATTACHMENT0.GLenum ]
#glDrawBuffers(1, drawBuffers[0].addr)

#glBindFramebuffer(GL_FRAMEBUFFER, 0)

#### nim -> glsl type mapping ####


# returns a string, and true if it is a sample type
proc glslUniformType(value : NimNode): (string, bool) =
  let tpe = value.getType2
  if tpe.kind == nnkBracketExpr:
    case $tpe[0]
    of "Mat4x4":
      ("mat4", false)
    of "Mat3x3":
      ("mat3", false)
    of "Mat2x2":
      ("mat2", false)
    of "Vec4":
      ("vec4", false)
    of "Vec3":
      ("vec3", false)
    of "Vec2":
      ("vec2", false)
    else:
      ("(unknown:" & $tpe[0] & ")", false)
  else:
    case $tpe
    of "Texture1D":
      ("sampler1D", true)
    of "Texture2D":
      ("sampler2D", true)
    of "Texture3D":
      ("sampler3D", true)
    of "TextureRectangle":
      ("sampler2DRect", true)
    of "float32", "float64", "float":
      ("float", false)
    of "Mat4d", "Mat4f":
      ("mat4", false)
    of "Mat3d", "Mat3f":
      ("mat3", false)
    of "Mat2d", "Mat2f":
      ("mat2", false)
    of "Vec4d", "Vec4f":
      ("vec4", false)
    of "Vec3d", "Vec3f":
      ("vec3", false)
    of "Vec2d", "Vec2f":
      ("vec2", false)
    else:
      (($tpe).toLower, false)

proc glslAttribType(value : NimNode): string =
  # result = getAst(glslAttribType(value))[0].strVal
  let tpe = value.getType2

  if $tpe[0] == "seq" or $tpe[0] == "ArrayBuffer":
    tpe[1].glslUniformType[0]
  else:
    echo "not a compatible attribType: "
    echo tpe.repr
    "(error not a seq[..])"

#### Uniform ####

proc uniform(location: GLint, mat: Mat4x4[float64]) =
  var mat_float32 = mat4f(mat)
  glUniformMatrix4fv(location, 1, false, cast[ptr GLfloat](mat_float32.addr))

proc uniform(location: GLint, mat: var Mat4x4[float32]) =
  glUniformMatrix4fv(location, 1, false, cast[ptr GLfloat](mat.addr))

proc uniform(location: GLint, value: float32) =
  glUniform1f(location, value)

proc uniform(location: GLint, value: float64) =
  glUniform1f(location, value)

proc uniform(location: GLint, value: int32) =
  glUniform1i(location, value)

proc uniform(location: GLint, value: Vec2f) =
  glUniform2f(location, value[0], value[1])

proc uniform(location: GLint, value: Vec3f) =
  glUniform3f(location, value[0], value[1], value[2])

proc uniform(location: GLint, value: Vec4f) =
  glUniform4f(location, value[0], value[1], value[2], value[3])


#### Vertex Array Object ####


type VertexArrayObject* = distinct GLuint

proc newVertexArrayObject*() : VertexArrayObject =
  glGenVertexArrays(1, cast[ptr GLuint](result.addr))

const nil_vao* = VertexArrayObject(0)

proc bindIt*(vao: VertexArrayObject) =
  glBindVertexArray(GLuint(vao))

proc delete*(vao: VertexArrayObject) =
  var raw_vao = GLuint(vao)
  glDeleteVertexArrays(1, raw_vao.addr)

template blockBind*(vao: VertexArrayObject, blk: stmt) : stmt =
  vao.bindIt
  blk
  nil_vao.bindIt

#### Array Buffers ####

type ArrayBuffer*[T]        = distinct GLuint
type ElementArrayBuffer*[T] = distinct GLuint
type UniformBuffer*[T]      = distinct GLuint

proc newArrayBuffer*[T](): ArrayBuffer[T] =
  glGenBuffers(1, cast[ptr GLuint](result.addr))

proc newElementArrayBuffer*[T](): ElementArrayBuffer[T] =
  glGenBuffers(1, cast[ptr GLuint](result.addr))

proc newUniformBuffer*[T](): UniformBuffer[T] =
  glGenBuffers(1, cast[ptr GLuint](result.addr))


proc currentArrayBuffer*[T](): ArrayBuffer[T] =
  glGetIntegerv(GL_ARRAY_BUFFER_BINDING, cast[ptr GLint](result.addr))

proc currentElementArrayBuffer*[T](): ElementArrayBuffer[T] =
  glGetIntegerv(GL_ELEMENT_ARRAY_BUFFER_BINDING, cast[ptr GLint](result.addr))

proc currentUniformBuffer*[T](): UniformBuffer[T] =
  glGetIntegerv(GL_UNIFORM_BUFFER_BINDING, cast[ptr GLint](result.addr))


proc bindIt*[T](buffer: ArrayBuffer[T]) =
  glBindBuffer(GL_ARRAY_BUFFER, GLuint(buffer))

proc bindIt*[T](buffer: ElementArrayBuffer[T]) =
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, GLuint(buffer))

proc bindIt*[T](buffer: UniformBuffer[T]) =
  glBindBuffer(GL_UNIFORM_BUFFER, GLuint(buffer))

proc bindingKind*[T](buffer: ArrayBuffer[T]) : GLenum {. inline .} =
  GL_ARRAY_BUFFER_BINDING

proc bindingKind*[T](buffer: ElementArrayBuffer[T]) : GLenum {. inline .} =
  GL_ELEMENT_ARRAY_BUFFER_BINDING

proc bindingKind*[T](buffer: UniformBuffer[T]) : GLenum {. inline .} =
  GL_UNIFORM_BUFFER_BINDING

proc bufferKind*[T](buffer: ArrayBuffer[T]) : GLenum {. inline .} =
  GL_ARRAY_BUFFER

proc bufferKind*[T](buffer: ElementArrayBuffer[T]) : GLenum {. inline .} =
  GL_ELEMENT_ARRAY_BUFFER

proc bufferKind*[T](buffer: UniformBuffer[T]) : GLenum {. inline .} =
  GL_UNIFORM_BUFFER

template bindBlock(buffer, blk:untyped) =
  let buf = buffer
  var outer : GLint
  glGetIntegerv(buf.bindingKind, outer.addr)
  buf.bindIt
  blk
  glBindBuffer(buf.bufferKind, GLuint(outer))

proc bufferData*[T](buffer: ArrayBuffer[T], usage: GLenum, data: openarray[T]) =
  glBufferData(GL_ARRAY_BUFFER, GLsizeiptr(data.len * sizeof(T)), unsafeAddr(data[0]), usage)

proc bufferData*[T](buffer: ElementArrayBuffer[T], usage: GLenum, data: openarray[T]) =
  glBufferData(GL_ELEMENT_ARRAY_BUFFER, GLsizeiptr(data.len * sizeof(T)), unsafeAddr(data[0]), usage)

proc bufferData*[T](buffer: UniformBuffer[T], usage: GLenum, data: T) =
  glBufferData(GL_ARRAY_BUFFER, GLsizeiptr(sizeof(T)), unsafeAddr(data), usage)

proc len*[T](buffer: ArrayBuffer[T]) : int =
  var size: GLint
  buffer.bindBlock:
    glGetBufferParameteriv(GL_ARRAY_BUFFER, GL_BUFFER_SIZE, size.addr)
  return size.int div sizeof(T).int

proc len*[T](buffer: ElementArrayBuffer[T]) : int =
  var outer : GLint
  glGetIntegerv(GL_ELEMENT_ARRAY_BUFFER_BINDING, outer.addr)
  buffer.bindIt
  var size: GLint

  glGetBufferParameteriv(GL_ELEMENT_ARRAY_BUFFER, GL_BUFFER_SIZE, size.addr)
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, GLuint(outer))
  return size.int div sizeof(T).int

proc arrayBuffer*[T](data : openarray[T]): ArrayBuffer[T] =
  var outer : GLint
  glGetIntegerv(GL_ARRAY_BUFFER_BINDING, outer.addr)
  result = newArrayBuffer[T]()
  result.bindIt
  result.bufferData(GL_STATIC_DRAW, data)
  glBindBuffer(GL_ARRAY_BUFFER, GLuint(outer))

proc elementArrayBuffer*[T](data : openarray[T]): ElementArrayBuffer[T] =
  var outer : GLint
  glGetIntegerv(GL_ELEMENT_ARRAY_BUFFER_BINDING, outer.addr)
  result = newElementArrayBuffer[T]()
  result.bindIt
  result.bufferData(GL_STATIC_DRAW, data)
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, GLuint(outer))

proc uniformBuffer*[T](data : T): UniformBuffer[T] =
  var outer : GLint
  glGetIntegerv(GL_UNIFORM_BUFFER_BINDING, outer.addr)
  result = newElementArrayBuffer[T]()
  result.bindIt
  result.bufferData(GL_STATIC_DRAW, data)
  glBindBuffer(GL_UNIFORM_BUFFER, GLuint(outer))

#### framebuffer ####

const currentFramebuffer* = 0

# default fragment Outputs
const fragmentOutputs* = @["color"]

macro declareFramebuffer*(typename,arg:untyped) : stmt =
  typename.expectKind nnkIdent

  result = newStmtList()

  var fragmentOutputs = newSeq[string]()

  var depthType:NimNode = nil
  var depthCreateExpr:NimNode = nil

  for asgn in arg:
    asgn.expectKind nnkAsgn

    let lhs = asgn[0]
    let rhs = asgn[1]

    if lhs.ident == !"depth":
        echo rhs.treerepr
        if rhs.kind == nnkCall and rhs[0].ident == !"newRenderbuffer":
          depthType = bindSym"DepthRenderbuffer"
          depthCreateExpr = newCall(bindSym"createAndBindDepthRenderBuffer", rhs[1])

    else:
      fragmentOutputs.add($asgn[0])

  let recList = newNimNode(nnkRecList)
  recList.add( newExpIdentDef(!"glname", bindSym"FrameBuffer") )
  recList.add( newExpIdentDef(!"depth", depthType) )

  for fragOut in fragmentOutputs:
    recList.add( newExpIdentDef(!fragOut, bindSym"Texture2D") )

  result.add newObjectTy(typename, recList)


  result.add(
    newNimNode2(nnkTemplateDef,
      !!"fragmentOutputSeq",
      newEmptyNode(),
      newEmptyNode(),
      newNimNode2(nnkFormalParams,
        newNimNode2(nnkBracketExpr, bindSym"seq", bindSym"string"),
        newNimNode2(nnkIdentDefs,
          !!"t",
          newNimnode2(nnkBracketExpr,
            bindSym"typedesc",
            typename),
          newEmptyNode()
        )
      ),
      newEmptyNode(),
      newEmptyNode(),
      newNimNode2(nnkStmtList,
        fragmentOutputs.toConstExpr
      )
    )
  )

  #result.add newConstStmt(!!"fragmentOutputs", fragmentOutputs.toConstExpr)

  let branchStmtList = newStmtList()

  branchStmtList.add(newAssignment(newDotExpr(!!"fb1", !!"glname"),
    newCall(bindSym"createFrameBuffer")
  ))

  branchStmtList.add(newDotExpr(!!"fb1", !!"glname", !!"bindIt"))
  branchStmtList.add(newAssignment(newDotExpr(!!"fb1", !!"depth"),
    depthCreateExpr
  ))
  branchStmtList.add(newCall(bindSym"glFramebufferRenderbuffer", bindSym"GL_FRAMEBUFFER",
    bindSym"GL_DEPTH_ATTACHMENT", bindSym"GL_RENDERBUFFER",
    newDotExpr(!!"fb1", !!"glname", bindSym"GLuint")
  ))

  let drawBuffersCall = newCall(bindSym"drawBuffers")

  for i,name in fragmentOutputs:
    branchStmtList.add(newAssignment( newDotExpr( !!"fb1", !! name ),
      newCall( bindSym"createAndBindEmptyTexture2D", !!"windowsize" ),
    ))
    branchStmtList.add(newCall(bindSym"glFramebufferTexture", bindSym"GL_FRAMEBUFFER", !!("GL_COLOR_ATTACHMENT" & $i),
      newDotExpr(!!"fb1", !! name, bindSym"GLuint"), newLit(0)
    ))
    drawBuffersCall.add( newCall(bindSym"GLenum", !!("GL_COLOR_ATTACHMENT" & $i)) )

  branchStmtList.add( drawBuffersCall )

  let ifStmt = newNimNode2( nnkIfStmt,
    newNimNode2(nnkElifBranch,
      newInfix( !!"==", newDotExpr( !!"fb1", !!"glname", !!"int" ), newLit(0) ),
      branchStmtList
    )
  )

  let procStmtList = newStmtList( ifStmt, newDotExpr(!!"fb1", !!"glname", !!"bindIt") )

  result.add(
    newNimNode2( nnkProcDef,
      !!"initAndBindInternal",
      newEmptyNode(),
      newEmptyNode(),
      newNimNode2( nnkFormalParams,
        bindSym"void",
        newNimNode2( nnkIdentDefs,
          !!"fb1",
          newNimNode2( nnkVarTy, typename),
          newEmptyNode(),
        )
      ),
      newEmptyNode(),
      newEmptyNode(),
      procStmtList
    )
  )

template bindFramebuffer*(name, tpe, blok: untyped): stmt =
  var name {.global.}: tpe

  var drawfb, readfb: GLint
  glGetIntegerv(GL_DRAW_FRAMEBUFFER_BINDING, drawfb.addr)
  glGetIntegerv(GL_READ_FRAMEBUFFER_BINDING, readfb.addr)

  name.initAndBindInternal
  block:
    let currentFramebuffer {. inject .} = name
    const fragmentOutputs {.inject.} = name.type.fragmentOutputSeq
    blok

  glBindFramebuffer(GL_DRAW_FRAMEBUFFER, drawfb.GLuint)
  glBindFramebuffer(GL_READ_FRAMEBUFFER, readfb.GLuint)

#### etc ####

type ShaderParam* = tuple[name: string, gl_type: string]

let sourceHeader = """
#version 330
#define M_PI 3.1415926535897932384626433832795
"""

proc genShaderSource*(
    sourceHeader: string,
    uniforms : openArray[string],
    inParams : openArray[string], arrayLength: int,  # for geometry shader, -1 otherwise
    outParams: openArray[string],
    includes: openArray[string], mainSrc: string): string =
  result = sourceHeader

  for i, u in uniforms:
    result.add( u & ";\n" )
  for i, paramRaw in inParams:
    let param = paramRaw.replaceWord("out", "in")
    if arrayLength >= 0:
      result.add format("$1[$2];\n", param, arrayLength)
    else:
      result.add(param & ";\n")
  for param in outParams:
    result.add(param & ";\n")
  for incl in includes:
    result.add incl

  result.add("void main() {\n")
  result.add(mainSrc)
  result.add("\n}\n")

proc shaderSource(shader: GLuint, source: string) =
  var source_array: array[1, string] = [source]
  var c_source_array = allocCStringArray(source_array)
  defer: deallocCStringArray(c_source_array)
  glShaderSource(shader, 1, c_source_array, nil)

proc compileStatus(shader:GLuint): bool =
  var status: GLint
  glGetShaderiv(shader, GL_COMPILE_STATUS, status.addr)
  status != 0

proc linkStatus(program:GLuint): bool =
  var status: GLint
  glGetProgramiv(program, GL_LINK_STATUS, status.addr)
  status != 0

proc shaderInfoLog(shader: GLuint): string =
  var length: GLint = 0
  glGetShaderiv(shader, GL_INFO_LOG_LENGTH, length.addr)
  result = newString(length.int)
  glGetShaderInfoLog(shader, length, nil, result)

proc showError(log: string, source: string): void =
  let lines = source.splitLines
  for match in log.findIter(re"(\d+)\((\d+)\).*"):
    let line_nr = match.captures[1].parseInt;
    echo lines[line_nr - 1]
    echo match.match

proc programInfoLog(program: GLuint): string =
  var length: GLint = 0
  glGetProgramiv(program, GL_INFO_LOG_LENGTH, length.addr);
  result = newString(length.int)
  glGetProgramInfoLog(program, length, nil, result);

proc compileShader(shaderType: GLenum, source: string): GLuint =
  result = glCreateShader(shaderType)
  result.shaderSource(source)
  glCompileShader(result)

  if not result.compileStatus:
    echo "==== start Shader Problems ======================================="
    echo source
    echo "------------------------------------------------------------------"
    showError(result.shaderInfoLog, source)
    echo "==== end Shader Problems ========================================="

proc linkShader(shaders: varargs[GLuint]): GLuint =
  result = glCreateProgram()

  for shader in shaders:
    glAttachShader(result, shader)
    glDeleteShader(shader)
  glLinkProgram(result)

  if not result.linkStatus:
    echo "Log: ", result.programInfoLog
    glDeleteProgram(result)
    result = 0

proc attribSize(t: typedesc[Vec4d]) : GLint = 4
proc attribType(t: typedesc[Vec4d]) : GLenum = cGL_DOUBLE
proc attribNormalized(t: typedesc[Vec4d]) : bool = false

proc attribSize(t: typedesc[Vec3d]) : GLint = 3
proc attribType(t: typedesc[Vec3d]) : GLenum = cGL_DOUBLE
proc attribNormalized(t: typedesc[Vec3d]) : bool = false

proc attribSize(t: typedesc[Vec2d]) : GLint = 2
proc attribType(t: typedesc[Vec2d]) : GLenum = cGL_DOUBLE
proc attribNormalized(t: typedesc[Vec2d]) : bool = false

proc attribSize(t: typedesc[Vec4f]) : GLint = 4
proc attribType(t: typedesc[Vec4f]) : GLenum = cGL_FLOAT
proc attribNormalized(t: typedesc[Vec4f]) : bool = false

proc attribSize(t: typedesc[Vec3f]) : GLint = 3
proc attribType(t: typedesc[Vec3f]) : GLenum = cGL_FLOAT
proc attribNormalized(t: typedesc[Vec3f]) : bool = false

proc attribSize(t: typedesc[Vec2f]) : GLint = 2
proc attribType(t: typedesc[Vec2f]) : GLenum = cGL_FLOAT
proc attribNormalized(t: typedesc[Vec2f]) : bool = false

proc makeAndBindBuffer[T](buffer: var ArrayBuffer[T], index: GLint, value: seq[T], usage: GLenum) =
  if index >= 0:
    buffer = newArrayBuffer[T]()
    buffer.bindIt
    buffer.bufferData(usage, value)
    glVertexAttribPointer(index.GLuint, attribSize(T), attribType(T), attribNormalized(T), 0, nil)

proc bindAndAttribPointer[T](buffer: ArrayBuffer[T], index: GLint) =
  if index >= 0:
    buffer.bindIt
    glVertexAttribPointer(index.GLuint, attribSize(T), attribType(T), attribNormalized(T), 0, nil)

proc makeAndBindElementBuffer[T](buffer: var ElementArraybuffer[T], value: seq[T], usage: GLenum) =
  buffer = newElementArrayBuffer[T]()
  buffer.bindIt
  buffer.bufferData(usage, value)

proc myEnableVertexAttribArray(index: GLint, divisor: GLuint): void =
  if index >= 0:
    glEnableVertexAttribArray(index.GLuint)
    glVertexAttribDivisor(index.GLuint, divisor.GLuint)

template renderBlockTemplate(numLocations: int, globalsBlock, linkShaderBlock, bufferCreationBlock,
               initUniformsBlock, setUniformsBlock, drawCommand: expr): stmt {. dirty .} =
  block:
    var vao {.global.}: VertexArrayObject
    var glProgram {.global.}: GLuint  = 0
    var locations {.global.}: array[numLocations, GLint]

    globalsBlock

    if glProgram == 0:

      gl_program = linkShaderBlock
      glUseProgram(gl_program)

      initUniformsBlock

      vao = newVertexArrayObject()
      bindIt(vao)

      bufferCreationBlock

      glBindBuffer(GL_ARRAY_BUFFER, 0)
      bindIt(nil_vao)
      glUseProgram(0)

      #for i, loc in locations:
      #  echo "location(", i, "): ", loc



    glUseProgram(gl_program)

    bindIt(vao)

    setUniformsBlock

    drawCommand

    bindIt(nil_vao)
    glUseProgram(0);

################################################################################
## Shading Dsl #################################################################
################################################################################

proc attribute[T](name: string, value: T, divisor: GLuint) : int = 0
proc attributes(args : varargs[int]) : int = 0
proc shaderArg[T](name: string, value: T): int = 0
proc uniforms(args: varargs[int]): int = 0
proc vertexOut(args: varargs[string]): int = 0
proc geometryOut(args: varargs[string]): int = 0
proc fragmentOut(args: varargs[string]): int = 0
proc vertexMain(src: string): int = 0
proc fragmentMain(src: string): int = 0
proc geometryMain(layout, src: string): int = 0
proc includes(args: varargs[int]): int = 0
proc incl(arg: string): int = 0

################################################################################
## Shading Dsl Inner ###########################################################
################################################################################

macro shadingDslInner(mode: GLenum, count, numInstances: GLSizei, fragmentOutputs: static[seq[string]], statement: varargs[typed] ) : stmt =
  echo "shadingDslInner fragmentOutputs:"
  for i,output in fragmentOutputs:
    echo "out(", i, "): ", output

  var numSamplers = 0
  var numLocations = 0
  var uniformsSection : seq[string] = @[]
  var initUniformsBlock = newStmtList()
  var setUniformsBlock = newStmtList()
  var attributesSection : seq[string] = @[]
  var globalsBlock = newStmtList()
  var bufferCreationBlock = newStmtList()
  var vertexOutSection : seq[string] = @[]
  var geometryOutSection : seq[string] = @[]
  var fragmentOutSection : seq[string] = @[]
  for i,fragout in fragmentOutputs:
    fragmentOutSection.add format("layout(location = $1) out vec4 $2", $i, fragout)
  var includesSection : seq[string] = @[]
  var vertexMain: string
  var geometryLayout: string
  var geometryMain: string
  var fragmentMain: string

  var hasIndices = false
  var indexType: NimNode = nil
  var hasInstanceData = false

  #### BEGIN PARSE TREE ####

  proc locations(i: int) : NimNode =
    newTree(nnkBracketExpr, !!"locations", newLit(i))

  for call in statement.items:
    call.expectKind nnkCall
    case $call[0]
    of "uniforms":
      for innerCall in call[1][1].items:
        innerCall[1].expectKind nnkStrLit
        let name = $innerCall[1]
        let value = innerCall[2]


        let (glslType, isSample) = value.glslUniformType
        let baseString = "uniform " & glslType & " " & name

        initUniformsBlock.add( newAssignment(
          locations(numLocations),
          newCall( bindSym"glGetUniformLocation", !!"glProgram", newLit(name) )
        ))

        if isSample:
          initUniformsBlock.add( newCall( bindSym"glUniform1i", locations(numLocations), newLit(numSamplers) ) )

          proc activeTexture(texture: int): void =
            glActiveTexture( (GL_TEXTURE0 + texture).GLenum )

          setUniformsBlock.add( newCall( bindSym"activeTexture", newLit(numSamplers) ) )
          setUniformsBlock.add( newCall( bindSym"bindIt", value ) )
          numSamplers += 1
        else:
          setUniformsBlock.add( newCall( bindSym"uniform", locations(numLocations), value ) )

        uniformsSection.add( baseString )

        numLocations += 1

    of "attributes":
      for innerCall in call[1][1].items:
        innerCall[1].expectKind nnkStrLit
        let name = $innerCall[1]
        let value = innerCall[2]
        echo "divisor: ", innerCall[3].treeRepr
        let divisor: int =
          if innerCall[3].kind == nnkHiddenStdConv:
            innerCall[3][1].intVal.int
          elif innerCall[3].kind == nnkIntLit:
            innerCall[3].intVal.int
          else:
            0

        let buffername = !(name & "Buffer")

        let isAttrib = name != "indices"
        #echo "attribute ", value.glslAttribType, " ", name

        if divisor > 0:
          hasInstanceData = true

        if not isAttrib:
          if hasIndices:
            echo "error, has already indices"

          hasIndices = true

          case value.getType2[1].typeKind
          of ntyInt8, ntyUInt8:
            indexType = bindSym"GL_UNSIGNED_BYTE"
          of ntyInt16, ntyUInt16:
            indexType = bindSym"GL_UNSIGNED_SHORT"
          of ntyInt32, ntyUInt32:
            indexType = bindSym"GL_UNSIGNED_INT"
          of ntyInt, ntyUInt:
            echo "error int type has to be explicity sized uint8 uint16 or uint32"
          of ntyInt64, ntyUInt64:
            echo "error 64 bit indices not supported"
          else:
            echo "error unknown type kind: ", value.getType2[1].typeKind


        template foobarTemplate( lhs, rhs, bufferType : expr ) : stmt {.dirty.} =
          var lhs {.global.}: bufferType[rhs[0].type]

        let isSeq:bool = $value.getType2[0] == "seq"



        if isSeq:
          let bufferType =
            if isAttrib:
              bindSym"ArrayBuffer"
            else:
              bindSym"ElementArrayBuffer"

          globalsBlock.add(getAst(foobarTemplate( !! buffername, value, bufferType )))

        let attribCount = attributesSection.len

        if isAttrib:
          bufferCreationBlock.add( newAssignment(
            locations(numLocations),
            newCall( bindSym"glGetAttribLocation", !! "glProgram", newLit(name) )
          ))

          bufferCreationBlock.add(newCall(bindSym"myEnableVertexAttribArray", locations(numLocations), newLit(divisor)))

        if isSeq:
          if isAttrib:
            bufferCreationBlock.add(newCall(bindSym"makeAndBindBuffer",
              !! buffername,
              locations(numLocations),
              value,
              bindSym"GL_STATIC_DRAW"
            ))
          else:
            bufferCreationBlock.add(newCall(bindSym"makeAndBindElementBuffer",
              !! buffername,
              value,
              bindSym"GL_STATIC_DRAW"
            ))
        else:
          if isAttrib:
            bufferCreationBlock.add(newCall(bindSym"bindAndAttribPointer",
              value,
              locations(numLocations),
            ))
          else:
            bufferCreationBlock.add(newCall(bindSym"bindIt", value))

        if isAttrib:
          attributesSection.add( format("in $1 $2", value.glslAttribType, name) )
          numLocations += 1

    of "vertexOut":
      #echo "vertexOut"

      for innerCall in call[1][1].items:
        vertexOutSection.add( innerCall.strVal )

    of "geometryOut":

      for innerCall in call[1][1].items:
        geometryOutSection.add( innerCall.strVal )

    of "fragmentOut":

      fragmentOutSection = @[]
      for innerCall in call[1][1].items:
        fragmentOutSection.add( innerCall.strVal )

    of "includes":

      for innerCall in call[1][1].items:
        if innerCall[1].kind == nnkSym:
          let sym = innerCall[1].symbol
          includesSection.add(sym.getImpl.strVal)


    of "vertexMain":
      vertexMain = call[1].strVal

    of "fragmentMain":
      fragmentMain = call[1].strVal

    of "geometryMain":

      geometryLayout = call[1].strVal
      geometryMain = call[2].strVal

    else:
      echo "unknownSection"
      echo call.repr

  if hasIndices and indexType == nil:
    echo "has indices, but index Type was never set to anything"

  let vertexShaderSource = genShaderSource(sourceHeader, uniformsSection, attributesSection, -1, vertexOutSection, includesSection, vertexMain)

  var linkShaderBlock : NimNode

  if geometryMain == nil:

    let fragmentShaderSource = genShaderSource(sourceHeader, uniformsSection, vertexOutSection, -1, fragmentOutSection, includesSection, fragmentMain)

    linkShaderBlock = newCall( bindSym"linkShader",
      newCall( bindSym"compileShader", bindSym"GL_VERTEX_SHADER", newLit(vertexShaderSource) ),
      newCall( bindSym"compileShader", bindSym"GL_FRAGMENT_SHADER", newLit(fragmentShaderSource) ),
    )

  else:
    let geometryHeader = format("$1\nlayout($2) in;\n$3;\n", sourceHeader, geometryPrimitiveLayout(mode.intVal.GLenum), geometryLayout)
    let geometryShaderSource = genShaderSource(geometryHeader, uniformsSection, vertexOutSection, geometryNumVerts(mode.intVal.GLenum), geometryOutSection, includesSection, geometryMain)
    let fragmentShaderSource = genShaderSource(sourceHeader, uniformsSection, geometryOutSection, -1, fragmentOutSection, includesSection, fragmentMain)

    linkShaderBlock = newCall( bindSym"linkShader",
      newCall( bindSym"compileShader", bindSym"GL_VERTEX_SHADER", newLit(vertexShaderSource) ),
      newCall( bindSym"compileShader", bindSym"GL_GEOMETRY_SHADER", newLit(geometryShaderSource) ),
      newCall( bindSym"compileShader", bindSym"GL_FRAGMENT_SHADER", newLit(fragmentShaderSource) ),
    )

  let drawCommand =
    if hasIndices:
      if hasInstanceData:
        newCall( bindSym"glDrawElementsInstanced", mode, count, indexType, newNilLit(), numInstances )
      else:
        newCall( bindSym"glDrawElements", mode, count, indexType, newNilLit() )

    else:
      if hasInstanceData:
        newCall( bindSym"glDrawArraysInstanced", mode, newLit(0), count, numInstances )
      else:
        newCall( bindSym"glDrawArrays", mode, newLit(0), count )

  echo drawCommand.repr
  echo drawCommand.treeRepr

  result = getAst(renderBlockTemplate(numLocations, globalsBlock, linkShaderBlock,
         bufferCreationBlock, initUniformsBlock, setUniformsBlock, drawCommand))

  echo result.repr

################################################################################
## Shading Dsl Outer ###########################################################
################################################################################

macro shadingDsl*(mode:GLenum, count: GLsizei, statement: stmt) : stmt {.immediate.} =

  result = newCall(bindSym"shadingDslInner", mode, count, newLit(1), !! "fragmentOutputs" )

  for section in statement.items:
    section.expectKind({nnkCall, nnkAsgn})

    if section.kind == nnkAsgn:
      section.expectLen(2)
      section[0].expectKind nnkIdent
      result[3] = section[1]

    elif section.kind == nnkCall:
      let ident = section[0]
      ident.expectKind nnkIdent
      let stmtList = section[1]
      stmtList.expectKind nnkStmtList

      case $ident
      of "uniforms":
        let uniformsCall = newCall(bindSym"uniforms")

        for capture in stmtList.items:
          capture.expectKind({nnkAsgn, nnkIdent})
          if capture.kind == nnkAsgn:
            capture.expectLen 2
            capture[0].expectKind nnkIdent
            uniformsCall.add( newCall(bindSym"shaderArg", newLit($capture[0]), capture[1] ) )
          elif capture.kind == nnkIdent:
            uniformsCall.add( newCall(bindSym"shaderArg",  newLit($capture), capture) )

        result.add(uniformsCall)

      of "attributes":
        let attributesCall = newCall(bindSym"attributes")

        proc handleCapture(attributesCall, capture: NimNode, divisor: int) =
          capture.expectKind({nnkAsgn, nnkIdent})
          if capture.kind == nnkAsgn:
            capture.expectLen 2
            capture[0].expectKind nnkIdent
            attributesCall.add( newCall(bindSym"attribute", newLit($capture[0]), capture[1], newLit(divisor) ) )
          elif capture.kind == nnkIdent:
            attributesCall.add( newCall(bindSym"attribute",  newLit($capture), capture, newLit(divisor)) )


        for capture in stmtList.items:
          if capture.kind == nnkCall:
            if $capture[0] == "instanceData":
              let stmtList = capture[1]
              stmtList.expectKind nnkStmtList
              for capture in stmtList.items:
                handleCapture(attributesCall, capture, 1)

            else:
              echo "error expected call to instanceData, but got: ", capture.repr
          else:
            handleCapture(attributesCall, capture, 0)

        echo attributesCall.repr
        result.add(attributesCall)

      of "vertexOut", "geometryOut", "fragmentOut":

        let outCall =
          case $ident
          of "vertexOut": newCall(bindSym"vertexOut")
          of "geometryOut": newCall(bindSym"geometryOut")
          of "fragmentOut": newCall(bindSym"fragmentOut")
          else: nil

        for section in stmtList.items:
          section.expectKind({nnkVarSection, nnkStrLit, nnkTripleStrLit})
          case section.kind
          of nnkVarSection:
            for def in section:
              def.expectKind nnkIdentDefs
              def[0].expectKind nnkIdent
              def[1].expectKind nnkIdent
              outCall.add format("out $2 $1", $def[0], $def[1]).newLit
          of nnkStrLit:
            outCall.add section
          of nnkTripleStrLit:
            for line in section.strVal.splitLines:
              outCall.add line.strip.newLit
          else:
            error("unreachable")


        result.add(outCall)

      of "vertexMain":
        stmtList.expectLen(1)
        stmtList[0].expectKind({nnkTripleStrLit, nnkStrLit})
        result.add( newCall(bindSym"vertexMain", stmtList[0]) )

      of "geometryMain":
        stmtList.expectLen(2)
        stmtList[0].expectKind({nnkTripleStrLit, nnkStrLit})
        stmtList[1].expectKind({nnkTripleStrLit, nnkStrLit})
        result.add( newCall(bindSym"geometryMain", stmtList[0], stmtList[1]) )

      of "fragmentMain":
        stmtList.expectLen(1)
        stmtList[0].expectKind({ nnkTripleStrLit, nnkStrLit })
        result.add( newCall(bindSym"fragmentMain", stmtList[0]) )

      of "includes":
        let includesCall = newCall(bindSym"includes")

        for statement in stmtList:
          statement.expectKind( nnkIdent )

          includesCall.add( newCall(bindSym"incl", statement) )

        result.add(includesCall)
      else:
        error("unknown section " & $ident.ident)

