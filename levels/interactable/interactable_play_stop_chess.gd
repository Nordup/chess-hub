extends InteractableBase
class_name InteractablePlayStopChess

signal interact_with_chess

@export var area: Area3D
@export var mesh: MeshInstance3D
@export var hide_mesh: bool


func _ready() -> void:
	if hide_mesh:
		mesh.visible = false


func interact() -> void:
	interact_with_chess.emit()


func set_enabled(enabled: bool) -> void:
	visible = enabled
	area.monitoring = enabled
