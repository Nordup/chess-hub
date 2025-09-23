extends Node3D

@export var chess_player: ChessPlayer

@export var interactable_play_white: InteractablePlayStopChess
@export var interactable_play_black: InteractablePlayStopChess
@export var interactable_stop_white: InteractablePlayStopChess
@export var interactable_stop_black: InteractablePlayStopChess


func _ready() -> void:
	interactable_play_white.interact_with_chess.connect(play_chess.bind(ChessPlayer.Side.WHITE))
	interactable_play_black.interact_with_chess.connect(play_chess.bind(ChessPlayer.Side.BLACK))
	interactable_stop_white.interact_with_chess.connect(stop_chess.bind(ChessPlayer.Side.WHITE))
	interactable_stop_black.interact_with_chess.connect(stop_chess.bind(ChessPlayer.Side.BLACK))
	
	stop_chess(ChessPlayer.Side.WHITE)
	stop_chess(ChessPlayer.Side.BLACK)


func play_chess(side: ChessPlayer.Side) -> void:
	chess_player.play_chess(side)
	
	if side == ChessPlayer.Side.WHITE:
		interactable_play_white.set_enabled(false)
		interactable_stop_white.set_enabled(true)
	else:
		interactable_play_black.set_enabled(false)
		interactable_stop_black.set_enabled(true)


func stop_chess(side: ChessPlayer.Side) -> void:
	chess_player.stop_chess()
	
	if side == ChessPlayer.Side.WHITE:
		interactable_play_white.set_enabled(true)
		interactable_stop_white.set_enabled(false)
	else:
		interactable_play_black.set_enabled(true)
		interactable_stop_black.set_enabled(false)
