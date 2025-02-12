extends State

var player : Player

@onready var player_action_monitor_timer: Timer = $PlayerActionMonitorTimer

func initialize():
	player = get_tree().get_first_node_in_group("player")
	EventBus.player_end_turn.connect(_on_player_end_turn)
	pass

func enter():
	#print("player turn")
	await get_tree().create_timer(0.2).timeout
	GlobalValue.level.get_player_action_list()
	GlobalValue.level.show_action_list()
	pass

func exit():
	pass

func update(delta:float):
	pass

func _on_player_end_turn():
	GlobalValue.level.clear_aim_box()
	GlobalValue.level.hide_action_list()
	PlayerActionManager.deactivate()
	
	monitor_if_player_is_acting_and_trans_to_enemy_turn()

func monitor_if_player_is_acting_and_trans_to_enemy_turn():
	while(PlayerActionManager.player_is_acting == true):
		player_action_monitor_timer.start(0.1)
		await player_action_monitor_timer.timeout
	transitioned.emit(self,"EnemyTurn")

func _on_ingame_rewind_button_pressed() -> void:
	if state_machine.current_state != self:
		return
	GlobalValue.level.rewind_to_turn_start()
	transitioned.emit(self,"RewindTurnStart")
