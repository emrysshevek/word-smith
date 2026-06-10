class_name TransformComponent
extends Component

signal position_changed()
signal rotation_changed()
signal scale_changed()

var _pos: Vector2 = Vector2.ZERO
var position: Vector2:
	get:
		return _pos
	set(val):
		update_position(val)

var _rot := 0.0
var rotation: float:
	get:
		return _rot
	set(val):
		update_rotation(val)

var _scale := Vector2(1,1)
var scale: Vector2:
	get:
		return _scale
	set(val):
		update_scale(val)
		
		
func _ready() -> void:
	if entity == null:
		set_entity(owner)


func set_entity(new_entity: Node) -> void:
	var props := new_entity.get_property_list()
	var has_necessary_props:=[false, false, false]
	for prop in props:
		if prop["name"] == "position" or prop["name"] == "global_position":
			has_necessary_props[0] = true
		elif prop["name"] == "rotation":
			has_necessary_props[1] = true
		elif prop["name"] == "scale":
			has_necessary_props[2] = true
	assert(has_necessary_props.all(func(x): return x), "TransformComponent requires entity to have position, rotation, and scale properties")
	
	entity = new_entity
	update(new_entity.global_position, new_entity.rotation, new_entity.scale)

func update(position:Vector2, rotation:float, scale:Vector2, is_local:=false, is_deg:=false) -> void:
	_update_position(position, is_local)
	position_changed.emit()
	_update_rotation(rotation, is_deg)
	rotation_changed.emit()
	_update_scale(scale)
	scale_changed.emit()
	changed.emit()

func update_position(position: Vector2, is_local:=false) -> void:
	_update_position(position, is_local)
	position_changed.emit()
	changed.emit()
	
func update_rotation(rotation: float, is_deg:=false) -> void:
	_update_rotation(rotation, is_deg)
	rotation_changed.emit()
	changed.emit()
	
func update_scale(scale: Vector2) -> void:
	_update_scale(scale)
	scale_changed.emit()
	changed.emit()
	
func _update_position(position: Vector2, is_local:=false) -> void:
	_pos = position
	if not is_local:
		entity.global_position = position
	else:
		entity.position = position
	
func _update_rotation(rotation: float, is_deg:=false) -> void:
	_rot = rotation
	if not is_deg:
		entity.rotation = rotation
	else:
		entity.rotation_degrees = rotation
	
func _update_scale(scale: Vector2) -> void:
	_scale = scale
	entity.scale = _scale
