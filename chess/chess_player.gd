extends Node3D
class_name ChessPlayer
# Local player that manipulates the chess board

static var is_playing: bool

signal stopped_chess()

enum Side {
	WHITE,
	BLACK
}

@export var chess_board: ChessBoard
@export var camera_white: Camera3D
@export var camera_black: Camera3D

var previous_camera: Camera3D
var camera: Camera3D
var side: ChessPlayer.Side = ChessPlayer.Side.WHITE


func play_chess(_side: ChessPlayer.Side) -> void:
	is_playing = true
	side = _side
	
	previous_camera = get_viewport().get_camera_3d()
	camera = camera_white if side == ChessPlayer.Side.WHITE else camera_black
	camera.make_current()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	EditMode.set_show_mouse(true)

	print("Playing chess on side: ", side)


func stop_chess() -> void:
	is_playing = false
	previous_camera.make_current()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	EditMode.set_show_mouse(false)
	
	stopped_chess.emit()
	print("Stopped chess")
