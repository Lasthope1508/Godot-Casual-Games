# ==============================================================================
# SINGLE SOURCE OF TRUTH: 2D Dash Ghost / Afterimage Generator (Godot 4.x)
# ==============================================================================
# Instantiates a temporary sprite copying the player's current frame state
# and fades it out using Tweens to create a smooth dash tail effect.
# ==============================================================================
class_name DashGhost
extends RefCounted

# Spawn a ghost afterimage for a target sprite
# source_sprite: Sprite2D or AnimatedSprite2D to clone
# parent: Node to add the ghost to (should be level root, not the moving player)
# lifetime: how long the ghost takes to fade away
# ghost_color: color modulation (e.g. semi-transparent blue)
static func spawn(source_sprite: Node2D, parent: Node, lifetime: float = 0.4, ghost_color: Color = Color(0.3, 0.6, 1.0, 0.6)) -> Sprite2D:
	if source_sprite == null or not is_instance_valid(source_sprite):
		return null
		
	var ghost = Sprite2D.new()
	ghost.global_transform = source_sprite.global_transform
	
	# Copy texture and frame state depending on sprite type
	if source_sprite is Sprite2D:
		ghost.texture = source_sprite.texture
		ghost.region_enabled = source_sprite.region_enabled
		ghost.region_rect = source_sprite.region_rect
		ghost.hframes = source_sprite.hframes
		ghost.vframes = source_sprite.vframes
		ghost.frame = source_sprite.frame
		ghost.centered = source_sprite.centered
		ghost.offset = source_sprite.offset
		ghost.flip_h = source_sprite.flip_h
		ghost.flip_v = source_sprite.flip_v
	elif source_sprite is AnimatedSprite2D:
		var frames = source_sprite.sprite_frames
		if frames:
			var anim = source_sprite.animation
			var frame_idx = source_sprite.frame
			ghost.texture = frames.get_frame_texture(anim, frame_idx)
			ghost.centered = source_sprite.centered
			ghost.offset = source_sprite.offset
			ghost.flip_h = source_sprite.flip_h
			ghost.flip_v = source_sprite.flip_v
			
	# Apply modulation
	ghost.modulate = ghost_color
	
	# Add to scene
	parent.add_child(ghost)
	
	# Animate fade out and auto-free
	var tween = ghost.create_tween()
	tween.tween_property(ghost, "modulate:a", 0.0, lifetime)
	tween.tween_callback(ghost.queue_free)
	
	return ghost
