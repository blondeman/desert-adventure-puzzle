extends Control

enum TurnState {
	PLAYER_INPUT,
	CHARACTER_MOVE,
	CHARACTER_ATTACK
}

var camera_controller: CameraController
@export var preview_camera_spring: SpringArm3D

var turn_state: TurnState = TurnState.PLAYER_INPUT
var input_angle: Vector2

signal state_changed_player_input
signal preview_rotation(rotation: Vector2)
signal state_changed_character_move(rotation: Vector2)
signal state_changed_character_attack

func _ready() -> void:
	set_turn_state(TurnState.PLAYER_INPUT)
	camera_controller = get_tree().get_first_node_in_group("camera_controller")


func _process(delta: float) -> void:
	preview_camera_spring.rotation = camera_controller.rotation


func set_turn_state(_turn_state: TurnState):
	turn_state = _turn_state
	process_turn()


func process_turn():
	print("Processing turn state: ", str(turn_state))
	match turn_state:
		TurnState.PLAYER_INPUT:
			process_player_input()
		TurnState.CHARACTER_MOVE:
			process_character_movement()
		TurnState.CHARACTER_ATTACK:
			process_character_attack()


func process_player_input():
	state_changed_player_input.emit()


func process_character_movement():
	state_changed_character_move.emit(input_angle)
	await get_tree().create_timer(1).timeout
	set_turn_state(TurnState.CHARACTER_ATTACK)


func process_character_attack():
	state_changed_character_attack.emit()
	await get_tree().create_timer(1).timeout
	set_turn_state(TurnState.PLAYER_INPUT)


func _button_end_turn():
	if turn_state == TurnState.PLAYER_INPUT:
		set_turn_state(TurnState.CHARACTER_MOVE)


func _set_angle(angle: Vector2):
	input_angle = angle
	preview_rotation.emit(input_angle)
