extends Node3D
class_name Level

# /statics and consts
const CHESSBOARD_GRID_SIZE : Vector2 = Vector2(4.0 , 4.0)
# /

# /export vars
@export var chessboard_size : Vector2i
@export var total_transform_permissions : Array[Player.Form]
# /

# /node reference
@onready var statemachine: Statemachine = $Statemachine
@onready var chess_container: Node = $ChessContainer
@onready var chessboard: GridMap = $Chessboard
@onready var camera_3d: LevelCamera = $Camera3D
@onready var aim_box_container: Node = $AimBoxContainer


@onready var transform_select_panel: PanelContainer = $CanvasLayer/TransformSelectPanel
@onready var action_select_panel: PanelContainer = $CanvasLayer/ActionSelectPanel

# /

var current_transform_permissions : Array[Player.Form] = []
var chessboard_history_list : Array[ChessboardHistory] = []


## 当玩家按下倒带按钮时发出,由状态机判断当前情况并执行正确的倒带操作
signal rewind_request


func _ready() -> void:
	GlobalValue.level = self
	statemachine.initialize()
	# HACK
	#print(chessboard.local_to_map(Vector3(0.1,0.05,0.1)))
	#print(chessboard.map_to_local(Vector3i(0,0,0)))

func _process(delta: float) -> void:
	statemachine.update(delta)

## 游戏开始时的预设定
func new_level():
	chessboard_history_list.clear()
	current_transform_permissions = total_transform_permissions.duplicate()
	camera_3d.max_pos_bounds = Vector2(chessboard_size.x*4.0, chessboard_size.y*6.0)
	camera_3d.position.y = 20.0
	camera_3d.position.x = camera_3d.min_pos_bounds.x + 0.4*(camera_3d.max_pos_bounds.x-camera_3d.min_pos_bounds.x)
	camera_3d.position.z = camera_3d.min_pos_bounds.y + 0.6*(camera_3d.max_pos_bounds.y-camera_3d.min_pos_bounds.y)
	pass

## 记录本回合的棋子状态和剩余可变形列表
func register_chess_status_this_turn():
	var chess_status_list : Array[ChessStatus] = []
	for chess in chess_container.get_children():
		if chess is Chess:
			var chess_status : ChessStatus = ChessStatus.new()
			# get interested info of a chess and save it
			chess_status.face_to = chess.face_to
			chess_status.chess_name = chess.chess_name
			chess_status.grid_pos = chess.gridpos
			
			chess_status_list.append(chess_status)
			
	var chessboard_history : ChessboardHistory = ChessboardHistory.new()
	chessboard_history.chess_status_list = chess_status_list
	chessboard_history.transform_permissions = current_transform_permissions.duplicate()
	
	chessboard_history_list.append(chessboard_history)
	



# /PlayerTurnStart

## 弹出变形选择窗口
func ask_for_morph():
	var transform_list : Array = current_transform_permissions.duplicate()
	# get the reference of transform selection container
	var morph_button_container: HBoxContainer = $CanvasLayer/TransformSelectPanel/VBoxContainer/HBoxContainer
	
	# add transform buttons
	for child in morph_button_container.get_children():
		child.queue_free()
	
	transform_select_panel.show()
	
	var no_transform_select_button : TransformSelectButton = preload("res://scene/level/ui/transform_select_button/transform_select_button.tscn").instantiate()
	no_transform_select_button.set_form(Player.Form.CHANGELING)
	
	morph_button_container.add_child(no_transform_select_button)
	
	
	for form in transform_list:
		if form is Player.Form:
			var transform_select_button : TransformSelectButton = preload("res://scene/level/ui/transform_select_button/transform_select_button.tscn").instantiate()
			transform_select_button.set_form(form)
			morph_button_container.add_child(transform_select_button)
	
	
	var tween : Tween = create_tween()
	tween.tween_property(transform_select_panel, "position", Vector2(352,524),0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await tween.finished
	
	if not EventBus.form_decided.is_connected(decide_morph):
		EventBus.form_decided.connect(decide_morph)
	# HACK
	
	pass

## 接收来自变形选择窗口的信号, 传递给玩家进行变形
func decide_morph(form:Player.Form):
	EventBus.form_decided.disconnect(decide_morph)
	
	current_transform_permissions.erase(form)
	
	var player : Player = get_tree().get_first_node_in_group("player")
	
	var tween : Tween = create_tween()
	tween.tween_property(transform_select_panel, "position", Vector2(1152,524),0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	await tween.finished
	
	var morph_button_container: Container = $CanvasLayer/TransformSelectPanel/VBoxContainer/HBoxContainer
	for child in morph_button_container.get_children():
		child.queue_free()
	
	transform_select_panel.hide()
	
	player.morph(form)

# /

# /PlayerTurn

## 复制并保存本形态行动列表, 以供后续选用
var player_action_list : Array = []
func get_player_action_list():
	var player : Player = get_tree().get_first_node_in_group("player")
	player_action_list = player.get_action_list()

## 将本形态行动列表用ui展示
func show_action_list():
	action_select_panel.show()
	var action_button_container : HBoxContainer = $CanvasLayer/ActionSelectPanel/VBoxContainer/HBoxContainer
	
	for child in action_button_container.get_children():
		child.queue_free()
	
	for player_action in player_action_list:
		if player_action is PlayerAction:
			var button : PlayerActionSelectButton = preload("res://scene/level/ui/player_action_select_button/player_action_select_button.tscn").instantiate()
			button.player_action = player_action
			action_button_container.add_child(button)
		
	
	var end_turn_button : EndTurnButton = preload("res://scene/level/ui/end_turn_button/end_turn_button.tscn").instantiate()
	action_button_container.add_child(end_turn_button)
	
	var tween : Tween = create_tween()
	tween.tween_property(action_select_panel, "position", Vector2(352,524),0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await tween.finished

## 隐藏行动列表ui
func hide_action_list():
	var action_button_container : HBoxContainer = $CanvasLayer/ActionSelectPanel/VBoxContainer/HBoxContainer
	for child in action_button_container.get_children():
		if child is PlayerActionSelectButton:
			child.disable_button()
	
	var tween : Tween = create_tween()
	tween.tween_property(action_select_panel, "position", Vector2(1152,524),0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	await tween.finished
	
	for child in action_button_container.get_children():
		child.queue_free()
	action_select_panel.hide()
# /

## 将游戏场景恢复到本回合开始时的状态,根据历史表摆放好棋子即可
func rewind_to_turn_start():
	for chess in chess_container.get_children():
		if chess is Chess:
			chess.queue_free()
	var chess_board_history : ChessboardHistory = chessboard_history_list.back() as ChessboardHistory
	var transform_permissions := chess_board_history.transform_permissions
	current_transform_permissions = transform_permissions
	var chess_status_list := chess_board_history.chess_status_list
	for chess_status in chess_status_list:
		var status := chess_status as ChessStatus
		var chess : Chess = GlobalValue.chess_configuration[status.chess_name].instantiate()
		chess_container.add_child(chess)
		chess.gridpos = status.grid_pos
		chess.face_to = status.face_to

## 将游戏场景恢复到上一个回合开始时的状态,根据历史表摆放好棋子即可
func rewind_to_last_turn():
	if chessboard_history_list.size()==1:
		rewind_to_turn_start()
		return
	for chess in chess_container.get_children():
		if chess is Chess:
			chess.queue_free()
	chessboard_history_list.pop_back()
	var chess_board_history : ChessboardHistory = chessboard_history_list.back() as ChessboardHistory
	var transform_permissions := chess_board_history.transform_permissions
	current_transform_permissions = transform_permissions
	var chess_status_list := chess_board_history.chess_status_list
	for chess_status in chess_status_list:
		var status := chess_status as ChessStatus
		var chess : Chess = GlobalValue.chess_configuration[status.chess_name].instantiate()
		chess_container.add_child(chess)
		chess.gridpos = status.grid_pos
		chess.face_to = status.face_to

## 将gridpos:Vector2i转换为gridmap的Vector3i
func grid_pos_to_grid_map_pos(grid_pos : Vector2i)->Vector3i:
	return Vector3i(grid_pos.x,0,grid_pos.y)

## 将gridpos:Vector2i转换为Y轴归零的空间Vector3点位
func grid_pos_to_position(grid_pos:Vector2i)->Vector3:
	var gridmap_pos : Vector3i = grid_pos_to_grid_map_pos(grid_pos)
	var gridmap_grid_position : Vector3 = chessboard.map_to_local(gridmap_pos) + chessboard.global_position
	return Vector3(gridmap_grid_position.x, 0.0, gridmap_grid_position.z)

## @deprecated: 旧有的试图使用改变gridmap棋盘格实现瞄准的方法, 推荐改用向aim_box_container放置mesh实现瞄准 
func set_grid(grid_pos : Vector2i, mesh_id : int):
	var grid_map_pos : Vector3i = grid_pos_to_grid_map_pos(grid_pos)
	var cell_item_id = chessboard.get_cell_item(grid_map_pos)
	if cell_item_id != chessboard.INVALID_CELL_ITEM and mesh_id != chessboard.INVALID_CELL_ITEM:
		chessboard.set_cell_item(grid_map_pos,mesh_id)


## 检查某格在不在棋盘上
func check_grid_pos_validity(grid_pos : Vector2i)->bool:
	var grid_map_pos : Vector3i = grid_pos_to_grid_map_pos(grid_pos)
	var cell_item_id = chessboard.get_cell_item(grid_map_pos)
	if cell_item_id != chessboard.INVALID_CELL_ITEM:
		return true
	else:
		return false

## 在某格放置瞄准框
func set_aim_box(grid_pos : Vector2i, color : Color):
	if not check_grid_pos_validity(grid_pos):
		return
	var grid_map_pos: Vector3i = grid_pos_to_grid_map_pos(grid_pos)
	var aim_box : AimBox = preload("res://scene/aim_box/AimBox.tscn").instantiate()
	aim_box_container.add_child(aim_box)
	aim_box.set_color(color)
	aim_box.global_position = chessboard.map_to_local(grid_map_pos)

## 清空所有瞄准框
func clear_aim_box():
	for child in aim_box_container.get_children():
		if child is AimBox:
			child.queue_free()

## 高亮指定瞄准框, 并且使其他瞄准框变暗
func high_light_aim_box(aim_box : AimBox):
	if aim_box:
		aim_box.on_hovered()
		for box in aim_box_container.get_children():
			if box != aim_box:
				if box is AimBox : box.on_unhovered()
	else:
		for box in aim_box_container.get_children():
			if box is AimBox:
				box.on_unhovered()

## 获取玩家的gridpos: Vector2i
func get_player_gridpos()->Vector2i:
	var player :Player = get_tree().get_first_node_in_group("player")
	return player.gridpos

## 检查某个gridpos上是否有其他棋子, 如果没有, 返回null
func check_gridpos_occupied(gridpos:Vector2i)->Chess:
	#TODO
	# 假定每个棋子至少Y轴高0.2
	var check_point_height : float = 0.2
	var check_point_position : Vector3 = grid_pos_to_position(gridpos)
	check_point_position.y = check_point_height
	
	var space :PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var parameter := PhysicsPointQueryParameters3D.new()
	# chess用area标识自身碰撞
	parameter.collide_with_areas = true
	parameter.collide_with_bodies = false
	parameter.collision_mask = 1<<2 # ?
	parameter.position = check_point_position
	
	var result := space.intersect_point(parameter,1)
	if result.size() == 0:
		return null
	else:
		return result[0].collider.owner as Chess
	return null


#HACK: f1检查方法是否正常运行
#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("f1"):
		#print(check_gridpos_occupied(Vector2i(3,0)))
