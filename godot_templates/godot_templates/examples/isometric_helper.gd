# ==============================================================================
# SINGLE SOURCE OF TRUTH: Isometric Coordinate Helper & Pathfinding (Godot 4.x)
# ==============================================================================
# This script handles math conversion for 2.5D Isometric grids (2:1 ratio).
# It also helps configure AStar2D pathfinding for diagonal grids.
# ==============================================================================
class_name IsometricHelper
extends RefCounted

# Convert Isometric Grid cell coordinates (col, row) to world pixel position (Vector2)
# tile_width and tile_height represent the size of the isometric diamond (e.g. 64x32)
static func grid_to_world(col: float, row: float, tile_width: float = 64.0, tile_height: float = 32.0) -> Vector2:
	return Vector2(
		(col - row) * (tile_width / 2.0),
		(col + row) * (tile_height / 2.0)
	)

# Convert World pixel position (Vector2) back to Isometric Grid cell coordinates (Vector2i)
static func world_to_grid(world_pos: Vector2, tile_width: float = 64.0, tile_height: float = 32.0) -> Vector2i:
	var col: float = (world_pos.x / (tile_width / 2.0) + world_pos.y / (tile_height / 2.0)) / 2.0
	var row: float = (world_pos.y / (tile_height / 2.0) - world_pos.x / (tile_width / 2.0)) / 2.0
	return Vector2i(
		floor(col) as int,
		floor(row) as int
	)

# Set up an AStar2D grid representing an Isometric map, linking cells diagonally
# map_size: Vector2i(cols, rows)
# obstacle_cells: Array[Vector2i] of cells that cannot be walked on
static func setup_isometric_astar(map_size: Vector2i, obstacle_cells: Array[Vector2i] = [], tile_width: float = 64.0, tile_height: float = 32.0) -> AStar2D:
	var astar = AStar2D.new()
	
	# 1. Add all points to AStar
	for x in range(map_size.x):
		for y in range(map_size.y):
			var cell = Vector2i(x, y)
			if cell in obstacle_cells:
				continue
				
			var point_id = cell_to_id(cell, map_size.x)
			var world_pos = grid_to_world(x, y, tile_width, tile_height)
			astar.add_point(point_id, world_pos)
			
	# 2. Connect neighboring cells (4-way isometric movement)
	# Isometric neighbors are: (x+1, y), (x-1, y), (x, y+1), (x, y-1)
	var directions = [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]
	
	for x in range(map_size.x):
		for y in range(map_size.y):
			var cell = Vector2i(x, y)
			if cell in obstacle_cells:
				continue
				
			var point_id = cell_to_id(cell, map_size.x)
			
			for dir in directions:
				var neighbor = cell + dir
				if neighbor.x >= 0 and neighbor.x < map_size.x and neighbor.y >= 0 and neighbor.y < map_size.y:
					if neighbor not in obstacle_cells:
						var neighbor_id = cell_to_id(neighbor, map_size.x)
						astar.connect_points(point_id, neighbor_id)
						
	return astar

# Generate a unique point ID for AStar2D from grid coordinates
static func cell_to_id(cell: Vector2i, map_width: int) -> int:
	return cell.x + cell.y * map_width

# Convert ID back to grid coordinate
static func id_to_cell(point_id: int, map_width: int) -> Vector2i:
	return Vector2i(point_id % map_width, point_id / map_width)
