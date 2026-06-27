# ==============================================================================
# DETAILED PRODUCTION TEMPLATE: Advanced 3D Camera Controller (Godot 4.x)
# ==============================================================================
# Supports:
# 1. Third Person Orbit (via SpringArm3D for mouse orbit)
# 2. First Person Look (mouse input looking around)
# 3. Cinematic Dolly Track (moving along a path while keeping target focused)
# ==============================================================================
class_name CameraController3D
extends Node3D

enum CameraMode {
	THIRD_PERSON_ORBIT,
	FIRST_PERSON,
	CINEMATIC_DOLLY
}

@export var mode: CameraMode = CameraMode.THIRD_PERSON_ORBIT
@export var target: Node3D

# Mouse Sensitivity
@export var mouse_sensitivity: float = 0.002
@export var pitch_min: float = -75.0 # Degrees
@export var pitch_max: float = 75.0  # Degrees

# 1. Orbit Settings
@export var spring_arm: SpringArm3D

# 3. Dolly Settings (Path3D for cinematic rails)
@export var dolly_path: Path3D
@export var dolly_speed: float = 0.05

var camera: Camera3D
var yaw: float = 0.0
var pitch: float = 0.0
var dolly_progress: float = 0.0

func _ready() -> void:
	camera = get_viewport().get_camera_3d()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if spring_arm:
		yaw = spring_arm.rotation.y
		pitch = spring_arm.rotation.x

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# Calculate mouse rotation delta
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(pitch_min), deg_to_rad(pitch_max))
		
		match mode:
			CameraMode.THIRD_PERSON_ORBIT:
				if spring_arm:
					spring_arm.rotation.y = yaw
					spring_arm.rotation.x = pitch
			CameraMode.FIRST_PERSON:
				# Apply rotation directly to camera/player
				rotation.y = yaw
				if camera:
					camera.rotation.x = pitch

func _physics_process(delta: float) -> void:
	match mode:
		CameraMode.THIRD_PERSON_ORBIT:
			# Target follow is handled natively by SpringArm3D hierarchy
			pass
		CameraMode.FIRST_PERSON:
			# Stick directly to player head position
			if is_instance_valid(target):
				global_position = target.global_position + Vector3(0.0, 1.6, 0.0) # Eye level
		CameraMode.CINEMATIC_DOLLY:
			# Move camera along Path3D while looking at target
			if dolly_path and is_instance_valid(target) and camera:
				dolly_progress += dolly_speed * delta
				# Loop or clamp path progress
				var curve = dolly_path.curve
				var pos = curve.sample_baked(dolly_progress * curve.get_baked_length())
				
				# Convert to world coordinates
				camera.global_position = dolly_path.to_global(pos)
				camera.look_at(target.global_position)
