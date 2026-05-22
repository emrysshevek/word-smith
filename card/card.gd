class_name Card
extends Control

@export_category("Nodes")
@export var front: ColorRect
@export var back: ColorRect
@export var top_label: Label
@export var center_label: Label
@export var score_label: Label
@export var ap: AnimationPlayer

@export_category("Attributes")
@export var value: String = "A":
	get:
		return value
	set(val):
		value = val
		_update_display()
@export var score: int = 1:
	get:
		return score
	set(val):
		score = val
		_update_display()
var _is_faceup = true
@export var is_faceup := true:
	get:
		return _is_faceup
	set(val):
		if bool(val) != is_faceup:
			flip()


func _ready() -> void:
	_update_display()
	
	
func flip() -> void:
	ap.play("flip")
	

func _flip() -> bool:
	_is_faceup = not _is_faceup
	if _is_faceup:
		front.show()
		back.hide()
	else:
		front.hide()
		back.show()
	return is_faceup


func _update_display() -> void:
	top_label.text = value
	center_label.text = value
	score_label.text = str(score)
	
