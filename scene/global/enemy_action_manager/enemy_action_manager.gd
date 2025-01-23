extends Node

var enemy_processing : Enemy = null
var enemy_had_acted : bool = false
var attack_action_list : Array[EnemyAction] = []
var move_action_list : Array[EnemyAction] = []

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
			var action_duplication := action.duplicate(true)
			if action.action_type == Action.Type.ATTACK:
				attack_action_list.append(action_duplication)
			elif action.action_type == Action.Type.MOVE:
				move_action_list.append(action_duplication)
	
## 处理敌人行动
func process_enemy_action():
	# 是否可以行动, 行动了没有? 如果没有, 那么就不必要再行动了
	
	# 首先判断能否攻击. 如果可以, 这个敌人本回合的事实际已经做完了, 所以可以发送信号和return
	# TODO
	
	# 接着判断和执行移动
	var move_action : EnemyAction = move_action_list.pop_front()
	if not move_action:
		enemy_action_phase_end()
		return
	enemy_had_acted = move_action.if_execute()
	if enemy_had_acted:
		EventBus.enemy_action_acted
		return
	else :
		enemy_action_phase_end()
		return

## 当前敌人所有行动执行结束时调用
func enemy_action_phase_end():
	clear()
	EventBus.enemy_action_phase_ended.emit()
	
