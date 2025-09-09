extends StaticBody3D
class_name Explosion

@onready var animation_player: AnimationPlayer = %AnimationPlayer


func explode_at_position(position: Vector3) -> void:
	global_position = position
	
	if animation_player:
		animation_player.play("explosion_start")
