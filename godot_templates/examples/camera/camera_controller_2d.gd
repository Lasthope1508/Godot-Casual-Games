# ==============================================================================
# DETAILED PRODUCTION TEMPLATE: Advanced 2D Camera Controller (Godot 4.x)
# ==============================================================================
# Features:
# - Smooth target follow (Lerp)
# - Look-Ahead / Target Leading: Looks ahead in the direction the target moves
# - Map boundaries check
# - Target Switching (e.g., smoothly panning to focus on a boss or switch player)
# - Shake effect integration
# ==============================================================================
class_name CameraController2D
extends Camera2D

@export var target: Node2D
@export var follow_speed: float = 5.0

# Look-Ahead Settings (Target Leading)
@export var look_ahead_distance: float = 120.0
@export var look_ahead_speed: float = 3.0

# Margins / Boundaries
@export var limit_left_node: Marker2D
@export var limit_right_node: Marker2D
@export var limit_top_node: Marker2D
@export var limit_bottom_node: Marker2D

var current_target: Node2D
var target_offset: Vector2 = Vector2.ZERO
var look_ahead_vector: Vector2 = Vector2.ZERO
var is_shaking: bool = false

func _ready() -> void:
	current_target = target
	setup_limits()

func _physics_process(delta: float) -> void:
	if not is_instance_valid(current_target):
		return
		
	var target_pos = current_target.global_position
	
	# Calculate look-ahead vector based on target velocity if it is a CharacterBody2D
	if current_target is CharacterBody2D:
		var velocity = current_target.velocity
		if velocity.length_squared() > 100.0:
			var target_dir = velocity.normalized()
			look_ahead_vector = look_ahead_vector.move_toward(
				target_dir * look_ahead_distance, 
				look_ahead_speed * delta * 100.0
			)
		else:
			# Recenter when target stops
			look_ahead_vector = look_ahead_vector.move_toward(Vector2.ZERO, look_ahead_speed * delta * 150.0)
			
	# Smoothly interpolate position to target position + offsets
	var destination = target_pos + look_ahead_vector + target_offset
	global_position = global_position.lerp(destination, follow_speed * delta)

# Smoothly switch focus to a new target (e.g. boss spawn, lever reveal)
func switch_target(new_target: Node2D, temporary_offset: Vector2 = Vector2.ZERO, duration: float = 1.0) -> void:
	if not is_instance_valid(new_target):
		return
	
	current_target = new_target
	
	# Animate offset change using a Tween
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "target_offset", temporary_offset, duration)

# Return focus back to the default player target
func reset_to_default_target(duration: float = 1.0) -> void:
	switch_target(target, Vector2.ZERO, duration)

# Configure limits using Marker2D nodes placed in the map editor
func setup_limits() -> void:
	if limit_left_node:
		limit_left = limit_left_node.global_position.x as int
	if limit_right_node:
		limit_right = limit_right_node.global_position.x as int
	if limit_top_node:
		limit_top = limit_top_node.global_position.y as int
	if limit_bottom_node:
		limit_bottom = limit_bottom_node.global_position.y as int
