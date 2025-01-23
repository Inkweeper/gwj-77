extends State
# enemy_turn

## 记录所有敌人棋子的列表
var enemy_list : Array[Enemy] = []



func initialize():
	pass

func enter():
	print("enemy turn")
	enemy_list.clear()
	for child in GlobalValue.level.chess_container.get_children():
		if child is Enemy:
			enemy_list.append(child)
	if enemy_list.is_empty():
		transitioned.emit(self, "Victory")
	enemy_list.sort_custom(func(a:Enemy, b:Enemy): return a.action_priority < b.action_priority)

func exit():
	pass

func update(delta:float):
	pass
