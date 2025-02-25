extends State

var allow_rewind : bool = false

func initialize():
	EventBus.transform_ready.connect(_on_transform_ready)
	pass

func enter():
	allow_rewind = false
	GlobalValue.level.register_chess_status_this_turn()
	GlobalValue.level.ask_for_morph()
	allow_rewind = true
	# HACK
	#await get_tree().create_timer(3).timeout
	
	# HACK
	#transitioned.emit(self, "PlayerTurn")
	pass

func exit():
	allow_rewind = false
	pass

func update(delta:float):
	pass

func _on_transform_ready():
	transitioned.emit(self, "PlayerTurn")


func _on_ingame_rewind_button_pressed() -> void:
	if state_machine.current_state != self:
		return
	if not allow_rewind:
		return
	allow_rewind = false
	GlobalValue.level.rewind_to_last_turn()
	transitioned.emit(self,"RewindTurnStart")
