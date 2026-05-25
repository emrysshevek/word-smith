class_name Pile
extends Control


func reposition_with_area(pos: Vector2, area: Vector2) -> void:
	global_position = pos
	size = area
	

func reposition_with_corners(corner1: Vector2, corner2: Vector2) -> void:
	var top_left = Vector2(min(corner1.x, corner2.x), min(corner1.y, corner2.y))
	var bot_right = Vector2(max(corner1.x, corner2.x), max(corner1.y, corner2.y))
	
	global_position = top_left
	size = bot_right - top_left
	
	
#region Input testing
var start: Vector2
func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("lmb"):
		start = get_global_mouse_position()
	if Input.is_action_pressed("lmb"):
		reposition_with_corners(start, get_global_mouse_position())
	
#endregion
