extends Node3D
class_name BuildingBlocksCollection

@export var length: int = 4
@export var width: int = 2
@export var height: int = 3


func _ready() -> void:
	_post_ready.call_deferred()


func _post_ready() -> void:
	_generate_joints()


func _generate_joints() -> void:
	for child in get_children():
		if child is ModularBuildingBlock:
			print("BuildingBlocksCollection > _generate_joints > child = ", child.name)
