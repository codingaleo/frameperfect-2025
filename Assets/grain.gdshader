shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

// Uniforms
uniform sampler2D screen_texture : hint_screen_texture;
uniform float grain_amount : hint_range(0.0, 1.0) = 0.5; // Adjust the amount of grain
uniform float grain_size : hint_range(0.1, 10.0) = 5.0; // Adjust the size of the grain
uniform bool enable_color_distortion = true;            // Vintage color effects
uniform float distortion_strength : hint_range(0.0, 0.5) = 0.1;

void fragment() {
    // Sample the original screen texture
    vec4 original_color = texture(screen_texture, SCREEN_UV);

    // Generate random noise
    float noise = (fract(sin(dot(UV + TIME, vec2(12.9898, 78.233))) * 43758.5453) - 0.5) * 2.0;

    // Add noise to the original color
    original_color.rgb += noise * grain_amount * grain_size;

	if (enable_color_distortion) {
        vec2 distortion = vec2(0.1, 0.1) * distortion_strength;

        original_color.r = texture(screen_texture, SCREEN_UV + distortion * 0.3).r;
        original_color.b = texture(screen_texture, SCREEN_UV - distortion * 0.3).b;
    }

    // Clamp the final color to make sure it stays in the valid range
    COLOR = clamp(original_color, 0.0, 1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
