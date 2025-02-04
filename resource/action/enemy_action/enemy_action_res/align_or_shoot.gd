extends EnemyAction
# align or shoot

enum ActualAction{
	ALIGN,
	SHOOT,
}

## 检查是否可以行动. 如果可以, 则执行行动. 否则返回false
func if_execute()->bool:
	# 两种可以行动的情况, 如果与玩家之间无障碍, 则可以射击
	# 如果不可射击, 则检查可否移动
	var player : Player = GlobalValue.get_tree().get_first_node_in_group("player")
	var player_gridpos : Vector2i = player.gridpos
	var gridpos : Vector2i = executer.gridpos
	# 在同一直线上, 尝试射击
	if gridpos.x == player_gridpos.x or gridpos.y == player_gridpos.y:
		if not if_shoot_blocked(gridpos,player_gridpos):
			execute([ActualAction.SHOOT,(player_gridpos-gridpos).sign()])
			return true
		else:
			return false
	# 不在同一直线上, 尝试对齐
	# 两者曼哈顿距离
	var m_d : Vector2i = player_gridpos - gridpos
	
	var target_gridpos : Vector2i 
	var action_acted : bool = false
	
	if abs(m_d.x) <= abs(m_d.y) :
		target_gridpos = Vector2i(gridpos.x + sign(m_d.x) , gridpos.y)
		var chess : Chess = GlobalValue.level.check_gridpos_occupied(target_gridpos)
		if chess == null:
			execute([ActualAction.ALIGN,target_gridpos])
			action_acted = true
	if not action_acted:
		target_gridpos = Vector2i(gridpos.x , gridpos.y + sign(m_d.y))
		var chess : Chess = GlobalValue.level.check_gridpos_occupied(target_gridpos)
		if chess == null:
			execute([ActualAction.ALIGN,target_gridpos])
			action_acted = true
	if action_acted:
		return true
	return false


## 仅检查是否可以行动, 不执行
func if_can_execute()->bool:
	# 两种可以行动的情况, 如果与玩家之间无障碍, 则可以射击
	# 如果不可射击, 则检查可否移动
	var player : Player = GlobalValue.get_tree().get_first_node_in_group("player")
	var player_gridpos : Vector2i = player.gridpos
	var gridpos : Vector2i = executer.gridpos
	# 在同一直线上, 尝试射击
	if gridpos.x == player_gridpos.x or gridpos.y == player_gridpos.y:
		if not if_shoot_blocked(gridpos,player_gridpos):
			return true
		else:
			return false
	# 不在同一直线上, 尝试对齐
	# 两者曼哈顿距离
	var m_d : Vector2i = player_gridpos - gridpos
	
	var target_gridpos : Vector2i 
	var action_acted : bool = false
	
	if abs(m_d.x) <= abs(m_d.y) :
		target_gridpos = Vector2i(gridpos.x + sign(m_d.x) , gridpos.y)
		var chess : Chess = GlobalValue.level.check_gridpos_occupied(target_gridpos)
		if chess == null:
			action_acted = true
	if not action_acted:
		target_gridpos = Vector2i(gridpos.x , gridpos.y + sign(m_d.y))
		var chess : Chess = GlobalValue.level.check_gridpos_occupied(target_gridpos)
		if chess == null:
			action_acted = true
	if action_acted:
		return true
	return false

## 当射手与玩家处于同一行或列时调用, 检查两者之间是否有其他棋子.
func if_shoot_blocked(executer_gridpos:Vector2i, player_gridpos:Vector2i)->bool:
	# TODO
	var check_gridpos := executer_gridpos
	var direction := Vector2i(Vector2(player_gridpos-executer_gridpos).normalized())
	for i in range(100):
		check_gridpos+=direction
		var chess : Chess = GlobalValue.level.check_gridpos_occupied(check_gridpos)
		if chess and chess is Player:
			return false
		elif chess and chess is not Player:
			return true
	return true


## [action:ActualAction, direction:Vector2i]
func execute(args:Array):
	if args[0] is not ActualAction or args[1] is not Vector2i or args.size() != 2:
		push_error("not an align or shoot args array! ")
		return
	if args[0] == ActualAction.SHOOT:
		var arrow :Arrow= preload("res://scene/chess/enemy/ranger/arrow/arrow.tscn").instantiate()
		arrow.direction = Vector2(args[1])
		GlobalValue.level.chess_container.add_child(arrow)
		arrow.global_position = executer.global_position + Vector3(arrow.direction.x,0,arrow.direction.y)*2.0
		arrow.global_position.y = 1.0
		await arrow.hit_player
		EventBus.action_executed_already.emit()
	elif args[0] == ActualAction.ALIGN:
		var target_grid_pos : Vector2i = args[1]
		var level : Level = GlobalValue.level
		var target_pos : Vector3 = level.chessboard.map_to_local(Vector3i(target_grid_pos.x,0,target_grid_pos.y))
		target_pos.y = 0.0
		var tween : Tween = GlobalValue.create_tween()
		tween.tween_property(executer,"position",target_pos,0.3)
		await tween.finished
		EventBus.action_executed_already.emit()
