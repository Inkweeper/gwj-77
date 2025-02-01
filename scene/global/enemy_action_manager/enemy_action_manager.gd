extends Node

var enemy_processing : Enemy = null
var enemy_had_acted : bool = false
var attack_action_list : Array[EnemyAction] = []
var move_action_list : Array[EnemyAction] = []

func _ready() -> void:
	EventBus.enemy_action_acted.connect(process_enemy_action)

## 清空之前的注册内容
func clear():
	enemy_processing = null
	enemy_had_acted = false
	attack_action_list.clear()
	move_action_list.clear()

## 敌人注册
func register_enemy(enemy : Enemy):
	clear()
	enemy_processing = enemy
	for action in enemy.action_list:
		if action is EnemyAction:
			if action.action_type == Action.Type.ATTACK:
				attack_action_list.append(action)
			elif action.action_type == Action.Type.MOVE:
				move_action_list.append(action)
	process_enemy_action()
	
## 处理敌人行动
func process_enemy_action():
	await get_tree().create_timer(0.1).timeout
	enemy_had_acted = false
	# 首先判断能否攻击. 如果可以, 这个敌人本回合的事实际已经做完了, 所以可以结束和return
	var attack_action : EnemyAction = attack_action_list.pop_front()
	if attack_action != null:
		attack_action = attack_action as EnemyAction
		if attack_action.if_can_execute():
			attack_action.if_execute()
			await EventBus.action_executed_already
			enemy_had_acted = true
		if enemy_had_acted:
			enemy_action_phase_end()
			return
		else:
			attack_action_list.push_front(attack_action)
	# 接着判断和执行移动
	var move_action : EnemyAction = move_action_list.pop_front()
	if move_action != null:
		move_action = move_action as EnemyAction
		if move_action.if_can_execute():
			move_action.if_execute()
			await EventBus.action_executed_already
			enemy_had_acted = true
		if enemy_had_acted:
			EventBus.enemy_action_acted.emit()
			return
		else :
			enemy_action_phase_end()
			return
	else:
		enemy_action_phase_end()
		return

## 当前敌人所有行动执行结束时调用
func enemy_action_phase_end():
	await get_tree().create_timer(0.1).timeout
	clear()
	EventBus.enemy_action_phase_ended.emit()
	
