extends Node3D
class_name ChessBoard

@export var grid_map: GridMap

var mesh_library: MeshLibrary


func _ready() -> void:
	mesh_library = grid_map.mesh_library


func pick_cell_from_mouse(camera: Camera3D) -> Variant:
	# Raycast from the given camera through the current mouse position and
	# return a dictionary with the picked grid cell and its item on the given layer.
	# Returns null if nothing on the GridMap was hit.
	if camera == null or grid_map == null:
		return null
	
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var ray_origin: Vector3 = camera.project_ray_origin(mouse_pos)
	var ray_dir: Vector3 = camera.project_ray_normal(mouse_pos)
	var ray_end: Vector3 = ray_origin + ray_dir * 4096.0
	
	var space_state := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	# Limit hits to the GridMap's collision layer to avoid unrelated geometry
	query.collision_mask = grid_map.collision_layer
	
	var hit := space_state.intersect_ray(query)
	if hit.is_empty():
		return null
	
	var world_pos: Vector3 = hit["position"]
	var local_pos: Vector3 = grid_map.to_local(world_pos)
	var cell: Vector3i = grid_map.local_to_map(local_pos)
	var item: int = grid_map.get_cell_item(cell)
	
	var mesh_name: String = mesh_library.get_item_name(item)
	print("global position: %s, local position: %s" % [world_pos, local_pos])
	print("selected item: %s, item: %s, cell: %s" % [mesh_name, item, cell])
	
	return {
		"cell": cell,
		"item": item,
		"position": world_pos,
		"layer": 0
	}
