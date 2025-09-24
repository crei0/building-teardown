extends Node3D
class_name Sandbox


@onready var building_container_node_3d: Node3D = %BuildingContainerNode3D
@onready var explosions_container_node_3d: Node3D = %ExplosionsContainerNode3D

var _currently_active_building_type: Constants.BuildingType = Constants.BuildingType.EmpireState : set = _set_currently_active_building_type


#region Setters
func _set_currently_active_building_type(new_currently_active_building_type: Constants.BuildingType) -> void:
	_currently_active_building_type = new_currently_active_building_type
	
	print("Sandbox > _currently_active_building_type() > 15")
	
	if explosions_container_node_3d:
		for child in explosions_container_node_3d.get_children():
			explosions_container_node_3d.remove_child(child)
			
			child.queue_free()
	
	if building_container_node_3d:
		for child in building_container_node_3d.get_children():
			building_container_node_3d.remove_child(child)
			
			child.queue_free()
	
	var building_blocks_scene: PackedScene

	match _currently_active_building_type:
		Constants.BuildingType.Basic2x2x4:
			building_blocks_scene = load("uid://doy31kdmy5n76") # Basic_2x2x4.BuildingBlocksCollection

		Constants.BuildingType.BigBen:
			building_blocks_scene = load("uid://djchs68dhfu5c") # BigBen.BuildingBlocksCollection
		
		Constants.BuildingType.OldBridge:
			building_blocks_scene = load("uid://cht6hd4be5s18") # OldBridge.BuildingBlocksCollection
		
		Constants.BuildingType.EmpireState, \
		_:
			building_blocks_scene = load("uid://drdqkvu4bmpnj") # EmpireState.BuildingBlocksCollection
	
	if building_blocks_scene:
		var building_blocks_collection: BuildingBlocksCollection = building_blocks_scene.instantiate()
		
		if building_blocks_collection:
			building_container_node_3d.add_child(building_blocks_collection)

			Signals.building_recalculated_camera_position.emit()
#endregion


func _ready() -> void:
	Signals.building_currently_active_was_changed.connect(_on_building_currently_active_was_changed)
	
	_post_ready.call_deferred()


func _post_ready() -> void:
	_currently_active_building_type = _currently_active_building_type


func _on_building_currently_active_was_changed(target_building_type: Constants.BuildingType) -> void:
	_currently_active_building_type = target_building_type
