extends Node3D

@onready var static_body_3d: StaticBody3D = %StaticBody3D
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	animation_player.play("left_and_right")


#func _physics_process(delta: float) -> void:
	#var movement: Vector2 = Input.get_vector("keyboard-move-left", "keyboard-move-right", "keyboard-move-down","keyboard-move-up")
	#
	#var movement_v3: Vector3 = Vector3(movement.x, movement.y, 0)
	#
	#static_body_3d.move_and_collide(movement_v3)
