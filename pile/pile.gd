class_name Pile
extends Container


@export var move_speed := 500.0
@export var rot_speed: float = PI * 4

var _elem_props: Dictionary[Node, PileElement]
var elements: Array[Node]
var count: int:
	get:
		return elements.size()
var tween: Tween





func _notification(what: int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		_sort_elements()


var c1: Vector2
func _physics_process(_delta: float) -> void:		
	if Input.is_action_just_pressed("lmb"):
		c1 = get_global_mouse_position()
	elif Input.is_action_just_released("lmb"):
		_reposition_with_corners(c1, get_global_mouse_position())
	
	if Input.is_action_just_pressed("rmb"):
		_reposition_with_area(get_global_mouse_position() - size / 2, size)
		
	if Input.is_action_just_pressed("ui_up"):
		var card: Card = preload("res://card/card.tscn").instantiate()
		card.scale = Vector2(randf_range(.4, .5), randf_range(.4,.5))
		card.top_level = true
		add_child(card)
		add_element(card, card.back.texture.get_size() * card.scale)
		#add_element(card, card.back.texture.get_size() * card.scale + Vector2(20,0))
		
		queue_sort()
		


func add_element(element: Node, elem_size:=Vector2.ZERO, elem_center:=Vector2.ZERO, index:=-1) -> void:
	assert(element not in elements)
	if index == -1:
		elements.append(element)
	else:
		elements.insert(index, element)
	_elem_props[element] = PileElement.new(elem_size, elem_center)
	
	if element.has_signal("mouse_entered") and element.has_signal("mouse_exited"):
		element.mouse_entered.connect(_on_element_mouse_entered.bind(element))
		element.mouse_exited.connect(_on_element_mouse_exited.bind(element))
	else:
		push_warning("Element %s added to pile but does not have `mouse_entered` or `mouse_exited` signal. Some functionality will be lost." % element)
		
	queue_sort()


func remove_element(element: Node) -> void:
	var idx = elements.find(element)
	assert(idx != -1)
	
	if elements[idx].has_signal("mouse_entered") and elements[idx].has_signal("mouse_exited"):
		elements[idx].mouse_entered.disconnect(_on_element_mouse_entered)
		elements[idx].mouse_exited.disconnect(_on_element_mouse_entered)

	elements.remove_at(idx)
	_elem_props.erase(element)
	
	queue_sort()


func shuffle_elements() -> void:
	elements.shuffle()
	queue_sort()


func get_next_element(top:=true) -> Node:
	var elem := elements[0 if top else -1]
	remove_element(elem)
	queue_sort()
	return elem
	

func get_next_elements(count:int, top:=true) -> Array[Node]:
	queue_sort()
	return range(count).map(func(_i): return get_next_element(top))


func _sort_elements() -> void:
	if count == 0:
		return
		
	var dir := int(size.y >= size.x)
	var total_required_size: Vector2 = elements.reduce(func(sum, elem): return sum + _elem_props[elem]["size"], Vector2.ZERO)
	var max_width: float = elements.reduce(
		func(max_val, elem): 
			if _elem_props[elem]["size"][dir] > max_val:
				return _elem_props[elem]["size"][dir]
			else:
				return max_val,
		0
	)
	var width: float = min(total_required_size[dir], size[dir])
	var scale_factor = (width - _elem_props[elements[-1]]["size"][dir]) / (total_required_size[dir] - _elem_props[elements[-1]]["size"][dir])
	if width < max_width:
		scale_factor = 0

	var center_pos = global_position + (size / 2)
	var start_pos = center_pos
	start_pos[dir] -= max(max_width, width) / 2
	
	# "center" = center - position. 
	# Vector pointing from element's global_position to its center
	var curr_pos: Vector2 = start_pos
	for i in count:
		var elem := elements[i]
		var props := _elem_props[elem]
		# initialize offset to center element at curr pos
		var offset: Vector2 = -props["center"]
		# shift by half element width so edge is positioned at curr_pos
		# account for scale factor so everything is squished consistently
		offset[dir] += props.size[dir] / 2

		#_move_element(element, curr_pos + offset)
		#element.global_position = curr_pos + offset
		props.position = curr_pos + offset
		
		# shift curr_pos by width of element for next element
		var shift: float = max(3, props["size"][dir] * scale_factor)
		curr_pos[dir] += shift
		
	_position_elements(false)


func _position_elements(with_delay:=true) -> void:
	if tween != null:
		tween.kill()
	
	tween = create_tween().set_parallel()
	
	for i in elements.size():
		_move_element(elements[i], _elem_props[elements[i]].position, i * .1 if with_delay else 0.0, tween)


func _move_element(element: Node, coordinates: Vector2, delay:=0.0, t:Tween=null) -> void:
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
	
	if t == null:
		t = create_tween().set_parallel()
	
	var transform: TransformComponent = element.component_manager.get_component(ComponentManager.TRANSFORM)
	var move_tween = t.tween_property(transform, "position", coordinates, move_duration).set_delay(delay)
	move_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	
	t.tween_property(element, "rotation", -angle, rot_duration).set_delay(delay)
	t.tween_property(element, "rotation", 0, rot_duration).set_delay(delay + move_duration * .5)


func _reposition_with_area(pos: Vector2, area: Vector2) -> void:
	global_position = pos
	size = area
	
	queue_sort()
	

func _reposition_with_corners(corner1: Vector2, corner2: Vector2) -> void:
	var top_left = Vector2(min(corner1.x, corner2.x), min(corner1.y, corner2.y))
	var bot_right = Vector2(max(corner1.x, corner2.x), max(corner1.y, corner2.y))
	
	global_position = top_left
	size = bot_right - top_left
	
	$ColorRect.size = size
	$ColorRect.global_position = global_position
	
	print("Pile position: %s, size: %s" % [global_position, size])
	
	queue_sort()
	

func _on_element_mouse_entered(element: Node) -> void:
	(element as CanvasItem).z_index = 1
	
func _on_element_mouse_exited(element: Node) -> void:
	(element as CanvasItem).z_index = 0
	

#region Input testing
#endregion
