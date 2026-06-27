# ==============================================================================
# SINGLE SOURCE OF TRUTH: Self-Cleaning VFX & SFX Spawner (Godot 4.x)
# ==============================================================================
# Solves memory leaks by dynamically spawning effects and auto-freeing nodes
# when they complete their emission or audio playback.
# ==============================================================================
extends Node
class_name VFXSpawner

# Spawn a particle effect scene and auto-delete it when it finishes emitting
static func spawn_particles(particle_scene: PackedScene, parent: Node, global_pos: Vector2) -> Node2D:
	if particle_scene == null:
		return null
		
	var effect: Node2D = particle_scene.instantiate() as Node2D
	effect.global_position = global_pos
	parent.add_child(effect)
	
	# Connect to the finished signal to auto-cleanup
	if effect.has_signal("finished"):
		effect.connect("finished", func(): effect.queue_free())
	else:
		# Fallback: if it's CPUParticles2D or old format, use a timer
		var lifetime = effect.get("lifetime")
		if lifetime:
			var timer = parent.get_tree().create_timer(lifetime as float + 0.5)
			timer.timeout.connect(func(): effect.queue_free())
			
	# If particle node has GPUParticles2D/CPUParticles2D as child, trigger it
	var p2d = effect if (effect is GPUParticles2D or effect is CPUParticles2D) else effect.get_node_or_null("Particles")
	if p2d:
		p2d.set("emitting", true)
		
	return effect

# Spawn a sound effect and auto-delete it when the audio finishes playing
static func spawn_sfx(audio_stream: AudioStream, parent: Node, global_pos: Vector2, bus: StringName = &"SFX") -> AudioStreamPlayer2D:
	if audio_stream == null:
		return null
		
	var player = AudioStreamPlayer2D.new()
	player.stream = audio_stream
	player.global_position = global_pos
	player.bus = bus
	player.autoplay = true
	
	# Auto delete when sound ends
	player.finished.connect(func(): player.queue_free())
	
	parent.add_child(player)
	return player
