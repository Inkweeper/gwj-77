extends PlayerAction



## args = [target_grid_pos : Vector2i,]
func execute(args : Array):
	if args.size() != 1 or args[0] is not Vector2i:
		return
	
	var target_grid_pos : Vector2i = args[0]
	var level : Level = GlobalValue.level
	
	var target_pos : Vector3 = level.chessboard.map_to_local(Vector3i(target_grid_pos.x,0,target_grid_pos.y))
	target_pos.y = 0.0
	var tween : Tween = GlobalValue.create_tween()
	tween.tween_property(executer,"position",target_pos,0.3)
	await tween.finished
