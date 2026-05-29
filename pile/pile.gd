class_name Pile
extends Container

var _elem_props: Dictionary[Node, PileElement]
var elements: Array[Node]
var count: int:
	get:
		return elements.size()
		
class PileElement:
	var size: Vector2
	var center: Vector2
	func _init(size: Vector2, center: Vector2) -> void:
		self.size = size
		self.center = center
		
		
		
func _physics_process(delta: float) -> void:
	if NOTIFICATION_SORT_CHILDREN:
		_sort_elements()


func add_element(element: Node, elem_size:=Vector2.ZERO, elem_center:=Vector2.ZERO, index:=-1) -> void:
	assert(element not in elements)
	
	elements.insert(index, element)
	_elem_props[element] = PileElement.new(elem_size, elem_center)
	
	queue_sort()


func remove_element(element: Node) -> void:
	var idx = elements.find(element)
	assert(idx != -1)
	
	elements.remove_at(idx)
	_elem_props.erase(element)
	
	queue_sort()


func shuffle_elements() -> void:
	elements.shuffle()
	queue_sort()


func get_next_element(top:=true) -> Node:
	var next: Node = elements.pop_at(0 if top else -1)
	_elem_props.erase(next)
	queue_sort()
	return next
	

func get_next_elements(count:int, top:=true) -> Array[Node]:
	queue_sort()
	return range(count).map(func(_i): return get_next_element(top))
	
	
func _sort_elements() -> void:
	if count == 0:
		return
		
	var dir := int(size.y >= size.x)
	var max_required_size: Vector2 = elements.reduce(func(elem, sum): elem.size, Vector2.ZERO)
	var width: float = min(max_required_size[dir], size[dir])
	var scale_factor = size[dir] / width
	
	var start_pos = global_position + (size / 2)
	start_pos[dir] -= width / 2
	
	var curr_pos: Vector2 = start_pos
	for element in elements:
		curr_pos[dir] += element.center[dir]
		var center_offset = _elem_props[element].center
	


func _reposition_with_area(pos: Vector2, area: Vector2) -> void:
	global_position = pos
	size = area
	

func _reposition_with_corners(corner1: Vector2, corner2: Vector2) -> void:
	var top_left = Vector2(min(corner1.x, corner2.x), min(corner1.y, corner2.y))
	var bot_right = Vector2(max(corner1.x, corner2.x), max(corner1.y, corner2.y))
	
	global_position = top_left
	size = bot_right - top_left
	
	
#region Input testing	
#endregion
