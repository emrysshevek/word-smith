class_name CardDragState
extends CardState

var move_speed := 10.0
var rot_speed := 10.0
var rot_reset_dist := 100.0

func update(_delta: float) -> void:
	if Input.is_action_just_released("lmb"):
		finished.emit(IDLE)

func physics_update(delta: float) -> void:
	_card.global_position = _card.global_position.lerp(_card.get_global_mouse_position(), delta * move_speed)
	
	var direction := _card.global_position.direction_to(_card.get_global_mouse_position()).rotated(-PI/2)
	if _card.get_global_mouse_position().y < _card.global_position.y + 100:
		direction *= -1
	var dist := _card.global_position.distance_to(_card.get_global_mouse_position())
	var max_rot: float = lerpf(0, PI/8, pow(dist / rot_reset_dist, 2))
	max_rot = clampf(max_rot, 0, PI/8)
	var angle = clampf((direction).angle(), -max_rot, max_rot)
	_card.rotation = lerp_angle(_card.rotation, angle, delta * rot_speed)

func exit() -> void:
	_default_state.pos = _card.global_position
