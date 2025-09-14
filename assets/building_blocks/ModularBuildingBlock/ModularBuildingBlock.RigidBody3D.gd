extends RigidBody3D
class_name ModularBuildingBlock

var neighbours: ModularBuildingBlockNeighbours

@onready var ray_cast_3d_x_red_depth: RayCast3D = %"RayCast3D-X-Red-Depth"
@onready var ray_cast_3d_y_green_height: RayCast3D = %"RayCast3D-Y-Green-Height"
@onready var ray_cast_3d_z_blue_width: RayCast3D = %"RayCast3D-Z-Blue-Width"


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
		# TODO: Test
		
		for colliding_body in get_colliding_bodies():
			if colliding_body is ModularBuildingBlock:
				return colliding_body
		
		return null
