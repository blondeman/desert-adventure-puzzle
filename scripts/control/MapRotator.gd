extends Node

@export var map: Node3D
@export var rotation_duration: float = 0.4

var target_rotation: Vector3

func _ready() -> void:
	rotate(Vector2.ZERO)


func rotate(rotation: Vector2):
	target_rotation = Vector3(-deg_to_rad(rotation.y), 0, -deg_to_rad(rotation.x))
	var tween = create_tween()
	tween.tween_property(map, "rotation", target_rotation, rotation_duration)


func _on_turn_manager_preview_rotation(rotation: Vector2) -> void:
	rotate(rotation)
