extends State

func initialize():
	EventBus.transform_ready.connect(_on_transform_ready)
	pass

func enter():
	await get_tree().create_timer(0.1).timeout
	GlobalValue.level.register_chess_status_this_turn()
	GlobalValue.level.ask_for_morph()
	# HACK
	#await get_tree().create_timer(3).timeout
	
	# HACK
	#transitioned.emit(self, "PlayerTurn")
	pass

func exit():
	pass

func update(delta:float):
	pass

func _on_transform_ready():
	transitioned.emit(self, "PlayerTurn")
