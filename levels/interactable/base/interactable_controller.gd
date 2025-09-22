extends Node
class_name InteractableController

@export var interactable: InteractableBase
@export var area: Area3D
@export var animation: InteractableAnimation
@export var sound: AudioStreamPlayer3D

var entered_count: int


func _ready() -> void:
	area.body_entered.connect(body_entered)
	area.body_exited.connect(body_exited)


func body_entered(body: Node3D) -> void:
	if not body is Player: return
	
	if body.is_multiplayer_authority() or not Connection.is_peer_connected:
		interactable.entered()
	
	sound.play()
	
	if entered_count == 0:
		animation.play_activate()
	entered_count+=1


func body_exited(body: Node3D) -> void:
	if not body is Player: return
	
	if body.is_multiplayer_authority() or not Connection.is_peer_connected:
		interactable.exited()
	
	entered_count-=1
	if entered_count == 0:
		animation.play_deactivate()
