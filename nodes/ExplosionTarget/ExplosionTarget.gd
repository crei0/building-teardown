extends Node3D
class_name ExplosionTarget


@export var explosion_size_multiplier: int = 1 : set = _set_explosion_size_multiplier
@export var player_camera: PlayerCamera

func _set_explosion_size_multiplier(new_explosion_size_multiplier: int) -> void:
	explosion_size_multiplier = new_explosion_size_multiplier

	scale = Vector3.ONE * explosion_size_multiplier


func _ready() -> void:
	explosion_size_multiplier = explosion_size_multiplier
	
	Signals.explosion_size_multiplier_changed.connect(_on_explosion_size_changed)


func _physics_process(delta: float) -> void:
	if player_camera:
		look_at(player_camera.camera_3d.global_position)


func _on_explosion_size_changed(new_explosion_size_multiplier: int) -> void:
	explosion_size_multiplier = new_explosion_size_multiplier
