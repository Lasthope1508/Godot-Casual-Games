// ==============================================================================
// SINGLE SOURCE OF TRUTH: Sprite2D Hit Flash Shader (Godot 4.x - CanvasItem)
// ==============================================================================
// Usage:
// 1. Assign a new ShaderMaterial to your Sprite2D's Material property.
// 2. Set this shader inside that ShaderMaterial.
// 3. Control "active" and "flash_color" uniforms in code to flash the sprite:
//    sprite.material.set_shader_parameter("active", true)
// ==============================================================================
shader_type canvas_item;

uniform bool active = false;
uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // White default

void fragment() {
	vec4 original_color = texture(TEXTURE, UV);
	
	if (active) {
		// Replace RGB with flash_color, keep original alpha transparency
		COLOR = vec4(flash_color.rgb, original_color.a);
	} else {
		COLOR = original_color;
	}
}
