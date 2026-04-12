extends Node


@export var max_health: int = 100
@export var current_health: int = 0

signal on_health_changed(health: int, max_health: int, amount: int)
signal on_die()

func _ready() -> void:
	if current_health == 0:
		current_health = max_health
	
	on_health_changed.emit(current_health, max_health, 0)

func take_healing(healing: int):
	current_health += healing
	on_health_changed.emit(current_health, max_health, healing)
	if current_health <= 0:
		die()

func take_damage(damage: int):
	current_health -= damage
	on_health_changed.emit(current_health, max_health, -damage)
	if current_health <= 0:
		die()

func die():
	on_die.emit()
	get_parent().queue_free()
