extends Resource
class_name InteractableEvents

signal on_entered(text: String, interactable: InteractableBase)
signal on_exited(interactable: InteractableBase)
signal on_blocked(interactable: InteractableBase)
signal on_unblocked(interactable: InteractableBase)


func on_entered_emit(text: String, interactable: InteractableBase) -> void:
	on_entered.emit(text, interactable)


func on_exited_emit(interactable: InteractableBase) -> void:
	on_exited.emit(interactable)


func on_blocked_emit(interactable: InteractableBase) -> void:
	on_blocked.emit(interactable)


func on_unblocked_emit(interactable: InteractableBase) -> void:
	on_unblocked.emit(interactable)
