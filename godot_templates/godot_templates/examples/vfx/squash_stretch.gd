# ==============================================================================
# SINGLE SOURCE OF TRUTH: Squash & Stretch Animation Helper (Godot 4.x)
# ==============================================================================
# Applies soft cartoon-like squash/stretch effects to any Node2D using Tweens.
# Preserves approximate volume by scaling the opposite axis inversely.
# ==============================================================================
class_name SquashStretch
extends RefCounted

# Apply squash/stretch effect to a sprite or Node2D
# target: the Node2D (e.g., Sprite2D or CharacterBody2D)
# amount: positive for vertical stretch/horizontal squash, negative for vertical squash/horizontal stretch
# duration: time to complete the impact
static func apply(target: Node2D, amount: float = 0.2, duration: float = 0.15) -> void:
	if not is_instance_valid(target):
		return

	# Stop any running scale tween on this node to avoid conflicts
	var tween = target.create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	# Calculate target scale values preserving volume
	var target_scale = Vector2(1.0 - amount, 1.0 + amount)
	
	# 1. Animate to squash/stretch state
	tween.tween_property(target, "scale", target_scale, duration * 0.4)
	
	# 2. Animate back to original scale (1.0, 1.0) with an elastic bounce
	tween.tween_property(target, "scale", Vector2.ONE, duration * 0.6).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

# Convenient presets:
# Bouncing / Jumping (vertical stretch)
static func play_jump(target: Node2D) -> void:
	apply(target, 0.15, 0.2)

# Landing (horizontal squash)
static func play_land(target: Node2D) -> void:
	apply(target, -0.2, 0.25)
