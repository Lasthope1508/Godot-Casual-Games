# ==============================================================================
# SINGLE SOURCE OF TRUTH: Path2D Follower Movement (Godot 4.x - PathFollow2D)
# ==============================================================================
# Usage:
# 1. Instantiate this node as a child of a Path2D node.
# 2. Add your sprite / visual elements as children of this PathFollow2D.
# ==============================================================================
extends PathFollow2D

@export var speed: float = 150.0
@export var loop: bool = false

signal reached_end

func _ready() -> void:
	# Configure path follow behaviors
	loop = loop
	progress = 0.0

func _physics_process(delta: float) -> void:
	# Move forward along the curve
	progress += speed * delta
	
	# Check if we have reached the end of the path
	if progress_ratio >= 1.0:
		reached_end.emit()
		if loop:
			progress = 0.0
		else:
			# Stop processing or delete parent wave unit
			set_physics_process(false)
			queue_free()
