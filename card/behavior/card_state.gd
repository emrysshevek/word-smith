class_name CardState
extends State

const IDLE := "Idle"
const HOVER := "Hover"
const SELECT := "Select"
const DRAG := "Drag"
const RELEASE := "Release"

var _card: Card
static var _default_state: CardStateShorthand

class CardStateShorthand:
	var pos: Vector2
	var rot: float
	var scale: Vector2
	
	func _init(pos_, rot_, scale_) -> void:
		pos=pos_
		rot=rot_
		scale=scale_
		
	func copy() -> CardStateShorthand:
		return CardStateShorthand.new(pos, rot, scale)
		

func set_actor(actor: Node) -> void:
	super.set_actor(actor)
	
	assert(actor is Card, "CardState can only be used in Card node")
	_card = actor as Card
	var transform = _card.component_manager.get_component(ComponentManager.TRANSFORM)
	_default_state = CardStateShorthand.new(
		transform.position,
		transform.rotation,
		transform.scale
	)
	
	_card.mouse_entered.connect(_on_card_mouse_entered)
	_card.mouse_exited.connect(_on_card_mouse_exited)
	var cm = _card.get_node("ComponentManager")
	cm.get_node(cm.TRANSFORM).changed.connect(_on_card_transform_changed)
	
	
func handle_mouse_entered() -> void:
	pass
	
func handle_mouse_exited() -> void:
	pass
	
	
func _tween_card_state(card_state: CardStateShorthand, duration:=.1) -> Tween:
	var tween: Tween = create_tween().set_parallel()
	
	var pos_tween = tween.tween_property(_card, "global_position", card_state.pos, duration)
	pos_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	
	var rot_tween = tween.tween_property(_card, "rotation", card_state.rot, duration)
	rot_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	
	var scale_tween = tween.tween_property(_card, "scale", card_state.scale, duration)
	scale_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	
	return tween
	

func _on_card_mouse_entered() -> void:
	if active:
		handle_mouse_entered()
	
func _on_card_mouse_exited() -> void:
	if active:
		handle_mouse_exited()
		
func _on_card_transform_changed() -> void:
	var t = _card.component_manager.get_component(ComponentManager.TRANSFORM)
	_default_state.pos = t.position
	_default_state.rot = t.rotation
	_default_state.scale = t.scale
