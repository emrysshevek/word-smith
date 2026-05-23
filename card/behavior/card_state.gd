class_name CardState
extends State

const IDLE := "Idle"
const HOVER := "Hover"
const SELECT := "Select"
const DRAG := "Drag"
const RELEASE := "Release"

var _card: Card

func set_actor(actor: Node) -> void:
	assert(self._actor == null, "Actor can only be set once")
	super.set_actor(actor)
	
	assert(actor is Card, "CardState can only be used in Card node")
	_card = actor as Card
	
	_card.mouse_entered.connect(_on_card_mouse_entered)
	_card.mouse_exited.connect(_on_card_mouse_exited)
	
	
func handle_mouse_entered() -> void:
	pass
	
func handle_mouse_exited() -> void:
	pass
	
	
func _on_card_mouse_entered() -> void:
	if active:
		handle_mouse_entered()
	
func _on_card_mouse_exited() -> void:
	if active:
		handle_mouse_exited()
