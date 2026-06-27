// ==============================================================================
// SINGLE SOURCE OF TRUTH: Noise Dissolve Shader (Godot 4.x - CanvasItem)
// ==============================================================================
// Usage:
// 1. Assign a ShaderMaterial to your Sprite2D.
// 2. Set this shader inside that material.
// 3. Assign a NoiseTexture2D to the "noise_texture" parameter.
// 4. Animate the "dissolve_value" from 0.0 (fully visible) to 1.0 (fully dissolved) in a Tween.
// ==============================================================================
shader_type canvas_item;

uniform sampler2D noise_texture : hint_default_white;
uniform float dissolve_value : hint_range(0.0, 1.0) = 0.0;
uniform vec4 burn_color : source_color = vec4(1.0, 0.3, 0.0, 1.0); // Orange/Fire border
uniform float burn_size : hint_range(0.0, 0.2) = 0.05;

void fragment() {
	vec4 main_texture = texture(TEXTURE, UV);
	float noise_value = texture(noise_texture, UV).r;
	
	// Determine if pixel should be discarded
	// If noise_value is less than dissolve_value, we discard it
	if (noise_value < dissolve_value) {
		discard;
	}
	
	// Calculate burn border effect
	float border = dissolve_value + burn_size;
	if (noise_value < border && dissolve_value > 0.0) {
		// Blend the burn color on the edges
		float lerp_factor = (border - noise_value) / burn_size;
		vec4 mix_color = mix(main_texture, burn_color, lerp_factor);
		COLOR = vec4(mix_color.rgb, main_texture.a);
	} else {
		COLOR = main_texture;
	}
}
