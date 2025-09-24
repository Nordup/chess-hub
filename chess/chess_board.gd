extends Node3D
class_name ChessBoard

const BOARD_XZ_MIN: int = -6
const BOARD_XZ_MAX: int = 5
const BOARD_Y: int = 0

@export var grid_map: GridMap

@onready var mesh_library: MeshLibrary = grid_map.mesh_library

## Keep on server to sync board
var used_cells: Dictionary = {} # {Item ID: Array[Vector3i]}


func _ready() -> void:
	if Connection.is_server():
		for item in mesh_library.get_item_list():
			used_cells[item] = grid_map.get_used_cells_by_item(item)
	else:
		multiplayer.connected_to_server.connect(func(): request_board.rpc_id(1))


func get_cell(world_pos: Vector3) -> Vector3i:
	var local_pos: Vector3 = grid_map.to_local(world_pos)
	var map_pos: Vector3i = grid_map.local_to_map(local_pos)
	return Vector3i.MIN if is_out_of_bounds(map_pos) else map_pos


func is_out_of_bounds(map_pos: Vector3i) -> bool:
	return map_pos.x < BOARD_XZ_MIN or map_pos.x > BOARD_XZ_MAX or map_pos.z < BOARD_XZ_MIN or map_pos.z > BOARD_XZ_MAX or map_pos.y != BOARD_Y


func has_item(cell: Vector3i) -> bool:
	return get_item(cell) != GridMap.INVALID_CELL_ITEM


func get_item(cell: Vector3i) -> int:
	return grid_map.get_cell_item(cell)


func get_item_name(cell: Vector3i) -> String:
	return mesh_library.get_item_name(get_item(cell))


func get_info(cell: Vector3i) -> Array[String]:
	return [str(cell), str(get_item(cell)), get_item_name(cell)]


func move_item(from_cell: Vector3i, to_cell: Vector3i) -> void:
	rpc("move_item_on_all_peers", from_cell, to_cell)


@rpc("any_peer", "call_remote", "reliable")
func request_board() -> void:
	print("request_board: ", used_cells)
	setup_board.rpc_id(multiplayer.get_remote_sender_id(), used_cells)


@rpc("authority", "call_remote", "reliable")
func setup_board(_used_cells: Dictionary) -> void:
	print("setup_board: ", _used_cells)
	used_cells = _used_cells
	grid_map.clear()
	for item in used_cells:
		var cells = used_cells[item]
		for cell in cells:
			grid_map.set_cell_item(cell, item)


@rpc("any_peer", "call_local", "reliable")
func move_item_on_all_peers(from_cell: Vector3i, to_cell: Vector3i) -> void:
	var item = get_item(from_cell)
	grid_map.set_cell_item(to_cell, item)
	grid_map.set_cell_item(from_cell, GridMap.INVALID_CELL_ITEM)
	
	if Connection.is_server():
		used_cells[item].erase(from_cell)
		used_cells[item].append(to_cell)
