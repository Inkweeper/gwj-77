extends Control
class_name Cutscene

@onready var texture_rect: TextureRect = $ColorRect/VBoxContainer/CenterContainer/TextureRect
@onready var label: Label = $ColorRect/VBoxContainer/CenterContainer2/Label

@export var cutscene_entry_list : Array[CutsceneEntryRes] = []
@export var next_scene_path : String

var started : bool = false
var line_playing : bool = false

var tween : Tween

func _ready() -> void:
	EventBus.scene_changed_ready.connect(start_play)
	await get_tree().create_timer(0.8).timeout
	if not started:
		start_play()
	pass

func start_play():
	if started: return
	started = true
	
	display_nextline()
	pass

func display_nextline():
	if line_playing:
		tween.kill()
		label.visible_characters = -1
		line_playing = false
		return
	var entry : CutsceneEntryRes = cutscene_entry_list.pop_front()
	if entry == null:
		SceneChanger.change_scene_to_path(next_scene_path)
		return
	line_playing = true
	label.visible_characters = 0
	label.text = entry.text
	if entry.texture != null:
		texture_rect.texture = entry.texture
	#HACK bgm and se
	#...
	if tween: tween.kill()
	tween = create_tween()
	tween.set_loops()
	tween.tween_interval(0.03)
	tween.tween_callback(
		func ():
			if label.visible_characters < len(tr(entry.text)):
				label.visible_characters += 1
			else :
				tween.kill()
				line_playing = false
	)


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("lmb"):
		display_nextline()
