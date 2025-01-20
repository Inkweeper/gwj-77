extends Action
class_name PlayerAction

@export var allowed_target_grids : Array[Vector2i] = []

var aiming_grid_pos_list : Array[Vector2i] = []


## @experimental: level.set_grid()已经弃用
func clear_aim():
	var level : Level = GlobalValue.level
	for aiming_grid_pos in aiming_grid_pos_list:
		level.set_grid(aiming_grid_pos,0)
	aiming_grid_pos_list.clear()

func if_can_execute(args:Array)->bool:
	return false

func aim():
	pass
