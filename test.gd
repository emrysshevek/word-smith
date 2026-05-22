extends Node2D

var hovered = false
@onready var card := $Card


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("rmb"):
		card.flip()
	if Input.is_action_just_pressed("lmb"):
		card.move_to(get_global_mouse_position())
		
	


func _on_card_mouse_entered() -> void:
	hovered = true


func _on_card_mouse_exited() -> void:
	hovered = false
