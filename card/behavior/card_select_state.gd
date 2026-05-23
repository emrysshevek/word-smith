class_name CardSelectState
extends CardState

var start_pos: Vector2
var tween: Tween

func enter(_previous_state_path: String, _data := {}) -> void:	
	var new_pos := _default_state.pos + Vector2(0, -50)
	var select_state = _default_state.copy()
	select_state.pos = new_pos
	tween = _tween_card_state(select_state, .1)
	
func update(_delta: float) -> void:
	if _card.mouse_over and Input.is_action_just_released("lmb"):
		finished.emit(IDLE)
			
func exit() -> void:
	tween.kill()	
