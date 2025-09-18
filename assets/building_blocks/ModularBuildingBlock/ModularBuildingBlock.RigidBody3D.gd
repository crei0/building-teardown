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
@onready var center_marker_3d: Marker3D = %CenterMarker3D # TODO: Replace this with calculation of AABB or CollisionShape?

var _mesh: Node3D


func _set_health(new_health: float) -> void:
	health = roundf(new_health)
	
	if health < 1:
		queue_free()
		
		Globals.wake_up_rigid_bodies.emit()
	
	else:
		_update_color()


func _set_neighbours(new_neighbours: ModularBuildingBlockNeighbours) -> void:
	neighbours = new_neighbours
	
	if pin_joint_3d_x_red_depth:
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
	
	_mesh = get_child(get_child_count() - 1)


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


func _update_color() -> void:
	return
	
	#print("ModularBuildingBlock > _update_color() > 99 > _mesh = ", _mesh)
	#
	#if _mesh:
		#var mesh_instance_3d: MeshInstance3D = _mesh.get_child(0)
		#
		#print("ModularBuildingBlock > _update_color() > 104")
		#
		#if mesh_instance_3d:
			#var material: StandardMaterial3D = mesh_instance_3d.get_surface_override_material(0)
			#
			#print("ModularBuildingBlock > _update_color() > 109")
				#
			#if material:
				#material.albedo_color = Color.from_hsv(0, 1 - (health / 100), 1)
				#
				#print("ModularBuildingBlock > _update_color() > 114")


func damage_from_explosion_position(explosion_position: Vector3) -> void:
	var distance: float = center_marker_3d.global_position.distance_squared_to(explosion_position)
	print("distance > ", distance)
	
	#var max_damage: float = 150.0
	#var max_splash_damage_distance: float = 0.5
	
	#var damage = (100 / roundf(100 * distance)) * 100
	var damage: float = roundf(100 / distance) / 2
	#print("damage > ", damage)
	health -= damage
	
	#if distance < 1.0:
		#health = 100 - roundf(100 * distance)
