class_name Pile
extends Container

#var _elem_props: Array[Dictionary]
var elements: Array[Node]
var count: int:
	get:
		return elements.size()


func add_element(element: Node, index:=-1) -> void:
	elements.insert(index, element)
	queue_sort()


func remove_element(element: Node) -> void:
	elements.erase(element)
	queue_sort()


func shuffle_elements() -> void:
	elements.shuffle()
	queue_sort()


func get_next_element(top:=true) -> Node:
	queue_sort()
	if top:
		return elements.pop_front()
	else:
		return elements.pop_back()
	

func get_next_elements(count:int, top:=true) -> Array[Node]:
	queue_sort()
	return range(count).map(func(_i): return get_next_element(top))
	
	
func _sort_elements() -> void:
	if count == 0:
		return
		
	
	


func _reposition_with_area(pos: Vector2, area: Vector2) -> void:
	global_position = pos
	size = area
	

func _reposition_with_corners(corner1: Vector2, corner2: Vector2) -> void:
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
		_reposition_with_corners(start, get_global_mouse_position())
	
#endregion
