extends Node3D
class_name InteractableBase

@export var text: String
@export var events: InteractableEvents


# Called from Controller
func entered() -> void:
	events.on_entered_emit(text, self)


# Called from Controller
func exited() -> void:
	events.on_exited_emit(self)


# Override this. Called from InteractableInputHandler
func interact() -> void:
	pass
