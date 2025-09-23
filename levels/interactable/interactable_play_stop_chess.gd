extends InteractableBase
class_name InteractablePlayStopChess

signal interact_with_chess

@export var area: Area3D


func interact() -> void:
	interact_with_chess.emit()


func set_enabled(enabled: bool) -> void:
	visible = enabled
	area.monitoring = enabled
