extends Node3D
class_name ExplosionTarget


@export var explosion_size: int = 1 : set = _set_explosion_size


func _set_explosion_size(new_explosion_size: int) -> void:
	explosion_size = new_explosion_size

	scale = Vector3.ONE * Globals.BASE_EXPLOSION_SCALE * explosion_size


func _ready() -> void:
	explosion_size = explosion_size
	
	Globals.explosion_size_multiplier_changed.connect(_on_explosion_size_changed)


func _on_explosion_size_changed(new_explosion_size_multiplier: int) -> void:
	explosion_size = new_explosion_size_multiplier
