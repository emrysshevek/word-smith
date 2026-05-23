class_name CardIdleState
extends CardState


var tween: Tween


func enter(_previous_state_path: String, _data := {}) -> void:
	tween = _tween_card_state(_default_state, .25)

func exit() -> void:
	tween.kill()

func update(_delta: float) -> void:
	if _card.mouse_over:
		finished.emit(HOVER)
