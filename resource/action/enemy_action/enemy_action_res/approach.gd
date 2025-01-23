extends EnemyAction

# approach.gd
# 近战敌人试图靠近玩家的行动脚本

func if_execute()->bool:
	# 当进行approach行动的检查时, 说明曼哈顿距离不是1,0或0,1
	
	var player_gridpos : Vector2i = GlobalValue.level.get_player_gridpos()
	var gridpos : Vector2i = executer.gridpos
	# 两者曼哈顿距离
	var m_d : Vector2i = player_gridpos - gridpos
	
	var target_gridpos : Vector2i 
	var action_acted : bool = false
	
	if abs(m_d.x) >= abs(m_d.y) :
		target_gridpos = Vector2i(gridpos.x + sign(m_d.x) , gridpos.y)
		var chess : Chess = GlobalValue.level.check_gridpos_occupied(target_gridpos)
		if chess == null:
			execute([target_gridpos])
			action_acted = true
	if not action_acted:
		target_gridpos = Vector2i(gridpos.x , gridpos.y + sign(m_d.y))
		var chess : Chess = GlobalValue.level.check_gridpos_occupied(target_gridpos)
		if chess == null:
			execute([target_gridpos])
			action_acted = true
	if action_acted:
		return true
	return false
	
func execute(args:Array):
	if args.size() != 1 or args[0] is not Vector2i:
		return
	
	var target_grid_pos : Vector2i = args[0]
	var level : Level = GlobalValue.level
	
	var target_pos : Vector3 = level.chessboard.map_to_local(Vector3i(target_grid_pos.x,0,target_grid_pos.y))
	target_pos.y = 0.0
	var tween : Tween = GlobalValue.create_tween()
	tween.tween_property(executer,"position",target_pos,0.3)
	await tween.finished
