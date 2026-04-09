class_name ObjectManager
extends Node3D

var objects: Array[SlidingObject]
@export var angle_to_direction_multiplier: float = 15

func _ready() -> void:
	for child in get_children():
		if child is SlidingObject:
			objects.append(child)


func move(direction: Vector2):
	var move_direction = direction / angle_to_direction_multiplier
	for object in objects:
		object.move(move_direction)
