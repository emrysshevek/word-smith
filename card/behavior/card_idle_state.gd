class_name CardIdleState
extends CardState


var tween: Tween


func enter(_previous_state_path: String, _data := {}) -> void:
	var t = _card.component_manager.get_component(ComponentManager.TRANSFORM)
	tween = _tween_card_state(CardStateShorthand.new(t.position, t.rotation, t.scale), .25)

func exit() -> void:
	tween.kill()

func update(_delta: float) -> void:
	if _card.mouse_over:
		finished.emit(HOVER)
