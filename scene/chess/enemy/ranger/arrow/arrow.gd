extends Node3D
class_name Arrow

signal hit_player

const speed : float = 20.0

var is_flying: bool = true

var direction : Vector2:
	set(v):
		direction = v.normalized()

func _ready() -> void:
	look_at(Vector3(direction.x,0,direction.y),Vector3(0,1,0),true)

func fly(delta:float):
	position += Vector3(direction.x,0,direction.y) * delta * speed

func _physics_process(delta: float) -> void:
	if is_flying: 
		fly(delta)

func _on_area_3d_area_entered(area: Area3D) -> void:
	var chess := area.owner
	if chess is Chess:
		if chess.is_in_group("player"):
			is_flying = false
			$Area3D.set_deferred("monitoring",false)
			hit_player.emit()
			var player := chess as Player
			player.get_hit()
			await get_tree().create_timer(0.8).timeout
			queue_free()
