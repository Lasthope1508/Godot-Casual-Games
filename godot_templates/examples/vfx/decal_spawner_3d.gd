# ==============================================================================
# SINGLE SOURCE OF TRUTH: 3D Decal / Bullet Hole Spawner (Godot 4.x)
# ==============================================================================
# Instantiates a Decal node at a hit position, aligns its projection axis 
# to the surface normal, and fades it out over time.
# ==============================================================================
class_name DecalSpawner3D
extends RefCounted

# Spawn a Decal in the 3D world
# parent: Node to add the Decal to (usually level root)
# texture: Texture2D for the decal image
# position: Vector3 hit position
# normal: Vector3 hit surface normal
# size: Vector3 size bounds of the decal box
# lifetime: how long before the decal starts to fade
# fade_duration: how long the fade-out takes
static func spawn(
	parent: Node, 
	texture: Texture2D, 
	position: Vector3, 
	normal: Vector3, 
	size: Vector3 = Vector3(0.2, 0.2, 0.2), 
	lifetime: float = 10.0, 
	fade_duration: float = 2.0
) -> Decal:
	if texture == null:
		return null
		
	var decal = Decal.new()
	decal.texture_albedo = texture
	decal.size = size
	
	# Set position
	decal.global_position = position
	
	# Align decal's projection axis (-Y in Godot 4 Decals) to the surface normal
	var up = normal.normalized()
	# Decal projection is along -Y, so we align Y axis to normal
	var right = Vector3.UP.cross(up).normalized()
	if right.length_squared() < 0.001:
		right = Vector3.RIGHT.cross(up).normalized()
	var forward = up.cross(right).normalized()
	
	decal.global_transform.basis = Basis(right, up, forward)
	
	# Add to scene
	parent.add_child(decal)
	
	# Set up fade out timer
	var timer = parent.get_tree().create_timer(lifetime)
	timer.timeout.connect(func():
		var tween = decal.create_tween()
		# Fade albedo tint alpha to 0
		tween.tween_property(decal, "albedo_mix", 0.0, fade_duration)
		tween.tween_callback(decal.queue_free)
	)
	
	return decal
