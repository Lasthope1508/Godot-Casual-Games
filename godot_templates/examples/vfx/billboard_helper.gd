# ==============================================================================
# SINGLE SOURCE OF TRUTH: 2.5D / Fake 3D Camera Billboard Helper (Godot 4.x)
# ==============================================================================
# Attach this script to any Node3D (e.g. Sprite3D or custom 2D-in-3D element)
# to force it to dynamically face the active 3D camera.
# ==============================================================================
class_name BillboardHelper
extends Node3D

enum BillboardMode {
	CYLINDRICAL, # Rotate around Y-axis only (standard for 2.5D characters standing on ground)
	SPHERICAL    # Rotate on all axes to face camera directly (standard for particles/explosions)
}

@export var mode: BillboardMode = BillboardMode.CYLINDRICAL
@export var active: bool = true

func _process(_delta: float) -> void:
	if not active:
		return
		
	var camera = get_viewport().get_camera_3d()
	if not camera:
		return
		
	align_to_camera(camera)

func align_to_camera(camera: Camera3D) -> void:
	var camera_pos = camera.global_position
	var target_pos = global_position
	
	match mode:
		BillboardMode.CYLINDRICAL:
			# Look at camera but preserve vertical axis (ignore Y difference)
			camera_pos.y = target_pos.y
			if camera_pos.is_equal_approx(target_pos):
				return
			look_at(camera_pos, Vector3.UP)
			# Rotate 180 degrees because look_at looks forward (-Z) but sprites face backwards (+Z)
			rotate_y(PI)
			
		BillboardMode.SPHERICAL:
			# Fully look at the camera
			if camera_pos.is_equal_approx(target_pos):
				return
			look_at(camera_pos, Vector3.UP)
			rotate_object_local(Vector3.UP, PI)
