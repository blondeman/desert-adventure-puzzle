class_name SlidingObject
extends RigidBody3D

const MOVE_SPEED = 5.0
const STOP_THRESHOLD = 0.05

var target_position: Vector3 = Vector3.ZERO
@export var visuals: Node3D
@export var pointer_parent: Node3D
@export var pointer: PackedScene

func _ready() -> void:
	target_position = position

func move(direction: Vector2):
	clear_pointers()
	target_position = global_position + Vector3(direction.x, 0, -direction.y)

func _physics_process(delta: float):
	var offset = target_position - global_position
	offset.y = 0

	if offset.length() < STOP_THRESHOLD:
		global_position = Vector3(target_position.x, global_position.y, target_position.z)
		linear_velocity = Vector3(0, linear_velocity.y, 0)
		return

	linear_velocity = Vector3(offset.normalized().x * MOVE_SPEED, linear_velocity.y, offset.normalized().z * MOVE_SPEED)

func display_pointers(direction: Vector2):
	clear_pointers()
	
	var count: int = roundi(direction.length())
	var normal: Vector2 = direction.normalized()
	for c in count:
		var new_position = normal * (c + 1)
		var new_pointer: Node3D = pointer.instantiate() as Node3D
		new_pointer.position = Vector3(new_position.x, 0, -new_position.y)
		new_pointer.rotation = Vector3(0, atan2(normal.y, normal.x), -PI/2)
		pointer_parent.add_child(new_pointer)


func clear_pointers():
	for child in pointer_parent.get_children():
		child.free()
