# ==============================================================================
# SINGLE SOURCE OF TRUTH: Editor Viewport Raycasting & Asset Placer (Godot 4.x)
# ==============================================================================
# To use this:
# 1. Place this script inside your addons/ directory (e.g. addons/my_addon/plugin.gd).
# 2. Register it in your plugin.cfg file.
# 3. Enable the plugin in Project Settings.
# ==============================================================================
@tool
extends EditorPlugin

# The scene package we want to place (configured in editor inspector)
@export var placement_scene: PackedScene

# Activate/Deactivate the tool inside editor
var active: bool = false
var ray_length: float = 1000.0

func _enter_tree() -> void:
	# Add any editor UI buttons or shortcuts here
	print("Asset Placer Plugin Enabled")

func _exit_tree() -> void:
	# Cleanup UI elements
	print("Asset Placer Plugin Disabled")

# Process GUI input events inside the 3D Editor Viewport
func _forward_3d_gui_input(viewport_camera: Camera3D, event: InputEvent) -> int:
	if not active or not placement_scene:
		return EditorPlugin.AFTER_GUI_INPUT_PASS # Let other inputs process
		
	# Check for mouse click event
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var hit_info = cast_ray_from_mouse(viewport_camera, event.position)
		if not hit_info.is_empty():
			place_asset(hit_info.position, hit_info.normal)
			return EditorPlugin.AFTER_GUI_INPUT_STOP # Block other clicks (consume event)
			
	return EditorPlugin.AFTER_GUI_INPUT_PASS

# Perform 3D raycast from mouse position into editor viewport
func cast_ray_from_mouse(camera: Camera3D, mouse_pos: Vector2) -> Dictionary:
	var space_state = camera.get_world_3d().direct_space_state
	if not space_state:
		return {}
		
	var origin = camera.project_ray_origin(mouse_pos)
	var normal = camera.project_ray_normal(mouse_pos)
	var target = origin + normal * ray_length
	
	var query = PhysicsRayQueryParameters3D.create(origin, target)
	# Query both colliders and editor grids if needed
	query.collide_with_areas = true
	query.collide_with_bodies = true
	
	var result = space_state.intersect_ray(query)
	return result # Returns Dictionary containing: position, normal, collider, etc.

# Instantiate and align the asset to the surface normal
func place_asset(pos: Vector3, normal: Vector3) -> void:
	var instance: Node3D = placement_scene.instantiate() as Node3D
	if not instance:
		return
		
	# Calculate basis for normal alignment
	var up = normal.normalized()
	var right = Vector3.UP.cross(up).normalized()
	if right.length_squared() < 0.001:
		right = Vector3.RIGHT.cross(up).normalized() # Fallback for vertical surfaces
	var forward = up.cross(right).normalized()
	
	var basis = Basis(right, up, forward)
	instance.global_transform = Transform3D(basis, pos)
	
	# Add to the current edited scene root in editor
	var scene_root = get_editor_interface().get_edited_scene_root()
	if scene_root:
		scene_root.add_child(instance)
		instance.owner = scene_root # Essential for editor saving
		
		# Register undo action
		var undo_redo = get_undo_redo()
		undo_redo.create_action("Place Asset")
		undo_redo.add_do_method(scene_root, "add_child", instance)
		undo_redo.add_do_reference(instance)
		undo_redo.add_undo_method(scene_root, "remove_child", instance)
		undo_redo.commit_action()
		
		print("Placed asset successfully at: ", pos)
