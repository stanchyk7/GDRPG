shader_type canvas_item;

uniform float opacity : hint_range(-0.01,1.0) = 1.0;
uniform float fill : hint_range(-0.01,1.0) = 1.0;
uniform sampler2D heightMap;

void fragment(){
	float h = texture(heightMap,UV).x;
	h = clamp(floor(h+fill),0.0,1.0);
	COLOR.a *= h;
	COLOR.a *= opacity;
}