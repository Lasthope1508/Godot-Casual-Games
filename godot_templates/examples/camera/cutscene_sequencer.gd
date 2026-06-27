# ==============================================================================
# DETAILED PRODUCTION TEMPLATE: Cinematic Cutscene Sequencer (Godot 4.x)
# ==============================================================================
# An event-driven sequencer that plays a list of structured cinematic actions.
# Blocks player input on start and restores it on finish.
# ==============================================================================
class_name CutsceneSequencer
extends Node

signal cutscene_started
signal cutscene_finished

@export var camera: Camera2D # Or Camera3D
@export var dialogue_box: Panel # Simple placeholder dialogue panel

var action_queue: Array[Dictionary] = []
var is_playing: bool = false
var current_step_idx: int = -1

# Trigger a cutscene with a list of actions
# Example action format:
# [
#   {"type": "freeze_input", "target": player_node},
#   {"type": "pan_camera", "target_pos": Vector2(100, 200), "duration": 1.5},
#   {"type": "play_animation", "actor": enemy_node, "animation": "threaten"},
#   {"type": "dialogue", "text": "Who goes there?!"},
#   {"type": "wait", "duration": 1.0},
#   {"type": "reset_camera", "duration": 1.0},
#   {"type": "unfreeze_input", "target": player_node}
# ]
func play_sequence(actions: Array[Dictionary]) -> void:
	if is_playing:
		return
		
	action_queue = actions.duplicate()
	is_playing = true
	current_step_idx = -1
	cutscene_started.emit()
	
	next_step()

func next_step() -> void:
	current_step_idx += 1
	if current_step_idx >= action_queue.size():
		finish_cutscene()
		return
		
	var action: Dictionary = action_queue[current_step_idx]
	execute_action(action)

func execute_action(action: Dictionary) -> void:
	var type: String = action.get("type", "")
	
	match type:
		"freeze_input":
			var actor = action.get("target")
			if is_instance_valid(actor) and actor.has_method("set_physics_process"):
				actor.set_physics_process(false) # Disable movement
			next_step()
			
		"unfreeze_input":
			var actor = action.get("target")
			if is_instance_valid(actor) and actor.has_method("set_physics_process"):
				actor.set_physics_process(true) # Re-enable movement
			next_step()
			
		"pan_camera":
			if is_instance_valid(camera):
				var target_pos = action.get("target_pos", Vector2.ZERO)
				var duration = action.get("duration", 1.0)
				var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
				tween.tween_property(camera, "global_position", target_pos, duration)
				tween.finished.connect(next_step)
			else:
				next_step()
				
		"reset_camera":
			# If camera is CameraController2D, call reset
			if is_instance_valid(camera) and camera.has_method("reset_to_default_target"):
				var duration = action.get("duration", 1.0)
				camera.call("reset_to_default_target", duration)
				var timer = get_tree().create_timer(duration)
				timer.timeout.connect(next_step)
			else:
				next_step()
				
		"play_animation":
			var actor = action.get("actor")
			var anim_name = action.get("animation", "")
			if is_instance_valid(actor):
				var anim_player = actor.get_node_or_null("AnimationPlayer") as AnimationPlayer
				if anim_player:
					anim_player.play(anim_name)
					# Wait until animation ends to advance
					if not anim_player.animation_finished.is_connected(self._on_animation_finished):
						anim_player.animation_finished.connect(self._on_animation_finished, CONNECT_ONE_SHOT)
					return
			next_step()
			
		"dialogue":
			var text = action.get("text", "")
			if is_instance_valid(dialogue_box):
				dialogue_box.show()
				var label = dialogue_box.get_node_or_null("Label")
				if label:
					label.set("text", text)
				# Let the dialogue wait for a mouse click to advance
				# (Alternatively, use a timer)
				return
			next_step()
			
		"wait":
			var duration = action.get("duration", 1.0)
			var timer = get_tree().create_timer(duration)
			timer.timeout.connect(next_step)
			
		_:
			next_step()

func _on_animation_finished(_anim_name: StringName) -> void:
	next_step()

# Dialogue box click handler (advance dialogue on click)
func _gui_input(event: InputEvent) -> void:
	if is_playing and dialogue_box and dialogue_box.visible:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			dialogue_box.hide()
			next_step()

func finish_cutscene() -> void:
	is_playing = false
	cutscene_finished.emit()
	print("Cutscene finished successfully!")
