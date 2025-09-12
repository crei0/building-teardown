extends RigidBody3D
class_name BuildingBlock

@export var health: float = 100.0 : set = _set_health
@export var explosion_damage_curve: Curve # TODO: To use this for the damage fallof?

@onready var basic_cube_mesh: Node3D = %BasicCube_Mesh
@onready var center_marker_3d: Marker3D = %CenterMarker3D
@onready var ray_cast_3d_length: RayCast3D = %RayCast3D_Length
@onready var ray_cast_3d_width: RayCast3D = %RayCast3D_Width
@onready var ray_cast_3d_up: RayCast3D = %RayCast3D_Up
@onready var pin_joint_3d_length: PinJoint3D = %PinJoint3D_Length
@onready var pin_joint_3d_width: PinJoint3D = %PinJoint3D_Width
@onready var pin_joint_3d_up: PinJoint3D = %PinJoint3D_Up


func _set_health(new_health: float) -> void:
	health = roundf(new_health)
	
	if health < 1:
		queue_free()
		
		Globals.wake_up_rigid_bodies.emit()
	
	else:
		_update_color()
	

func _ready() -> void:
	_post_ready.call_deferred()
	
	Globals.wake_up_rigid_bodies.connect(_on_wake_up_rigid_bodies)


func _post_ready() -> void:
	health = health
	
	_detect_neighbours_and_connect_to_them()


func _update_color() -> void:
	return
	
	print("BuildingBlock > _update_color() > 20 > basic_cube_mesh = ", basic_cube_mesh)
	
	if basic_cube_mesh:
		var mesh_instance_3d: MeshInstance3D = basic_cube_mesh.get_child(0)
		
		print("BuildingBlock > _update_color() > 25")
		
		if mesh_instance_3d:
			var material: StandardMaterial3D = mesh_instance_3d.get_surface_override_material(0)
			
			print("BuildingBlock > _update_color() > 30")
				
			if material:
				material.albedo_color = Color.from_hsv(0, 1 - (health / 100), 1)
				
				print("BuildingBlock > _update_color() > 35")


func damage_from_explosion_position(explosion_position: Vector3) -> void:
	var distance: float = center_marker_3d.global_position.distance_squared_to(explosion_position)
	#print("distance > ", distance)
	
	var max_damage: float = 150.0
	var max_splash_damage_distance: float = 0.5
	
	#var damage = (100 / roundf(100 * distance)) * 100
	var damage: float = roundf(100 / distance) / 2
	#print("damage > ", damage)
	health -= damage
	
	#if distance < 1.0:
		#health = 100 - roundf(100 * distance)


func _detect_neighbours_and_connect_to_them() -> void:
	# length (positive X)
	ray_cast_3d_length.force_raycast_update()
	var target = ray_cast_3d_length.get_collider()
	
	if target is BuildingBlock:
		pin_joint_3d_length.node_b = target.get_path()
	
	# width (positive Z)
	ray_cast_3d_width.force_raycast_update()
	target = ray_cast_3d_width.get_collider()
	
	if target is BuildingBlock:
		pin_joint_3d_width.node_b = target.get_path()
	
	# up (positive Y)
	ray_cast_3d_up.force_raycast_update()
	target = ray_cast_3d_up.get_collider()
	
	if target is BuildingBlock:
		pin_joint_3d_up.node_b = target.get_path()
	
	target = null


func _on_wake_up_rigid_bodies() -> void:
	print("BuildingBlock > _on_wake_up_rigid_bodies() > 103")

	apply_impulse(Vector3.ZERO)
