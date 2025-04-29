shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

uniform bool apply = true;
uniform float amount = 1.0;
uniform sampler2D offset_texture : source_color;

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	vec4 color = texture_color;
	
	if (apply == true) {
		float adjusted_amount = amount * texture(offset_texture, UV).r / 100.0;
		color.r = texture(TEXTURE, vec2(UV.x + adjusted_amount, UV.y)).r;
		color.g = texture(TEXTURE, UV).g;
		color.b = texture(TEXTURE, vec2(UV.x - adjusted_amount, UV.y)).b;
	}
	COLOR = color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
