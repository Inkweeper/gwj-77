extends PlayerAction
# 玩家攻击行动通用脚本

# 只接受一个单元素, 元素为 target_grid_pos : Vector2i 的入参
## args = [target_grid_pos : Vector2i,]
func execute(args : Array):
	if args.size() != 1 or args[0] is not Vector2i:
		return
	
	var target_grid_pos : Vector2i = args[0]
	var level : Level = GlobalValue.level
	
	var target_pos : Vector3 = level.chessboard.map_to_local(Vector3i(target_grid_pos.x,0,target_grid_pos.y))
	target_pos.y = 0.0
	
	var target_chess : Chess = level.check_gridpos_occupied(target_grid_pos)
	
	if target_chess == null :
		push_error("trying to attack an empty grid")
		return
	
	# TODO 具体攻击逻辑
	var tween : Tween = GlobalValue.create_tween()
	# 直接挪动攻击者位置, 如果出bug考虑只挪动模型?
	var origion_pos : Vector3 = executer.position
	tween.tween_property(executer,"position",lerp(executer.position, target_pos, 0.5),0.2)
	tween.tween_callback(target_chess.get_hit)
	tween.tween_property(executer, "position", origion_pos, 0.2)
	
	await tween.finished
