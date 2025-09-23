extends InteractableBase

signal stop_chess

@export var chess_player: ChessPlayer
@export var area: Area3D


func interact() -> void:
	chess_player.stop_chess()
	monitoring_enabled(false)
	stop_chess.emit()


func monitoring_enabled(enabled: bool) -> void:
	area.monitoring = enabled
