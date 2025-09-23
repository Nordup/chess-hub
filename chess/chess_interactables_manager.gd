extends Node3D

@export var chess_player: ChessPlayer

@export var interactable_play_white: InteractablePlayStopChess
@export var interactable_play_black: InteractablePlayStopChess
@export var interactable_stop_white: InteractablePlayStopChess
@export var interactable_stop_black: InteractablePlayStopChess

# Player ID of the playing side
var playing_white: int = -1
var playing_black: int = -1


func _ready() -> void:
	interactable_play_white.interact_with_chess.connect(play_chess.bind(ChessPlayer.Side.WHITE))
	interactable_play_black.interact_with_chess.connect(play_chess.bind(ChessPlayer.Side.BLACK))
	interactable_stop_white.interact_with_chess.connect(stop_chess.bind(ChessPlayer.Side.WHITE))
	interactable_stop_black.interact_with_chess.connect(stop_chess.bind(ChessPlayer.Side.BLACK))
	
	# Sync initial UI state
	_update_ui()
	
	# Ask server for current state or listen for disconnections on server
	if Connection.is_server():
		multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	else:
		multiplayer.connected_to_server.connect(func(): request_state.rpc_id(1))


func play_chess(side: ChessPlayer.Side) -> void:
	# Request server to start playing this side; server will broadcast state
	request_play.rpc_id(1, side)


func stop_chess(side: ChessPlayer.Side) -> void:
	# Request server to stop this side; server will broadcast state
	request_stop.rpc_id(1, side)


@rpc("any_peer", "call_remote", "reliable")
func request_state() -> void:
	# Runs on server; reply with current state to the requester
	if not Connection.is_server(): return
	apply_state.rpc_id(multiplayer.get_remote_sender_id(), playing_white, playing_black)


@rpc("any_peer", "call_remote", "reliable")
func request_play(side: ChessPlayer.Side) -> void:
	# Runs on server; assign side if free and broadcast
	if not Connection.is_server(): return
	var peer_id: int = multiplayer.get_remote_sender_id()
	if side == ChessPlayer.Side.WHITE:
		if playing_white == -1:
			playing_white = peer_id
	else:
		if playing_black == -1:
			playing_black = peer_id
	apply_state.rpc(playing_white, playing_black)


@rpc("any_peer", "call_remote", "reliable")
func request_stop(side: ChessPlayer.Side) -> void:
	# Runs on server; only the owner of the side can stop
	if not Connection.is_server(): return
	var peer_id: int = multiplayer.get_remote_sender_id()
	if side == ChessPlayer.Side.WHITE:
		if playing_white == peer_id:
			playing_white = -1
	else:
		if playing_black == peer_id:
			playing_black = -1
	apply_state.rpc(playing_white, playing_black)


@rpc("authority", "call_local", "reliable")
func apply_state(_playing_white: int, _playing_black: int) -> void:
	# Runs on all peers (and server) to reflect the current state
	playing_white = _playing_white
	playing_black = _playing_black
	_update_ui()
	_apply_local_play_state()


func _update_ui() -> void:
	# Per-side logic:
	# - If side is free: enable Play, disable Stop
	# - If I'm playing this side: disable Play, enable Stop
	# - If someone else is playing: disable both
	var my_id: int = multiplayer.get_unique_id()
	# White
	if playing_white == -1:
		interactable_play_white.set_enabled(true)
		interactable_stop_white.set_enabled(false)
	elif playing_white == my_id:
		interactable_play_white.set_enabled(false)
		interactable_stop_white.set_enabled(true)
	else:
		interactable_play_white.set_enabled(false)
		interactable_stop_white.set_enabled(false)
	# Black
	if playing_black == -1:
		interactable_play_black.set_enabled(true)
		interactable_stop_black.set_enabled(false)
	elif playing_black == my_id:
		interactable_play_black.set_enabled(false)
		interactable_stop_black.set_enabled(true)
	else:
		interactable_play_black.set_enabled(false)
		interactable_stop_black.set_enabled(false)


func _apply_local_play_state() -> void:
	# Switch local player's chess mode depending on ownership
	if chess_player == null: return
	
	var my_id: int = multiplayer.get_unique_id()
	if my_id == playing_white:
		chess_player.play_chess(ChessPlayer.Side.WHITE)
	elif my_id == playing_black:
		chess_player.play_chess(ChessPlayer.Side.BLACK)
	else:
		chess_player.stop_chess()


func _on_peer_disconnected(id: int) -> void:
	# Server: if the playing peer disconnects, stop chess for everyone
	if not Connection.is_server(): return
	
	if id == playing_white:
		playing_white = -1
	elif id == playing_black:
		playing_black = -1
	else:
		return
	
	apply_state.rpc(playing_white, playing_black)
