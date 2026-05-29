class_name _PileElement
extends Node2D

var movement_constraint := Vector2.RIGHT


func reposition(neighbors: Array[Node2D]) -> void:
	var new_pos: Vector2 = neighbors.reduce(func(sum, x): return sum + x, Vector2.ZERO) / neighbors.size()
	new_pos *= movement_constraint
	
