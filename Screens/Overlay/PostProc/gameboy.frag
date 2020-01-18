#version 110

// 5 shades of green, whatever

varying vec2 imageCoord;
varying vec2 textureCoord;
uniform vec2 resolution;
uniform sampler2D sampler0;
uniform float scale;

bool cx(){
	return floor(mod(imageCoord.x * resolution.x*scale, 3.0)) == 0.0;
}

bool cy(){
	return floor(mod(imageCoord.y * resolution.y*scale, 3.0)) == 0.0;
}


void main() {
	float mul = 1.0;
	if(cx() || cy()){
		mul = 0.3333;
	}

	vec4 sample = texture2D(sampler0, textureCoord);
	float grey = 0.21 * sample.r + 0.71 * sample.g + 0.07 * sample.b;
	float green = max(min(floor(grey*5.0*mul)/3.0+0.25,1.5),0.25);
	gl_FragColor = vec4(green/10.0+0.2,green+0.1,green/10.0+0.2, 1.0);
}