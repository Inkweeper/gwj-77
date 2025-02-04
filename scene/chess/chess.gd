extends Node3D
class_name Chess

signal hit_bounce_finished

# / export vars
@export var chess_name : String
@export_multiline var chess_info:String
# /

# / node references
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

# /

var face_to : Vector2 = Vector2.DOWN
var gridpos : Vector2i :
	get():
		var level : Level = GlobalValue.level
		var result : Vector2i
		var coord_3d : Vector3i = level.chessboard.local_to_map(position)
		result = Vector2i(coord_3d.x, coord_3d.z)
		return result
	set(v):
		var level : Level = GlobalValue.level
		position = level.grid_pos_to_position(v)


# HACK
#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("f1"):
		#print(gridpos)

func get_hit_bounce():
	mesh_instance_3d.scale = Vector3(1.2,1.2,1.2)
	var tween : Tween = create_tween()
	tween.tween_property(mesh_instance_3d,"scale",Vector3(1.0,1.0,1.0),0.4).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	await tween.finished
	hit_bounce_finished.emit()
	pass

func get_hit():
	$Area3D.set_deferred("monitorable",false)
	await get_tree().create_timer(0.0).timeout
	get_hit_bounce()
	await hit_bounce_finished
	var tween_flip := create_tween()
	tween_flip.tween_property($MeshInstance3D, "rotation",Vector3(0,0,PI),0.3).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	await tween_flip.finished
	await get_tree().create_timer(0.1).timeout
	queue_free()
