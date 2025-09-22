extends Node3D
class_name Sandbox

@onready var building_container_node_3d: Node3D = %BuildingContainerNode3D


var _currently_active_building_type: Globals.BuildingType = Globals.BuildingType.EmpireState : set = _set_currently_active_building_type


#region Setters
func _set_currently_active_building_type(new_currently_active_building_type: Globals.BuildingType) -> void:
	_currently_active_building_type = new_currently_active_building_type
	
	for child in building_container_node_3d.get_children():
		building_container_node_3d.remove_child(child)
		
		child.queue_free()
	
	var building_blocks_scene: PackedScene

	match _currently_active_building_type:
		Globals.BuildingType.Basic2x2x4:
			building_blocks_scene = load("res://nodes/BuildingBlocksCollection/Types/Basic_2x2x4.BuildingBlocksCollection.tscn")

		Globals.BuildingType.BigBen:
			building_blocks_scene = load("res://nodes/BuildingBlocksCollection/Types/BigBen.BuildingBlocksCollection.tscn")
		
		Globals.BuildingType.OldBridge:
			building_blocks_scene = load("res://nodes/BuildingBlocksCollection/Types/OldBridge.BuildingBlocksCollection.tscn")

		Globals.BuildingType.EmpireState, \
		_:
			building_blocks_scene = load("res://nodes/BuildingBlocksCollection/Types/EmpireState.BuildingBlocksCollection.tscn")

	
	if building_blocks_scene:
		building_container_node_3d.add_child(building_blocks_scene.instantiate())
#endregion


func _ready() -> void:
	Globals.building_currently_active_was_changed.connect(_on_building_currently_active_was_changed)

	Globals.building_currently_active_was_changed.emit(Globals.BuildingType.EmpireState)


func _on_building_currently_active_was_changed(target_building_type: Globals.BuildingType) -> void:
	_currently_active_building_type = target_building_type
