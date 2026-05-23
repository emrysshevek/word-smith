class_name CardHoverState
extends CardState


var tween: Tween
var spinner: Tween

var hold_start_pos: Vector2
var drag_dist := 10.0
var is_holding := false


func enter(_previous_state_path: String, _data := {}) -> void:
	var hover_state := _default_state.copy()
	hover_state.scale *= 1.05
	tween = _tween_card_state(hover_state)
	
	spinner = create_tween().set_loops().set_parallel(false)
	spinner.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	spinner.tween_property(_card, "rotation", PI / 32, 2)
	spinner.tween_property(_card, "rotation", -PI / 32, 2)
	
	
func update(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if not is_holding:
			is_holding = true
			hold_start_pos = _card.get_global_mouse_position()
		else:
			if hold_start_pos.distance_to(_card.get_global_mouse_position()) > drag_dist:
				finished.emit(DRAG)
	elif Input.is_action_just_released("lmb") and _card.mouse_over:
		finished.emit(SELECT)


func exit() -> void:
	tween.kill()
	spinner.kill()	
	is_holding = false


func handle_mouse_exited() -> void:
	finished.emit(IDLE)
