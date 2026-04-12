extends SubViewportContainer

@export var camera: Camera3D

var hover_node: SelectNode = null
var select_node: SelectNode = null

signal select_rotation(rotation: Vector2)


func _ready() -> void:
	select(null)


func _process(delta: float) -> void:
	var space_state = camera.get_world_3d().direct_space_state
	var mousepos = get_local_mouse_position()

	var origin = camera.project_ray_origin(mousepos)
	var end = origin + camera.project_ray_normal(mousepos) * 10
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collision_mask = (1 << 1)
	query.collide_with_areas = true

	var result = space_state.intersect_ray(query)
	
	if result:
		var collider = result["collider"]
		if collider is SelectNode:
			hover(collider)
		else:
			hover(null)
	else:
		hover(null)


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and hover_node != null:
		select(hover_node)

func select(node: SelectNode):
	if node == select_node:
		return
	if node:
		node.select()
	if select_node:
		select_node.unselect()
	
	select_node = node
	select_rotation.emit(select_node.get_direction_vector())
	print(select_node.get_direction_vector())


func hover(node: SelectNode):
	if node == hover_node:
		return
	if node:
		node.hover()
	if hover_node:
		hover_node.unhover()
	
	hover_node = node
