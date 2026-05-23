class_name CardIdleState
extends CardState


func handle_mouse_entered() -> void:
	finished.emit(HOVER)
