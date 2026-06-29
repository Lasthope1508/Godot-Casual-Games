extends Control

@onready var studio_name: Label = $MarginContainer/VBoxContainer/StudioName
@onready var presents_label: Label = $MarginContainer/VBoxContainer/PresentsLabel

func _ready() -> void:
	# Hide elements initially for fade-in animation
	studio_name.modulate.a = 0.0
	presents_label.modulate.a = 0.0
	
	# Play music if available
	if has_node("/root/AudioManager"):
		AudioManager.play_music()

	# Start splash animation sequence
	var tw = create_tween()
	tw.tween_property(studio_name, "modulate:a", 1.0, 1.2)
	tw.parallel().tween_property(presents_label, "modulate:a", 1.0, 1.2)
	tw.tween_interval(1.5)
	
	# Fade out whole screen
	tw.tween_property(self, "modulate:a", 0.0, 0.8)
	tw.tween_callback(func():
		if get_node_or_null("/root/SceneRouter"):
			# Go to MainMenu through Router to preserve dynamic transitions
			SceneRouter.change_scene("res://Scenes/Main/MainMenu.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/Main/MainMenu.tscn")
	)
