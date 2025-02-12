extends State
# enemy_turn

## 记录所有敌人棋子的列表
var enemy_list : Array[Enemy] = []

var defeated : bool = false

func initialize():
	EventBus.enemy_action_phase_ended.connect(_on_an_enemy_completed_action)
	EventBus.player_killed.connect(_on_player_killed)
	EventBus.defeated.connect(_on_defeated)
	
	pass

func enter():
	$"../../CanvasLayer/IngameRewindButton".modulate = Color(0.3, 0.3, 0.3)
	defeated = false
	await get_tree().create_timer(0.5).timeout
	enemy_list.clear()
	for child in GlobalValue.level.chess_container.get_children():
		if child is Enemy:
			if child.is_alive:
				enemy_list.append(child)
	if enemy_list.is_empty():
		transitioned.emit(self, "Victory")
	enemy_list.sort_custom(func(a:Enemy, b:Enemy): return a.action_priority < b.action_priority)
	_on_an_enemy_completed_action()

func exit():
	$"../../CanvasLayer/IngameRewindButton".modulate = Color(1, 1, 1)
	pass

func update(delta:float):
	pass

func _on_an_enemy_completed_action():
	if state_machine.current_state != self or defeated:
		return
	if enemy_list.is_empty():
		await get_tree().create_timer(0.2).timeout
		#transitioned.emit(self, "PlayerTurnStart")
		transitioned.emit(self, "TurnEnding")
		return
	EnemyActionManager.register_enemy(enemy_list.pop_front())

func _on_player_killed():
	defeated = true

func _on_defeated():
	if state_machine.current_state != self:
		return
	defeated = true
	transitioned.emit(self,"Failure")
