# ==============================================================================
# SINGLE SOURCE OF TRUTH: Camera2D Screen Shake using Noise (Godot 4.x)
# ==============================================================================
# Usage:
# 1. Attach this script to your Camera2D node.
# 2. Call `Camera.shake(amplitude, duration, frequency)` to trigger a shake.
# ==============================================================================
extends Camera2D

@export var decay: float = 0.8  # How quickly the shaking stops [0, 1]
@export var max_offset: Vector2 = Vector2(100, 75)  # Maximum shake displacement
@export var max_roll: float = 0.1  # Maximum rotation angle

var shake_strength: float = 0.0  # Current shake strength
var shake_power: float = 2.0  # Formula exponent (makes decay look natural)

var noise: FastNoiseLite
var noise_y: float = 0.0

func _ready() -> void:
	randomize()
	noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	# Frequency determines how fast the shake fluctuates
	noise.frequency = 0.5 

func _process(delta: float) -> void:
	if shake_strength > 0:
		# Decay shake strength over time
		shake_strength = max(shake_strength - decay * delta, 0)
		apply_shake()
	else:
		# Reset camera back to center
		offset = Vector2.ZERO
		rotation = 0.0

# Call this from other scripts to trigger screen shake (e.g. on explosions/hits)
func shake(strength: float = 1.0, custom_decay: float = 0.8) -> void:
	shake_strength = clamp(strength, 0.0, 1.0)
	decay = custom_decay
	noise_y += 1.0 # Offset noise coordinate for unique shake pattern each time

func apply_shake() -> void:
	var amount: float = pow(shake_strength, shake_power)
	noise_y += 0.1
	
	# Generate 1D/2D noise offsets
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed * 2, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed * 3, noise_y)
