#version 120

#define saturate(i) clamp(i,0.,1.)

varying vec2 textureCoord;
varying vec2 imageCoord;
varying vec4 color;

uniform vec2 textureSize;
uniform vec2 imageSize;

uniform float howGray = 0.85;
uniform float time = 0;
uniform float amp = 0;

uniform sampler2D sampler0;

float rand(float x)
{
 return fract(sin(x) * 43758.5453);
}

float gray( vec3 _i ) {
  return dot( _i, vec3( 0.299, 0.587, 0.114 ) );
}

vec3 lerp( vec3 col1, vec3 col2, float t )
{
	return (1 - t) * col1 + t * col2;
}

vec2 texCoord2imgCoord( vec2 uv )
{
  return uv / textureSize * imageSize;
}

//float3 GrayscalePass( float4 vpos : SV_Position, float2 texcoord : TexCoord ) : SV_Target {
void main(void)
{
	
	float timer = time*0.5;
	vec2 uv = imageCoord;
	float xdist = 0;
	float yspacing = 0.5;
	
	xdist = uv.x + amp*0.03*(sin((8*uv.y*(1/yspacing)) + (timer*8))*0.06);
  
  vec4 tex = texture2D(sampler0, texCoord2imgCoord(vec2(xdist, uv.y)));
  vec3 col = lerp( tex.xyz, vec3(gray( tex.xyz )), howGray );

	gl_FragColor = vec4(saturate( col ), tex.a )*color;
}
