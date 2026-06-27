# ==============================================================================
# SINGLE SOURCE OF TRUTH: Wave & Object Spawner (Godot 4.x)
# ==============================================================================
extends Node2D

@export var spawn_scenes: Array[PackedScene] = []
@export var spawn_points: Array[Node2D] = []
@export var spawn_interval: float = 2.0
@export var max_active_spawns: int = 15

var active_spawns: Array[Node] = []
var timer: Timer

func _ready() -> void:
	# Set up spawning timer
	timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.autostart = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func _on_timer_timeout() -> void:
	# Clean up dead / deleted instances
	active_spawns = active_spawns.filter(func(node): return is_instance_valid(node))
	
	if active_spawns.size() >= max_active_spawns:
		return # Max limit reached
		
	if spawn_scenes.is_empty():
		return # No scenes to spawn
		
	spawn_object()

func spawn_object() -> void:
	# Choose random scene to spawn
	var scene_idx: int = randi() % spawn_scenes.size()
	var scene: PackedScene = spawn_scenes[scene_idx]
	if scene == null:
		return
		
	var instance: Node2D = scene.instantiate()
	
	# Determine spawn position
	var spawn_pos: Vector2 = global_position
	if !spawn_points.is_empty():
		var pt_idx: int = randi() % spawn_points.size()
		var pt: Node2D = spawn_points[pt_idx]
		if is_instance_valid(pt):
			spawn_pos = pt.global_position
			
	instance.global_position = spawn_pos
	
	# Add to main scene or level tree (not as a child of the spawner to avoid inherit movement)
	get_parent().add_child(instance)
	active_spawns.append(instance)
