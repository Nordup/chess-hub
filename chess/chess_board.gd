extends Node3D
class_name ChessBoard

@export var grid_map: GridMap

var mesh_library: MeshLibrary


func _ready() -> void:
	mesh_library = grid_map.mesh_library


func get_cell(world_pos: Vector3) -> Vector3i:
	var local_pos: Vector3 = grid_map.to_local(world_pos)
	return grid_map.local_to_map(local_pos)


func has_item(cell: Vector3i) -> bool:
	return get_item(cell) != GridMap.INVALID_CELL_ITEM


func get_item(cell: Vector3i) -> int:
	return grid_map.get_cell_item(cell)


func get_item_name(cell: Vector3i) -> String:
	return mesh_library.get_item_name(get_item(cell))


func get_info(cell: Vector3i) -> Array[String]:
	return [str(cell), str(get_item(cell)), get_item_name(cell)]


func move_item(from_cell: Vector3i, to_cell: Vector3i) -> void:
	grid_map.set_cell_item(to_cell, get_item(from_cell))
	grid_map.set_cell_item(from_cell, GridMap.INVALID_CELL_ITEM)
