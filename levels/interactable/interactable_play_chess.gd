extends InteractableBase

signal play_chess

@export var chess_player: ChessPlayer
@export var area: Area3D
@export var side: ChessPlayer.Side = ChessPlayer.Side.WHITE


func interact() -> void:
	chess_player.play_chess(side)
	monitoring_enabled(false)
	play_chess.emit()


func monitoring_enabled(enabled: bool) -> void:
	area.monitoring = enabled
