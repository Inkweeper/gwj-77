extends EnemyAction
# align or shoot

## 检查是否可以行动. 如果可以, 则执行行动. 否则返回false
func if_execute()->bool:
	
	return false

## 仅检查是否可以行动, 不执行
func if_can_execute()->bool:
	# 两种可以行动的情况, 如果与玩家之间无障碍, 则可以射击
	# 如果不可射击, 则检查可否移动
	var player : Player = GlobalValue.get_tree().get_first_node_in_group("player")
	var player_gridpos : Vector2i = player.gridpos
	var gridpos : Vector2i = executer.gridpos
	if gridpos.x == player_gridpos.x or gridpos.y == player_gridpos.y:
		pass
		
		
		
		pass
	
	return false

## 当射手与玩家处于同一行或列时调用, 检查两者之间是否有其他棋子.
func if_shoot_blocked(executer:Chess, player:Chess)->bool:
	# TODO
	# 改用点插入,以棋盘格边长为距离插入多点, 逐个检查碰撞体成分
	var from := Vector3(executer.position.x, 1.0, executer.position.z)
	var to := Vector3(player.position.x, 1.0, player.position.z)
	var physics_ray_query_parameters_3d := PhysicsRayQueryParameters3D.create(
		from,
		to,
		1<<2,
	)
	physics_ray_query_parameters_3d.collide_with_areas = true
	physics_ray_query_parameters_3d.collide_with_bodies = false
	
	var space_state := GlobalValue.level.get_world_3d().direct_space_state
	var result : = space_state.intersect_ray(physics_ray_query_parameters_3d)
	for key in result.keys():
		
		pass
	return false


func execute(args:Array):
	pass
