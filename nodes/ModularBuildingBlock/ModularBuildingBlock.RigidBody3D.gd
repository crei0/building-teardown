extends RigidBody3D
class_name ModularBuildingBlock


@export var health: float = 100.0 : set = _set_health
@export var neighbours: ModularBuildingBlockNeighbours = null : set = _set_neighbours

@onready var ray_cast_3d_x_red_depth: RayCast3D = %"RayCast3D-X-Red-Depth"
@onready var ray_cast_3d_y_green_height: RayCast3D = %"RayCast3D-Y-Green-Height"
@onready var ray_cast_3d_z_blue_width: RayCast3D = %"RayCast3D-Z-Blue-Width"
@onready var pin_joint_3d_x_red_depth: PinJoint3D = %"PinJoint3D-X-Red-Depth"
@onready var pin_joint_3d_y_green_height: PinJoint3D = %"PinJoint3D-Y-Green-Height"
@onready var pin_joint_3d_z_blue_width: PinJoint3D = %"PinJoint3D-Z-Blue-Width"

var _mesh: Node3D


#region Setters
func _set_health(new_health: float) -> void:
	health = roundf(new_health)
	
	if health < 1:
		queue_free()
		
		Signals.wake_up_rigid_bodies.emit()
	
	else:
		_update_color()


func _set_neighbours(new_neighbours: ModularBuildingBlockNeighbours) -> void:
	neighbours = new_neighbours
	
	if pin_joint_3d_x_red_depth:
		# print("ModularBuildingBlock > _set_neighbours() > neighbours.neighbour_x_red_depth = ", neighbours.neighbour_x_red_depth)
		
		# X | Depth
		if !neighbours.neighbour_x_red_depth:
			pin_joint_3d_x_red_depth.node_a = ""
			pin_joint_3d_x_red_depth.node_b = ""
			
		else:
			#print("ModularBuildingBlock > _set_neighbours() > found neighbours.neighbour_x_red_depth")
			pin_joint_3d_x_red_depth.node_a = get_path()
			pin_joint_3d_x_red_depth.node_b = neighbours.neighbour_x_red_depth.get_path()
		
		# Y | Height
		if !neighbours.neighbour_y_green_height:
			pin_joint_3d_y_green_height.node_a = ""
			pin_joint_3d_y_green_height.node_b = ""
			
		else:
			#print("ModularBuildingBlock > _set_neighbours() > found neighbours.pin_joint_3d_y_green_height")
			pin_joint_3d_y_green_height.node_a = get_path()
			pin_joint_3d_y_green_height.node_b = neighbours.neighbour_y_green_height.get_path()
		
		# Z | Width
		if !neighbours.neighbour_z_blue_width:
			pin_joint_3d_z_blue_width.node_a = ""
			pin_joint_3d_z_blue_width.node_b = ""
			
		else:
			#print("ModularBuildingBlock > _set_neighbours() > found neighbours.pin_joint_3d_z_blue_width")
			pin_joint_3d_z_blue_width.node_a = get_path()
			pin_joint_3d_z_blue_width.node_b = neighbours.neighbour_z_blue_width.get_path()
#endregion


func _ready() -> void:
	_post_ready.call_deferred()


func _post_ready() -> void:
	neighbours = find_neighbours()
	
	_mesh = get_child(get_child_count() - 1)


func find_neighbours() -> ModularBuildingBlockNeighbours:
	var new_neighbours: ModularBuildingBlockNeighbours = ModularBuildingBlockNeighbours.new()
	
	new_neighbours.neighbour_x_red_depth = _find_neighbour_using_raycast(ray_cast_3d_x_red_depth)
	new_neighbours.neighbour_y_green_height = _find_neighbour_using_raycast(ray_cast_3d_x_red_depth)
	new_neighbours.neighbour_z_blue_width = _find_neighbour_using_raycast(ray_cast_3d_z_blue_width)
	
	return new_neighbours


func _find_neighbour_using_raycast(ray_cast_3d: RayCast3D) -> ModularBuildingBlock:
		#print("ModularBuildingBlock > _find_neighbour_using_raycast() > get_colliding_bodies().size() = ", get_colliding_bodies().size())
		var colliding_modular_building_block: ModularBuildingBlock = ray_cast_3d.get_collider()
		
		return colliding_modular_building_block


func _update_color() -> void:
	if _mesh:
		var mesh_instance_3d: MeshInstance3D = _mesh.get_child(0)
		
		if mesh_instance_3d:
			var material: StandardMaterial3D = mesh_instance_3d.get_surface_override_material(0)
			
			if material:
				material.albedo_color = Color.from_hsv(0, 1 - (health / 100), 1)


func damage_from_explosion_position(explosion_transform: Transform3D, explosion_size_multiplier: int) -> void:
	var distance: float = global_position.distance_squared_to(explosion_transform.origin)

	var damage: float = roundf(Constants.MAX_EXPLOSION_DAMAGE / distance) / 2 * explosion_size_multiplier
	
	health -= damage
