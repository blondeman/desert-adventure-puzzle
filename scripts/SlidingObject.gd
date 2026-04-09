class_name SlidingObject
extends RigidBody3D

const MOVE_SPEED = 5.0
const STOP_THRESHOLD = 0.05

var target_position: Vector3 = Vector3.ZERO
@export var mesh: Node3D

func _ready() -> void:
	target_position = position

func move(direction: Vector2):
	target_position = global_position + Vector3(direction.x, 0, -direction.y)

func _physics_process(delta: float):
	var offset = target_position - global_position
	offset.y = 0

	if offset.length() < STOP_THRESHOLD:
		global_position = Vector3(target_position.x, global_position.y, target_position.z)
		linear_velocity = Vector3(0, linear_velocity.y, 0)
		return

	linear_velocity = Vector3(offset.normalized().x * MOVE_SPEED, linear_velocity.y, offset.normalized().z * MOVE_SPEED)
