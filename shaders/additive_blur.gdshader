shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;
uniform sampler2D LAST_FRAME : hint_default_black, filter_nearest_mipmap;
uniform float blend_strength : hint_range(0.0, 1.0, 0.01);

vec4 screen(vec4 base, vec4 blend){
	return 1.0 - (1.0 - base) * (1.0 - blend);
}

vec4 add(vec4 base, vec4 blend){
	return base + blend;
}

vec4 overlay(vec4 base, vec4 blend){
	vec4 limit = step(0.5, base);
	return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);
}

vec4 soft_light(vec4 base, vec4 blend){
	vec4 limit = step(0.5, blend);
	return mix(2.0 * base * blend + base * base * (1.0 - 2.0 * blend), sqrt(base) * (2.0 * blend - 1.0) + (2.0 * base) * (1.0 - blend), limit);
}


vec2 scale(vec2 uv, float x, float y)
{
	mat2 scale = mat2(vec2(x, 0.0), vec2(0.0, y));
	
	uv -= 0.5;
	uv = uv * scale;
	uv += 0.5;
	return uv;
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 c = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0); 
	vec4 old = textureLod(LAST_FRAME, scale(SCREEN_UV, 0.95, 0.99), 0); 
	
	
	c.rgb = add(c, old * blend_strength).rgb;
	//c.rgb = c.rgb + (old.rgb * blend_strength);
	//c.rgb = overlay(c, old * blend_strength).rgb;
	//c.rgb = soft_light(c, old * blend_strength).rgb;
	
	COLOR = vec4(c.r, c.g, c.b, 1);
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}