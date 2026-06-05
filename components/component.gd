class_name Component
extends Node

signal changed()

var entity: Node

func set_entity(entity: Node) -> void:
	self.entity = entity
	changed.emit()
