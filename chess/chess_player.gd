extends Node3D
class_name ChessPlayer

# Local player that manipulates the chess board

static var is_playing: bool

enum Side {
	WHITE,
	BLACK
}

@export var chess_board: ChessBoard
@export var camera_white: ChessCamera
@export var camera_black: ChessCamera

var side: ChessPlayer.Side = ChessPlayer.Side.WHITE
var camera: ChessCamera
var previous_camera: Camera3D

var figure_cell: Vector3i = Vector3i.MIN


func play_chess(_side: ChessPlayer.Side) -> void:
	is_playing = true
	side = _side
	
	previous_camera = get_viewport().get_camera_3d()
	camera = camera_white if side == ChessPlayer.Side.WHITE else camera_black
	camera.make_current()
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	EditMode.set_show_mouse(true)


func stop_chess() -> void:
	is_playing = false
	previous_camera.make_current()
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	EditMode.set_show_mouse(false)


func _unhandled_input(event: InputEvent) -> void:
	if not is_playing: return
	if event is not InputEventMouseButton or not event.pressed: return
	
	if event.button_index == MOUSE_BUTTON_LEFT:
		if figure_cell == Vector3i.MIN:
			pick_figure()
		else:
			move_figure()
	elif event.button_index == MOUSE_BUTTON_RIGHT:
		drop_figure()


func pick_figure() -> void:
	var world_pos: Vector3 = camera.get_position_under_mouse()
	if world_pos == Vector3.INF: return
	
	var cell: Vector3i = chess_board.get_cell(world_pos)
	if not chess_board.has_item(cell): return
	
	figure_cell = cell
	print("pick figure: ", chess_board.get_info(cell))


func move_figure() -> void:
	if figure_cell == Vector3i.MIN: return
	
	var world_pos: Vector3 = camera.get_position_under_mouse()
	if world_pos == Vector3.INF: return
	
	var cell: Vector3i = chess_board.get_cell(world_pos)
	if chess_board.has_item(cell): return
	
	print("move figure: ", chess_board.get_info(figure_cell), " to ", cell)
	chess_board.move_item(figure_cell, cell)
	figure_cell = Vector3i.MIN


func drop_figure() -> void:
	if figure_cell == Vector3i.MIN: return
	
	print("drop figure: ", chess_board.get_info(figure_cell))
	figure_cell = Vector3i.MIN
