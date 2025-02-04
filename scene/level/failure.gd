extends State
#failure

func initialize():
	var level : Level = $"../.."
	level.rewind_request.connect(_on_rewind_request)
	pass

func enter():
	print("failure")
	$"../../WinLoseInfoLayer/LosePanel".activate()
	pass

func exit():
	pass

func update(delta:float):
	pass

func _on_rewind_request():
	GlobalValue.level.rewind_to_turn_start()
	pass
