extends State
#failure

func initialize():
	var level : Level = $"../.."
	level.rewind_request.connect(_on_rewind_request)
	pass

func enter():
	$"../../WinLoseInfoLayer/LosePanel".activate()
	pass

func exit():
	pass

func update(delta:float):
	pass

func _on_rewind_request():
	if state_machine.current_state != self:
		return
	GlobalValue.level.rewind_to_turn_start()
	$"../../WinLoseInfoLayer/LosePanel".deactivate()
	transitioned.emit(self,"RewindTurnStart")
	pass
