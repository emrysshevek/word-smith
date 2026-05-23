class_name CardHoverState
extends CardState

func handle_mouse_exited() -> void:
	finished.emit(IDLE)
