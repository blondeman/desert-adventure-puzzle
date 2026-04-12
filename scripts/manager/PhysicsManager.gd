extends Node3D

@export var object_manager: ObjectManager
@export var map: Node3D
@export var map_visuals: Node3D

func _ready():
	split_map()
	split_objects()

func split_map():
	for mesh in map.find_children("*", "MeshInstance3D", true, false):
		var global_pos = mesh.global_position
		var global_rot = mesh.global_rotation
		mesh.get_parent().remove_child(mesh)
		map_visuals.add_child(mesh)
		mesh.global_position = global_pos
		mesh.global_rotation = global_rot

func split_objects():
	for object in object_manager.objects:
		var mesh = object.visuals
		var global_pos = mesh.global_position
		var global_rot = mesh.global_rotation
		mesh.get_parent().remove_child(mesh)
		map_visuals.add_child(mesh)
		mesh.global_position = global_pos
		mesh.global_rotation = global_rot

func _process(delta: float) -> void:
	for object in object_manager.objects:
		var visual_space = collision_to_visual_space(object.global_position, object.global_rotation)
		object.visuals.global_position = visual_space.position
		object.visuals.global_rotation = visual_space.rotation

func collision_to_visual_space(pos: Vector3, rot: Vector3) -> Dictionary:
	var local_pos = map.to_local(pos)
	var visual_pos = map_visuals.to_global(local_pos)
	var visual_rot = rot - map.global_rotation + map_visuals.global_rotation
	return { "position": visual_pos, "rotation": visual_rot }
