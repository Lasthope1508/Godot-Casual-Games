# ==============================================================================
# SINGLE SOURCE OF TRUTH: Top-Down 8-Way Movement (Godot 4.x - CharacterBody2D)
# ==============================================================================
extends CharacterBody2D

@export var max_speed: float = 300.0
@export var acceleration: float = 1800.0
@export var friction: float = 2000.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
	# Get input direction vector
	var input_vector: Vector2 = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()

	# Apply movement physics
	if input_vector != Vector2.ZERO:
		# Accelerate
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
		update_animations(input_vector)
	else:
		# Decelerate / Friction
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		update_animations(Vector2.ZERO)

	move_and_slide()

func update_animations(dir: Vector2) -> void:
	if anim_player == null:
		# Fallback to simple sprite flipping
		if dir.x != 0:
			sprite.flip_h = dir.x < 0
		return

	if dir != Vector2.ZERO:
		anim_player.play("walk")
		# Flip sprite depending on horizontal movement
		if dir.x != 0:
			sprite.flip_h = dir.x < 0
	else:
		anim_player.play("idle")
