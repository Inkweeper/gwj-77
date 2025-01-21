extends State

var player : Player

func initialize():
	player = get_tree().get_first_node_in_group("player")
	pass

func enter():
	#print("player turn")
	GlobalValue.level.get_player_action_list()
	GlobalValue.level.show_action_list()
	pass

func exit():
	pass

func update(delta:float):
	pass
