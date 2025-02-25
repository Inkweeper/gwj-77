extends Node

var is_activated : bool = false
var processing_player_action : PlayerAction = null
var processing_player_action_select_button : PlayerActionSelectButton = null

var hovered_aim_box : AimBox

var player_is_acting : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_unhandled_input(false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	hovered_aim_box = aim_box_highlight_check()
	

func aim_box_highlight_check()->AimBox:
	if not is_activated:
		return
	var from := GlobalValue.level.camera_3d.project_ray_origin(get_viewport().get_mouse_position())
	var to := from + GlobalValue.level.camera_3d.project_ray_normal(get_viewport().get_mouse_position())*1000
	var physics_ray_query_parameters_3d := PhysicsRayQueryParameters3D.create(
		from,
		to,
		1<<1,
	)
	physics_ray_query_parameters_3d.collide_with_areas = true
	physics_ray_query_parameters_3d.collide_with_bodies = false
	
	var space_state := GlobalValue.level.get_world_3d().direct_space_state
	var result := space_state.intersect_ray(physics_ray_query_parameters_3d)
	
	var aim_box :AimBox = null
	
	if not result.is_empty():
		aim_box = result["collider"].owner
		if aim_box is AimBox:
			GlobalValue.level.high_light_aim_box(aim_box)
		else:
			GlobalValue.level.high_light_aim_box(null)
	else:
		GlobalValue.level.high_light_aim_box(null)
	
	return aim_box

## 处理左右键
# 如果左键松开时鼠标悬停在aimbox上, 则获取该格为行动格
# 如果右键松开, 则回退本次行动
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("lmb"):
		if hovered_aim_box:
			if processing_player_action.action_type == Action.Type.MOVE:
				processing_player_action.execute([hovered_aim_box.get_grid_pos()])
				GlobalValue.level.clear_aim_box()
				processing_player_action = null
				processing_player_action_select_button = null
				deactivate()
			elif processing_player_action.action_type == Action.Type.ATTACK:
				# TODO: 检查玩家点击的格子到底能否攻击
				# 即: 是否有敌人
				if GlobalValue.level.check_gridpos_occupied(hovered_aim_box.get_grid_pos())==null:
					return
				else:
					processing_player_action.execute([hovered_aim_box.get_grid_pos()])
					GlobalValue.level.clear_aim_box()
					processing_player_action = null
					processing_player_action_select_button = null
					deactivate()
				pass

	elif event.is_action_released("rmb"):
		if processing_player_action:
			GlobalValue.level.clear_aim_box()
			processing_player_action_select_button.enable_button()
			deactivate()

## 取消选中当前行动
func cancel_action_selection():
	GlobalValue.level.clear_aim_box()
	if processing_player_action_select_button:
		processing_player_action_select_button.enable_button()
	deactivate()

## 用于行动和行动按钮注册自己
func register_action(action:PlayerAction, button:PlayerActionSelectButton):
	if processing_player_action:
		GlobalValue.level.clear_aim_box()
		processing_player_action_select_button.enable_button()
		processing_player_action = null
		processing_player_action_select_button = null
	processing_player_action = action
	processing_player_action_select_button = button
	activate()

## 用于行动按钮注册自己和行动
func register_action_button(button:PlayerActionSelectButton):
	register_action(button.player_action,button)

## 启用本节点, 开始监听玩家鼠标
func activate():
	var player : Player = get_tree().get_first_node_in_group("player")
	var color : Color
	match processing_player_action.action_type:
		# 攻击行为在所有有效格子上都放下了瞄准框
		# 至于玩家点击的瞄准框是否合格, 交由点击后的回调处理
		# 即 _unhandled_input() 负责检查点击的格子能否攻击
		Action.Type.ATTACK:
			color = AimBox.DEFAULT_COLOR.ORANGE
			for grid in processing_player_action.allowed_target_grids:
				if grid is Vector2i:
					var target_grid : Vector2i = grid + player.gridpos
					GlobalValue.level.set_aim_box(target_grid,color)
					
		Action.Type.MOVE:
			color = AimBox.DEFAULT_COLOR.BLUE
			for grid in processing_player_action.allowed_target_grids:
				if grid is Vector2i:
					var target_grid : Vector2i = grid + player.gridpos
					if not GlobalValue.level.check_gridpos_occupied(target_grid):
						GlobalValue.level.set_aim_box(target_grid,color)
		_:
			pass
	set_process_unhandled_input(true)
	is_activated = true

## 使本节点不活跃, 清空对行动和行动按钮的储存
func deactivate():
	is_activated = false
	processing_player_action = null
	processing_player_action_select_button = null
	set_process_unhandled_input(false)
