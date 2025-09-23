extends Node3D
class_name ChessPlayer

# Local player that manipulates the chess board

static var is_playing: bool

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
var selected_cell: Vector3i
var selected_item: int = -1


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
	if not is_playing:
		return
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var pick: Variant = chess_board.pick_cell_from_mouse(camera)
		if pick == null:
			selected_item = -1
			return
		
		selected_cell = pick["cell"]
		selected_item = pick["item"]
		# Only consider valid items (>= 0) as figures present on the grid
		if selected_item < 0:
			return
		
		# Optional: you could emit a signal or call a method to highlight/select
		# For now we just store the selection
