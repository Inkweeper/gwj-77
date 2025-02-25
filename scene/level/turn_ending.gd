extends State

func initialize():
	pass

func enter():
	
	var player: Player = get_tree().get_first_node_in_group("player")
	#GlobalValue.level.current_transform_permissions.erase(player.current_form)
	player.morph(Player.Form.CHANGELING)
	transitioned.emit(self,"PlayerTurnStart")
	pass

func exit():
	pass

func update(delta:float):
	pass
