extends RigidBody3D
class_name ModularBuildingBlock

var neighbours: ModularBuildingBlockNeighbours = null : set = _set_neighbours

@onready var ray_cast_3d_x_red_depth: RayCast3D = %"RayCast3D-X-Red-Depth"
@onready var ray_cast_3d_y_green_height: RayCast3D = %"RayCast3D-Y-Green-Height"
@onready var ray_cast_3d_z_blue_width: RayCast3D = %"RayCast3D-Z-Blue-Width"
@onready var pin_joint_3d_x_red_depth: PinJoint3D = %"PinJoint3D-X-Red-Depth"
@onready var pin_joint_3d_y_green_height: PinJoint3D = %"PinJoint3D-Y-Green-Height"
@onready var pin_joint_3d_z_blue_width: PinJoint3D = %"PinJoint3D-Z-Blue-Width"


func _set_neighbours(new_neighbours: ModularBuildingBlockNeighbours) -> void:
	neighbours = new_neighbours
	
	# X | Depth
	if !neighbours.neighbour_x_red_depth:
		pin_joint_3d_x_red_depth.node_a = ""
		pin_joint_3d_x_red_depth.node_b = ""
		
	else:
		print("ModularBuildingBlock > _set_neighbours() > found neighbours.neighbour_x_red_depth")
		pin_joint_3d_x_red_depth.node_a = get_path()
		pin_joint_3d_x_red_depth.node_b = neighbours.neighbour_x_red_depth.get_path()
	
	# Y | Height
	if !neighbours.neighbour_y_green_height:
		pin_joint_3d_y_green_height.node_a = ""
		pin_joint_3d_y_green_height.node_b = ""
		
	else:
		print("ModularBuildingBlock > _set_neighbours() > found neighbours.pin_joint_3d_y_green_height")
		pin_joint_3d_y_green_height.node_a = get_path()
		pin_joint_3d_y_green_height.node_b = neighbours.neighbour_y_green_height.get_path()
	
	# Z | Width
	if !neighbours.neighbour_z_blue_width:
		pin_joint_3d_z_blue_width.node_a = ""
		pin_joint_3d_z_blue_width.node_b = ""
		
	else:
		print("ModularBuildingBlock > _set_neighbours() > found neighbours.pin_joint_3d_z_blue_width")
		pin_joint_3d_z_blue_width.node_a = get_path()
		pin_joint_3d_z_blue_width.node_b = neighbours.neighbour_z_blue_width.get_path()


func _ready() -> void:
	_post_ready.call_deferred()


func _post_ready() -> void:
	neighbours = find_neighbours()


func find_neighbours() -> ModularBuildingBlockNeighbours:
	var new_neighbours: ModularBuildingBlockNeighbours = ModularBuildingBlockNeighbours.new()
	
	new_neighbours.neighbour_x_red_depth = _find_neighbour_using_raycast(ray_cast_3d_x_red_depth)
	new_neighbours.neighbour_y_green_height = _find_neighbour_using_raycast(ray_cast_3d_x_red_depth)
	new_neighbours.neighbour_z_blue_width = _find_neighbour_using_raycast(ray_cast_3d_z_blue_width)
	
	return new_neighbours


func _find_neighbour_using_raycast(ray_cast_3d: RayCast3D) -> ModularBuildingBlock:
		# TODO: Test this
		
		if get_colliding_bodies().size():
			print("ModularBuildingBlock > _find_neighbour_using_raycast() > get_colliding_bodies().size() = ", get_colliding_bodies().size())
			
		
		for colliding_body in get_colliding_bodies():
			if colliding_body is ModularBuildingBlock:
				print("ModularBuildingBlock > _find_neighbour_using_raycast() > found colliding_body = ", colliding_body)
				
				return colliding_body
		
		return null
