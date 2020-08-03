shader_type canvas_item;

//uniform vec3 color = vec3(0.33, 0.15, 0.82);
uniform vec3 color = vec3(1.0, 1.0, 1.0);
uniform int OCTAVES = 4;
uniform float fog_speed = 0.2;

float rand(vec2 coord){
	return fract(sin(dot(coord, vec2(56, 78)) * 1000.0) * 1000.0);
}

float noise(vec2 coord){
	vec2 i = floor(coord);
	vec2 f = fract(coord);
	
	float a = rand(i);
	float b = rand(i + vec2(1.0, 0.0));
	float c = rand(i + vec2(0.0, 1.0));
	float d = rand(i + vec2(1.0, 1.0));
	
	vec2 cubic = f * f * (3.0 - 2.0 * f);
	
	return mix(a, b, f.x) + (c-a) * f.y * (1.0 -f.x) + (d-b) * f.x * f.y;
}

float fbm(vec2 coord){
	float value = 0.0;
	float scale = 0.5;
	
	for(int i = 0; i < OCTAVES; i++){
		value += noise(coord) * scale;
		coord *= 2.0;
		scale *= 0.5;
	}
	return value;
}

void fragment(){
	vec2 coord = UV * 20.0;
	vec2 motion = vec2(fbm(coord + TIME * fog_speed));
	
	float final = fbm(coord + motion);
	COLOR = vec4(color, final * 0.5);
}
