class_name SelectNode
extends Node

enum Direction {
	NONE,
	NORTH,
	EAST,
	SOUTH,
	WEST
}

@export var direction: Direction = Direction.NONE
@export var angle: float = 0

@export var base_color: Color = Color.GRAY
@export var hover_color: Color = Color.ORANGE
@export var select_color: Color = Color.RED

@onready var mesh_instance: MeshInstance3D = find_child("MeshInstance3D")

var is_selected: bool = false
var is_hovered: bool = false

func _ready() -> void:
	_update_color()

func select():
	is_selected = true
	_update_color()

func unselect():
	is_selected = false
	_update_color()

func hover():
	is_hovered = true
	_update_color()

func unhover():
	is_hovered = false
	_update_color()

func _update_color():
	if not mesh_instance:
		return
	# Make a unique material so instances don't share it
	var mat = mesh_instance.get_active_material(0)
	if not mat or not mat is StandardMaterial3D:
		return
	mat = mat.duplicate()
	mesh_instance.set_surface_override_material(0, mat)
	if is_selected:
		mat.albedo_color = select_color
	elif is_hovered:
		mat.albedo_color = hover_color
	else:
		mat.albedo_color = base_color


func get_direction_vector() -> Vector2:
	match direction:
		Direction.NORTH: return Vector2(0, angle)
		Direction.SOUTH: return Vector2(0, -angle)
		Direction.EAST: return Vector2(angle, 0)
		Direction.WEST: return Vector2(-angle, 0)
		_: return Vector2.ZERO
