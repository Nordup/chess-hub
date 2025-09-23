extends Node3D
class_name FallChecker

@export var fall_height: float
@export var player_spawner: PlayerSpawner

var timer : Timer


func _ready() -> void:
	if Connection.is_server(): return
	
	timer = Timer.new()
	add_child(timer)
	timer.start(1)
	timer.timeout.connect(check_fallen)


func check_fallen() -> void:
	if player_spawner.local_player.global_position.y < fall_height:
		player_spawner.respawn_local_player()
