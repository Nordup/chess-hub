extends Camera3D
class_name ChessCamera

const MAX_DISTANCE: float = 10.0

# get_mouse_position() is incorrect in TheGates
var last_mouse_position: Vector2


func get_position_under_mouse() -> Vector3:
	var mouse_pos: Vector2 = last_mouse_position
	var ray_origin: Vector3 = project_ray_origin(mouse_pos)
	var ray_dir: Vector3 = project_ray_normal(mouse_pos)
	var ray_end: Vector3 = ray_origin + ray_dir * MAX_DISTANCE
	
	var space_state := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	
	var hit := space_state.intersect_ray(query)
	if hit.is_empty():
		return Vector3.INF
	
	return hit["position"]


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouse:
		last_mouse_position = event.position
