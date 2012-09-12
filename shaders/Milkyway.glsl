-- Ground.FS
in vec3 vNormal;
in vec4 vPosition;
//in vec2 vUvCoord;
out vec4 FragColor;
uniform vec3 Eye;


void main()
{
    vec3 light = normalize(vec3(1., 1., 1.) + Eye);
    //float s = vUvCoord.x + vUvCoord.y;
    //float r = min(1, max(10-sqrt(vPosition.x * vPosition.x + vPosition.z * vPosition.z), 0));
    //float r = clamp(1-.15*distance(eye, vPosition.xyz), 0., 1.);
    float r = clamp(.3+snoise(vPosition.xz/25.)+2*.5, 0., 1.);
    r = r*clamp(1-.045*distance(Eye.xyz, vPosition.xyz), 0., 1.);

    // blinn-phong (in progress)
    //float NdotHV = max(dot(vNormal, light),0.0);
    //float specular = 5 * gl_LightSource[0].specular * pow(NdotHV,gl_FrontMaterial.shininess);

    //FragColor = NdotHV * vec4(.7, .7, .2, 1.0);
    FragColor = r * vec4(.22, .15, .0, 1.0);
}

-- Stars.FS

//in vec3 vNormal;
in vec4 vPosition;
//in vec2 vUvCoord;
out vec4 FragColor;

void main()
{
    //float s = vUvCoord.x + vUvCoord.y;
    FragColor = vec4(.5, .5, .5, 1.0);
}

-- Grass.FS

//in vec3 vNormal;
in vec4 vPosition;
//in vec2 vUvCoord;
out vec4 FragColor;

void main()
{
    //float s = vUvCoord.x + vUvCoord.y;
    FragColor = vec4(.05, .2, .02, .5);
}


-- Grass.VS
layout(location = 0) in vec4 Position;
layout(location = 1) in vec4 Normal;
//layout(location = 2) in vec2 UvCoord;

out vec4 vPosition;
//out vec2 vUvCoord;
out vec3 vNormal;

uniform mat4 Projection;
uniform mat4 Modelview;
uniform mat4 ViewMatrix;
uniform mat4 ModelMatrix;
/*
uniform mat3 NormalMatrix;
*/
void main()
{
    /*
    vPosition = (Modelview * Position).xyz;
    gl_Position = Projection * Modelview * Position;
    vNormal = NormalMatrix * Normal;
    */
    vPosition = Position;
    gl_Position = Projection * Modelview * vPosition;
    vNormal = normalize(Normal.xyz);
}

-- Sky.FS

// --------------------- ( NOISE LIB CODE ) --------------------------------
//
// Description : Array and textureless GLSL 2D simplex noise function.
//      Author : Ian McEwan, Ashima Arts.
//  Maintainer : ijm
//     Lastmod : 20110822 (ijm)
//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.
//               Distributed under the MIT License. See LICENSE file.
//               https://github.com/ashima/webgl-noise
// 

vec3 mod289(vec3 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec2 mod289(vec2 x) {
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec3 permute(vec3 x) {
  return mod289(((x*34.0)+1.0)*x);
}

float snoise(vec2 v)
  {
  const vec4 C = vec4(0.211324865405187,  // (3.0-sqrt(3.0))/6.0
                      0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
                     -0.577350269189626,  // -1.0 + 2.0 * C.x
                      0.024390243902439); // 1.0 / 41.0
// First corner
  vec2 i  = floor(v + dot(v, C.yy) );
  vec2 x0 = v -   i + dot(i, C.xx);

// Other corners
  vec2 i1;
  //i1.x = step( x0.y, x0.x ); // x0.x > x0.y ? 1.0 : 0.0
  //i1.y = 1.0 - i1.x;
  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  // x0 = x0 - 0.0 + 0.0 * C.xx ;
  // x1 = x0 - i1 + 1.0 * C.xx ;
  // x2 = x0 - 1.0 + 2.0 * C.xx ;
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;

// Permutations
  i = mod289(i); // Avoid truncation effects in permutation
  vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
		+ i.x + vec3(0.0, i1.x, 1.0 ));

  vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
  m = m*m ;
  m = m*m ;

// Gradients: 41 points uniformly over a line, mapped onto a diamond.
// The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)

  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;

// Normalise gradients implicitly by scaling m
// Approximation of: m *= inversesqrt( a0*a0 + h*h );
  m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );

// Compute final noise value at P
  vec3 g;
  g.x  = a0.x  * x0.x  + h.x  * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}
// --------------------- ( END NOISE LIB CODE ) --------------------------------


//in vec3 vNormal;
in vec4 vPosition;
in vec2 vUvCoord;
out vec4 FragColor;
uniform float Azimuth;
uniform float Altitude;

void main()
{
    // compute the azimuth and altitude (thank you, undergrad astronomy :)
    
    // TODO: Azimuth should be spherically warped; maybe a plane deformation
    // Reflect noise across the sky, given that Azimuth in [-1,1] and uv.u in [-1,1]
    float u = Azimuth + .4*vUvCoord.x;
    if (u < 0) {
        u = -Azimuth - .4*vUvCoord.x;
    } 
    if (u > 1) {
        u = 2 - u;
    }
    // adjust the noise scale
    u *= 1;

    FragColor = vec4(.0, .0, .2*snoise(vec2(u, Altitude+vUvCoord.y)), 1.0);
}


-- Sky.VS
layout(location = 0) in vec4 Position;
layout(location = 1) in vec4 Normal;
layout(location = 2) in vec2 UvCoord;

out vec4 vPosition;
out vec2 vUvCoord;
//out vec3 vNormal;

uniform mat4 Projection;
uniform mat4 Modelview;
uniform mat4 ViewMatrix;
uniform mat4 ModelMatrix;
/*
uniform mat3 NormalMatrix;
*/
void main()
{
    /*
    vPosition = (Modelview * Position).xyz;
    gl_Position = Projection * Modelview * Position;
    vNormal = NormalMatrix * Normal;
    */
    vPosition = Position;
    vPosition.z = .999990;
    vPosition.w = 1.0;
    vUvCoord = UvCoord;
    //gl_Position = vPosition;
    //gl_Position = Projection * Modelview * vPosition;
    gl_Position = vPosition;
    //vNormal = normalize(Normal.xyz);
}

-- Blur.FS

//in vec3 vNormal;
in vec4 vPosition;
in vec2 vUvCoord;
out vec4 FragColor;

uniform sampler2D Tex;

void main()
{
    float s = vUvCoord.x + vUvCoord.y;
    vec4 tval = texture(Tex, vUvCoord);
    //FragColor = vec4(1., 1., 1., 1.0); //tval;
    FragColor = tval;
}


-- Blur.VS
layout(location = 0) in vec2 Position;
layout(location = 2) in vec2 UvCoord;

out vec4 vPosition;
out vec2 vUvCoord;
//out vec3 vNormal;

uniform mat4 Projection;
uniform mat4 Modelview;
uniform mat4 ViewMatrix;
uniform mat4 ModelMatrix;
/*
uniform mat3 NormalMatrix;
*/
void main()
{
    /*
    vPosition = (Modelview * Position).xyz;
    gl_Position = Projection * Modelview * Position;
    vNormal = NormalMatrix * Normal;
    */
    vPosition.xy = Position.xy;
    //vPosition.z = -2;
    vPosition.w = 1.0;
    vUvCoord = UvCoord;
    gl_Position = Projection * Modelview * vPosition;
}