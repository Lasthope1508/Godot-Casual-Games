# ==============================================================================
# SINGLE SOURCE OF TRUTH: Grid Coordinator & Manager (Godot 4.x)
# ==============================================================================
extends Node
class_name GridManager

@export var grid_width: int = 8
@export var grid_height: int = 8
@export var cell_size: Vector2 = Vector2(64, 64)
@export var grid_offset: Vector2 = Vector2(32, 32) # Offset to center objects in cells

# 2D Grid Representation: grid_data[column][row]
var grid_data: Array = []

func _ready() -> void:
	initialize_grid()

func initialize_grid() -> void:
	grid_data.clear()
	for x in range(grid_width):
		var column: Array = []
		for y in range(grid_height):
			column.append(null) # Empty cell representation
		grid_data.append(column)

# Convert grid coordinates (col, row) to global pixel position
func grid_to_world(col: int, row: int) -> Vector2:
	return Vector2(
		col * cell_size.x + grid_offset.x,
		row * cell_size.y + grid_offset.y
	)

# Convert global pixel position to grid coordinates (col, row)
func world_to_grid(world_pos: Vector2) -> Vector2i:
	var col: int = floor((world_pos.x - grid_offset.x + cell_size.x / 2.0) / cell_size.x)
	var row: int = floor((world_pos.y - grid_offset.y + cell_size.y / 2.0) / cell_size.y)
	return Vector2i(
		clampi(col, 0, grid_width - 1),
		clampi(row, 0, grid_height - 1)
	)

# Check if index is within grid bounds
func is_in_bounds(col: int, row: int) -> bool:
	return col >= 0 and col < grid_width and row >= 0 and row < grid_height

# Set content at grid location
func set_cell(col: int, row: int, item: Node2D) -> void:
	if is_in_bounds(col, row):
		grid_data[col][row] = item

# Get content at grid location
func get_cell(col: int, row: int) -> Node2D:
	if is_in_bounds(col, row):
		return grid_data[col][row]
	return null

# Clear cell
func clear_cell(col: int, row: int) -> void:
	if is_in_bounds(col, row):
		grid_data[col][row] = null
