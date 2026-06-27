# ==============================================================================
# DETAILED PRODUCTION TEMPLATE: Isometric 2.5D Camera Controller (Godot 4.x)
# ==============================================================================
# Features:
# - Isometric panning: Moves along diagonal grid axes instead of straight flat X/Y.
# - Smooth zoom: Keeps center focus and applies zoom limits.
# - Target tracking: Follows isometric actors smoothly.
# ==============================================================================
class_name CameraIsometric25D
extends Camera2D

@export var target: Node2D
@export var follow_speed: float = 4.0

# Isometric Axis Projections (assuming standard 64x32 tile proportions)
@export var tile_width: float = 64.0
@export var tile_height: float = 32.0

# Panning Settings
@export var pan_speed: float = 400.0
@export var drag_pan_sensitivity: float = 1.0

# Zoom Settings
@export var zoom_speed: float = 5.0
@export var min_zoom: float = 0.5
@export var max_zoom: float = 2.5

var target_zoom: float = 1.0
var is_dragging: bool = false
var last_mouse_pos: Vector2

func _ready() -> void:
	target_zoom = zoom.x

func _process(delta: float) -> void:
	# 1. Smoothly interpolate Zoom
	zoom.x = move_toward(zoom.x, target_zoom, zoom_speed * delta)
	zoom.y = zoom.x
	
	# 2. Smoothly follow target if not dragging/panning
	if not is_dragging and is_instance_valid(target):
		global_position = global_position.lerp(target.global_position, follow_speed * delta)
		
	# 3. Handle Keyboard Panning (aligned to isometric axes)
	handle_keyboard_panning(delta)

func _unhandled_input(event: InputEvent) -> void:
	# Mouse Wheel Zoom
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			target_zoom = clamp(target_zoom + 0.1, min_zoom, max_zoom)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			target_zoom = clamp(target_zoom - 0.1, min_zoom, max_zoom)
			
		# Right Click Drag to Pan
		if event.button_index == MOUSE_BUTTON_RIGHT:
			is_dragging = event.pressed
			last_mouse_pos = event.position
			
	elif event is InputEventMouseMotion and is_dragging:
		var delta_pos = (event.position - last_mouse_pos) * drag_pan_sensitivity / zoom.x
		# Subtract delta to pan camera in opposite direction of mouse movement
		global_position -= delta_pos
		last_mouse_pos = event.position

# Panning camera along isometric axes:
# Up (W/Up Arrow) -> Moves along Isometric -Y & -X axis (Screen UP)
# Left (A/Left Arrow) -> Moves along screen Left, which is (-X, +Y) isometric vector
func handle_keyboard_panning(delta: float) -> void:
	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if input_dir != Vector2.ZERO:
		# Project orthogonal input direction to screen coordinates
		# Then scale it to make moving feel consistent
		var iso_movement = Vector2(
			(input_dir.x - input_dir.y) * (tile_width / 2.0),
			(input_dir.x + input_dir.y) * (tile_height / 2.0)
		).normalized()
		
		global_position += iso_movement * pan_speed * delta
		# De-target player to allow free panning
		if is_instance_valid(target) and target:
			target = null
