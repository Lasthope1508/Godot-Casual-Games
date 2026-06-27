# ==============================================================================
# SINGLE SOURCE OF TRUTH: 2D Motion Trail Renderer using Line2D (Godot 4.x)
# ==============================================================================
# Attach this script to a Line2D node, and set its target path to the node 
# you want to track (e.g. Projectile, Player).
# ==============================================================================
class_name Trail2D
extends Line2D

@export var target_path: NodePath
@export var max_points: int = 20
@export var min_distance: float = 5.0 # Min distance moved before adding a new point

var target: Node2D

func _ready() -> void:
	# Clear any editor design points
	clear_points()
	
	if target_path:
		target = get_node(target_path) as Node2D

func _process(_delta: float) -> void:
	if not is_instance_valid(target):
		# If target is destroyed, slowly fade and remove points
		if get_point_count() > 0:
			remove_point(0)
		else:
			set_process(false)
		return
		
	var target_pos = target.global_position
	
	# Only add point if target moved enough to prevent stack up
	if get_point_count() > 0:
		var last_pos = get_point_position(get_point_count() - 1)
		# Convert global position to local position of Line2D
		var local_target_pos = to_local(target_pos)
		
		if last_pos.distance_to(local_target_pos) > min_distance:
			add_point(local_target_pos)
	else:
		add_point(to_local(target_pos))
		
	# Cap the number of points
	if get_point_count() > max_points:
		remove_point(0)
