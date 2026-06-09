class_name ComponentManager
extends Component

const TRANSFORM := "TransformComponent"


func _ready() -> void:
	if entity == null:
		entity = owner
	
	for child in get_children():
		child.set_entity(entity)


func set_entity(new_entity: Node) -> void:
	assert(false, "Cannot change entity of ComponentManager after it has been added to tree")
	super.set_entity(new_entity)

## adds given component to parent entity
func add_component(component: Component) -> void:
	component.set_entity(entity)
	if component.get_parent() == null:
		add_child(component)
	else:
		reparent(self)

## Removes compnent with given name and deletes it
func remove_component(component_name: String) -> void:
	if has_node(component_name):
		var node = get_node(component_name)
		remove_child(node)
		node.queue_free()
	else:
		push_warning("Attempting to remove %s component but it does not exist" % name)
		
		
func get_component(component_name: String) -> Component:
	return get_node(component_name)
