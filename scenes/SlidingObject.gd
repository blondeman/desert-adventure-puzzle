class_name SlidingObject
extends RigidBody3D

const MOVE_SPEED = 5.0
const STOP_THRESHOLD = 0.05

var target_position: Vector3 = Vector3.ZERO
var is_moving: bool = false
var move_complete: bool = false

func move(direction: Vector2):
	var local_dir = Vector3(direction.x, 0, -direction.y)
	var world_dir = get_parent().get_parent().global_transform.basis * local_dir
	
	target_position = global_position + world_dir
	is_moving = true
	move_complete = false

func _physics_process(delta: float):
	if not is_moving:
		return
	
	var flat_offset = target_position - global_position
	flat_offset.y = 0
	
	var distance = flat_offset.length()
	
	if distance < STOP_THRESHOLD and is_on_floor():
		global_position = Vector3(target_position.x, global_position.y, target_position.z)
		linear_velocity = Vector3(0, linear_velocity.y, 0)
		is_moving = false
		move_complete = true
		return
	
	var move_velocity = flat_offset.normalized() * MOVE_SPEED
	linear_velocity = Vector3(move_velocity.x, linear_velocity.y, move_velocity.z)

func is_on_floor() -> bool:
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(
		global_position,
		global_position + Vector3.DOWN * 0.6  # slightly more than half the object's height
	)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	return result != {}
