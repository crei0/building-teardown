extends StaticBody3D

# TODO: To remove
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("keyboard_space"):
		animation_player.play("new_animation")
