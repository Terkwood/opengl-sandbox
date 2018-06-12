
#[ Copyright (c) Mark J. Kilgard, 1994, 2001. ]#

#[
(c) Copyright 1993, Silicon Graphics, Inc.

ALL RIGHTS RESERVED

Permission to use, copy, modify, and distribute this software
for any purpose and without fee is hereby granted, provided
that the above copyright notice appear in all copies and that
both the copyright notice and this permission notice appear in
supporting documentation, and that the name of Silicon
Graphics, Inc. not be used in advertising or publicity
pertaining to distribution of the software without specific,
written prior permission.

THE MATERIAL EMBODIED ON THIS SOFTWARE IS PROVIDED TO YOU
"AS-IS" AND WITHOUT WARRANTY OF ANY KIND, EXPRESS, IMPLIED OR
OTHERWISE, INCLUDING WITHOUT LIMITATION, ANY WARRANTY OF
MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  IN NO
EVENT SHALL SILICON GRAPHICS, INC.  BE LIABLE TO YOU OR ANYONE
ELSE FOR ANY DIRECT, SPECIAL, INCIDENTAL, INDIRECT OR
CONSEQUENTIAL DAMAGES OF ANY KIND, OR ANY DAMAGES WHATSOEVER,
INCLUDING WITHOUT LIMITATION, LOSS OF PROFIT, LOSS OF USE,
SAVINGS OR REVENUE, OR THE CLAIMS OF THIRD PARTIES, WHETHER OR
NOT SILICON GRAPHICS, INC.  HAS BEEN ADVISED OF THE POSSIBILITY
OF SUCH LOSS, HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
ARISING OUT OF OR IN CONNECTION WITH THE POSSESSION, USE OR
PERFORMANCE OF THIS SOFTWARE.

US Government Users Restricted Rights

Use, duplication, or disclosure by the Government is subject to
restrictions set forth in FAR 52.227.19(c)(2) or subparagraph
(c)(1)(ii) of the Rights in Technical Data and Computer
Software clause at DFARS 252.227-7013 and/or in similar or
successor clauses in the FAR or the DOD or NASA FAR
Supplement.  Unpublished-- rights reserved under the copyright
laws of the United States.  Contractor/manufacturer is Silicon
Graphics, Inc., 2011 N.  Shoreline Blvd., Mountain View, CA
94039-7311.
]#


#[ Rim, body, lid, and bottom data must be reflected in x and
   y; handle and spout data across the y axis only.  ]#

import glm

let patchdata*: seq[array[16,int32]] = @[
    #[ rim ]#
  [102'i32, 103, 104, 105, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15],
    #[ body ]#
  [12'i32, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27],
  [24'i32, 25, 26, 27, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40],
    #[ lid ]#
  [96'i32, 96, 96, 96, 97, 98, 99, 100, 101, 101, 101, 101, 0, 1, 2, 3,],
  [0'i32, 1, 2, 3, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117],
    #[ bottom ]#
  [118'i32, 118, 118, 118, 124, 122, 119, 121, 123, 126, 125, 120, 40, 39, 38, 37],
    #[ handle ]#
  [41'i32, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56],
  [53'i32, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 28, 65, 66, 67],
    #[ spout ]#
  [68'i32, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83],
  [80'i32, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95]
]

#[ *INDENT-OFF* ]#

type
  MyVertexType = tuple
    position_os: Vec4f
    normal_os: Vec4f
    texCoord: Vec2f

var cpdata* = [
    vec3f( 0.2000f,  0.0000f,  2.70000f),
    vec3f( 0.2000f, -0.1120f,  2.70000f),
    vec3f( 0.1120f, -0.2000f,  2.70000f),
    vec3f( 0.0000f, -0.2000f,  2.70000f),
    vec3f( 1.3375f,  0.0000f,  2.53125f),
    vec3f( 1.3375f, -0.7490f,  2.53125f),
    vec3f( 0.7490f, -1.3375f,  2.53125f),
    vec3f( 0.0000f, -1.3375f,  2.53125f),
    vec3f( 1.4375f,  0.0000f,  2.53125f),
    vec3f( 1.4375f, -0.8050f,  2.53125f),
    vec3f( 0.8050f, -1.4375f,  2.53125f),
    vec3f( 0.0000f, -1.4375f,  2.53125f),
    vec3f( 1.5000f,  0.0000f,  2.40000f),
    vec3f( 1.5000f, -0.8400f,  2.40000f),
    vec3f( 0.8400f, -1.5000f,  2.40000f),
    vec3f( 0.0000f, -1.5000f,  2.40000f),
    vec3f( 1.7500f,  0.0000f,  1.87500f),
    vec3f( 1.7500f, -0.9800f,  1.87500f),
    vec3f( 0.9800f, -1.7500f,  1.87500f),
    vec3f( 0.0000f, -1.7500f,  1.87500f),
    vec3f( 2.0000f,  0.0000f,  1.35000f),
    vec3f( 2.0000f, -1.1200f,  1.35000f),
    vec3f( 1.1200f, -2.0000f,  1.35000f),
    vec3f( 0.0000f, -2.0000f,  1.35000f),
    vec3f( 2.0000f,  0.0000f,  0.90000f),
    vec3f( 2.0000f, -1.1200f,  0.90000f),
    vec3f( 1.1200f, -2.0000f,  0.90000f),
    vec3f( 0.0000f, -2.0000f,  0.90000f),
    vec3f(-2.0000f,  0.0000f,  0.90000f),
    vec3f( 2.0000f,  0.0000f,  0.45000f),
    vec3f( 2.0000f, -1.1200f,  0.45000f),
    vec3f( 1.1200f, -2.0000f,  0.45000f),
    vec3f( 0.0000f, -2.0000f,  0.45000f),
    vec3f( 1.5000f,  0.0000f,  0.22500f),
    vec3f( 1.5000f, -0.8400f,  0.22500f),
    vec3f( 0.8400f, -1.5000f,  0.22500f),
    vec3f( 0.0000f, -1.5000f,  0.22500f),
    vec3f( 1.5000f,  0.0000f,  0.15000f),
    vec3f( 1.5000f, -0.8400f,  0.15000f),
    vec3f( 0.8400f, -1.5000f,  0.15000f),
    vec3f( 0.0000f, -1.5000f,  0.15000f),
    vec3f(-1.6000f,  0.0000f,  2.02500f),
    vec3f(-1.6000f, -0.3000f,  2.02500f),
    vec3f(-1.5000f, -0.3000f,  2.25000f),
    vec3f(-1.5000f,  0.0000f,  2.25000f),
    vec3f(-2.3000f,  0.0000f,  2.02500f),
    vec3f(-2.3000f, -0.3000f,  2.02500f),
    vec3f(-2.5000f, -0.3000f,  2.25000f),
    vec3f(-2.5000f,  0.0000f,  2.25000f),
    vec3f(-2.7000f,  0.0000f,  2.02500f),
    vec3f(-2.7000f, -0.3000f,  2.02500f),
    vec3f(-3.0000f, -0.3000f,  2.25000f),
    vec3f(-3.0000f,  0.0000f,  2.25000f),
    vec3f(-2.7000f,  0.0000f,  1.80000f),
    vec3f(-2.7000f, -0.3000f,  1.80000f),
    vec3f(-3.0000f, -0.3000f,  1.80000f),
    vec3f(-3.0000f,  0.0000f,  1.80000f),
    vec3f(-2.7000f,  0.0000f,  1.57500f),
    vec3f(-2.7000f, -0.3000f,  1.57500f),
    vec3f(-3.0000f, -0.3000f,  1.35000f),
    vec3f(-3.0000f,  0.0000f,  1.35000f),
    vec3f(-2.5000f,  0.0000f,  1.12500f),
    vec3f(-2.5000f, -0.3000f,  1.12500f),
    vec3f(-2.6500f, -0.3000f,  0.93750f),
    vec3f(-2.6500f,  0.0000f,  0.93750f),
    vec3f(-2.0000f, -0.3000f,  0.90000f),
    vec3f(-1.9000f, -0.3000f,  0.60000f),
    vec3f(-1.9000f,  0.0000f,  0.60000f),
    vec3f( 1.7000f,  0.0000f,  1.42500f),
    vec3f( 1.7000f, -0.6600f,  1.42500f),
    vec3f( 1.7000f, -0.6600f,  0.60000f),
    vec3f( 1.7000f,  0.0000f,  0.60000f),
    vec3f( 2.6000f,  0.0000f,  1.42500f),
    vec3f( 2.6000f, -0.6600f,  1.42500f),
    vec3f( 3.1000f, -0.6600f,  0.82500f),
    vec3f( 3.1000f,  0.0000f,  0.82500f),
    vec3f( 2.3000f,  0.0000f,  2.10000f),
    vec3f( 2.3000f, -0.2500f,  2.10000f),
    vec3f( 2.4000f, -0.2500f,  2.02500f),
    vec3f( 2.4000f,  0.0000f,  2.02500f),
    vec3f( 2.7000f,  0.0000f,  2.40000f),
    vec3f( 2.7000f, -0.2500f,  2.40000f),
    vec3f( 3.3000f, -0.2500f,  2.40000f),
    vec3f( 3.3000f,  0.0000f,  2.40000f),
    vec3f( 2.8000f,  0.0000f,  2.47500f),
    vec3f( 2.8000f, -0.2500f,  2.47500f),
    vec3f( 3.5250f, -0.2500f,  2.49375f),
    vec3f( 3.5250f,  0.0000f,  2.49375f),
    vec3f( 2.9000f,  0.0000f,  2.47500f),
    vec3f( 2.9000f, -0.1500f,  2.47500f),
    vec3f( 3.4500f, -0.1500f,  2.51250f),
    vec3f( 3.4500f,  0.0000f,  2.51250f),
    vec3f( 2.8000f,  0.0000f,  2.40000f),
    vec3f( 2.8000f, -0.1500f,  2.40000f),
    vec3f( 3.2000f, -0.1500f,  2.40000f),
    vec3f( 3.2000f,  0.0000f,  2.40000f),
    vec3f( 0.0000f,  0.0000f,  3.15000f),
    vec3f( 0.8000f,  0.0000f,  3.15000f),
    vec3f( 0.8000f, -0.4500f,  3.15000f),
    vec3f( 0.4500f, -0.8000f,  3.15000f),
    vec3f( 0.0000f, -0.8000f,  3.15000f),
    vec3f( 0.0000f,  0.0000f,  2.85000f),
    vec3f( 1.4000f,  0.0000f,  2.40000f),
    vec3f( 1.4000f, -0.7840f,  2.40000f),
    vec3f( 0.7840f, -1.4000f,  2.40000f),
    vec3f( 0.0000f, -1.4000f,  2.40000f),
    vec3f( 0.4000f,  0.0000f,  2.55000f),
    vec3f( 0.4000f, -0.2240f,  2.55000f),
    vec3f( 0.2240f, -0.4000f,  2.55000f),
    vec3f( 0.0000f, -0.4000f,  2.55000f),
    vec3f( 1.3000f,  0.0000f,  2.55000f),
    vec3f( 1.3000f, -0.7280f,  2.55000f),
    vec3f( 0.7280f, -1.3000f,  2.55000f),
    vec3f( 0.0000f, -1.3000f,  2.55000f),
    vec3f( 1.3000f,  0.0000f,  2.40000f),
    vec3f( 1.3000f, -0.7280f,  2.40000f),
    vec3f( 0.7280f, -1.3000f,  2.40000f),
    vec3f( 0.0000f, -1.3000f,  2.40000f),
    vec3f( 0.0000f,  0.0000f,  0.00000f),
    vec3f( 1.4250f, -0.7980f,  0.00000f),
    vec3f( 1.5000f,  0.0000f,  0.07500f),
    vec3f( 1.4250f,  0.0000f,  0.00000f),
    vec3f( 0.7980f, -1.4250f,  0.00000f),
    vec3f( 0.0000f, -1.5000f,  0.07500f),
    vec3f( 0.0000f, -1.4250f,  0.00000f),
    vec3f( 1.5000f, -0.8400f,  0.07500f),
    vec3f( 0.8400f, -1.5000f,  0.07500f),
]

let tex: array[2, array[2, array[2, float32]]] = [
  [ [0.0f, 0.0f],
    [1.0f, 0.0f]],
  [ [0.0f, 1.0f],
    [1.0f, 1.0f]]
]

#[ *INDENT-ON* ]#

import algorithm

proc binom*(n,k: int): int =
  var buffer: array[64,int]
  buffer[0] = 1
  for i in 0 .. n:
    for j in 0 ..< i:
      buffer[j] = buffer[j] + buffer[j+1]
    discard buffer.rotateLeft(-1)
  result = buffer[k+1]

when isMainModule:
  doAssert binom(10,0) == 1
  doAssert binom(10,10) == 1
  doAssert binom(10,6) == 210
  doAssert binom(49,6) == 13983816

proc bernstein(i,n: int; u: float32): float32 =
  result = binom(n,i).float32 * pow(u, float32(i)) * pow(1-u,float32(n-i))

proc teapot*(grid: int32; scale: float32): seq[MyVertexType] =
  var res: seq[MyVertexType]

  var
    p: array[4, array[4, Vec3f]]
    q: array[4, array[4, Vec3f]]
    r: array[4, array[4, Vec3f]]
    s: array[4, array[4, Vec3f]]

  #glPushAttrib(GL_ENABLE_BIT or GL_EVAL_BIT)
  #glEnable(GL_AUTO_NORMAL)
  #glEnable(GL_NORMALIZE)

  #glEnable(GL_MAP2_VERTEX_3)
  #glEnable(GL_MAP2_TEXTURE_COORD_2)

  #glPushMatrix()
  #glRotatef(270.0, 1.0, 0.0, 0.0)
  #glScalef(0.5 * scale, 0.5 * scale, 0.5 * scale)
  #glTranslatef(0.0, 0.0, -1.5)

  proc evalCoord(u,v: float32, controlPoints: array[4, array[4, Vec3f]]): void =
    let texCoord = vec2f(u,v)
    var position: Vec4f

    let n,m = 3
    for i in 0 .. n:
      for j in 0 .. m:
        position.xyz += bernstein(i,n,u) * bernstein(j,m,v) * controlPoints[i][j]

    position.w = 1

    # TODO normal not calculated yet
    var normal: Vec4f
    res.add( (position, normal, texCoord ) )

  proc evalMesh(controlPoints: array[4, array[4, Vec3f]], n: Vec2i, uv1, uv2: Vec2f): void =

    let
      un = n.x
      vn = n.y
      u1 = uv1.x
      u2 = uv2.x
      v1 = uv1.y
      v2 = uv2.y

      du = (u2 - u1) / float32(un)
      dv = (v2 - v1) / float32(vn)

    for i in 0 ..< un:
      # glEvalMesh2(typ, 0, grid, 0, grid)
      # glBegin( GL_QUAD_STRIP )
      for j in 0 ..< vn:
        let u = u1 + float32(i) * du
        let v = v1 + float32(j) * dv

        evalCoord(u   ,v   , controlPoints)
        evalCoord(u   ,v+dv, controlPoints)
        evalCoord(u+du,v   , controlPoints)

        evalCoord(u+du,v+dv, controlPoints)
        evalCoord(u+du,v   , controlPoints)
        evalCoord(u   ,v+dv, controlPoints)


      #glEnd( GL_QUAD_STRIP )

  for i in 0 ..< 10:
    for j in 0 ..< 4:
      for k in 0 ..< 4:
        p[j][k] = cpdata[patchdata[i][j * 4 + k]]
        q[j][k] = cpdata[patchdata[i][j * 4 + (3 - k)]]
        q[j][k].y *= -1.0f

        if i < 6:
          r[j][k] = cpdata[patchdata[i][j * 4 + (3 - k)]]
          r[j][k].x *= -1.0f
          s[j][k] = cpdata[patchdata[i][j * 4 + k]]
          s[j][k].xy *= -1.0f

    #glMap2f(GL_MAP2_TEXTURE_COORD_2, 0, 1, 2, 2, 0, 1, 2*2, 2, tex[0][0][0].addr)

    # glMapGrid2f(grid, 0.0, 1.0, grid, 0.0, 1.0)

    evalMesh(p, vec2i(grid), vec2f(0), vec2f(1))
    evalMesh(q, vec2i(grid), vec2f(0), vec2f(1))

    # only the first six surfaces are mirrored
    if i < 6:
      evalMesh(r, vec2i(grid), vec2f(0), vec2f(1))
      evalMesh(s, vec2i(grid), vec2f(0), vec2f(1))


  return res

#teapot(7, scale)
#teapot(10, scale)
