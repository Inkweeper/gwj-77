extends Action
class_name PlayerAction

@export var allowed_target_grids : Array[Vector2i] = []

func if_can_execute(args:Array)->bool:
	return false

func aim():
	pass
