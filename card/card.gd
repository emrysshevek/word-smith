class_name Card
extends Node2D

signal mouse_entered()
signal mouse_exited()


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
			flip.call_deferred()
@export var move_speed := 2000.0
@export var rot_speed: float = PI * 4

@export_category("Nodes")
@export var front: Node
@export var back: Node
@export var top_label: Label
@export var center_label: Label
@export var score_label: Label

var state: State:
	get:
		return $StateMachine.state
var mouse_over: bool = false
		


func _ready() -> void:
	_update_display()
	
	
func flip() -> void:
	var starting_scale = scale
	var tween1 = get_tree().create_tween()
	tween1.tween_property(self, "scale", Vector2(0, starting_scale.y), .1)
	tween1.finished.connect(
		func():
			_flip()
			var tween2 = get_tree().create_tween()
			tween2.tween_property(self, "scale", starting_scale, .1)
	)

func move_to(coordinates: Vector2) -> void:
	var move_duration = global_position.distance_to(coordinates) / move_speed
	var direction = global_position.direction_to(coordinates).rotated(PI/2)
	if coordinates.y > global_position.y:
		direction *= -1
	var angle = (Vector2(1,-1) * direction).angle()
	var rot_time_required = abs(angle) / rot_speed
	var rot_duration = min(move_duration, rot_time_required)
	var max_rotation = min(abs(rot_speed * rot_duration), PI/3)
	var allowed_rotation = min(abs(angle), max_rotation)
	angle = clamp(angle, -allowed_rotation, allowed_rotation)
	
	var tween := get_tree().create_tween()
	tween.set_parallel()
	var move_tween = tween.tween_property(self, "global_position", coordinates, move_duration)
	move_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "rotation", -angle, rot_duration)
	tween.tween_property(self, "rotation", 0, rot_duration).set_delay(move_duration * .5)
	

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

	
func _on_mouse_entered() -> void:
	mouse_over = true
	mouse_entered.emit()

func _on_mouse_exited() -> void:
	mouse_over = false
	mouse_exited.emit()
