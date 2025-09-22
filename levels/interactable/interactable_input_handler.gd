extends Node
class_name InteractableInputHandler

@export var events: InteractableEvents

var current: InteractableBase
var blocked: InteractableBase


func _ready() -> void:
	events.on_entered.connect(on_interactable_entered)
	events.on_exited.connect(on_interactable_exited)
	events.on_blocked.connect(on_interactable_blocked)
	events.on_unblocked.connect(on_interactable_unblocked)


func on_interactable_entered(_text: String, interactable: InteractableBase) -> void:
	current = interactable


func on_interactable_exited(interactable: InteractableBase) -> void:
	if interactable != current: return
	current = null


func on_interactable_blocked(interactable: InteractableBase) -> void:
	blocked = interactable


func on_interactable_unblocked(interactable: InteractableBase) -> void:
	if interactable != blocked: return
	blocked = null


func _input(event: InputEvent) -> void:
	if not is_instance_valid(current): return
	if EditMode.is_enabled: return
	if current == blocked: return
	
	if event.is_action_pressed("interact"):
		print("pressed interact " + current.name)
		current.interact()
