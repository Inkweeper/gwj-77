extends State
# enemy_turn

## 记录所有敌人棋子的列表
var enemy_list : Array[Enemy] = []

func initialize():
	EventBus.enemy_action_phase_ended.connect(_on_an_enemy_completed_action)
	pass

func enter():
	enemy_list.clear()
	for child in GlobalValue.level.chess_container.get_children():
		if child is Enemy:
			enemy_list.append(child)
	if enemy_list.is_empty():
		transitioned.emit(self, "Victory")
	enemy_list.sort_custom(func(a:Enemy, b:Enemy): return a.action_priority < b.action_priority)
	_on_an_enemy_completed_action()

func exit():
	pass

func update(delta:float):
	pass

func _on_an_enemy_completed_action():
	if enemy_list.is_empty():
		await get_tree().create_timer(0.2).timeout
		#transitioned.emit(self, "PlayerTurnStart")
		transitioned.emit(self, "TurnEnding")
		return
	EnemyActionManager.register_enemy(enemy_list.pop_front())
