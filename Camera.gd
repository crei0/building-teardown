extends Camera3D
class_name Camera

const RAY_LENGTH = 200.0
const MOUSE_SENSITIVITY = 0.005

@onready var explosions_container_node_3d: Node3D = %ExplosionsContainerNode3D
@onready var camera_container: Node3D = %CameraContainer

@export var explosion_scene: PackedScene

var _is_camera_in_orbit_mode: bool = false


func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.is_action_released("mouse_click_right"):
			_is_camera_in_orbit_mode = false
		
		if event.is_action_pressed("mouse_click_right"):
			_is_camera_in_orbit_mode = true
		
		if event.is_action_pressed("mouse_click_left"):
			var worldspace: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
			var from:Vector3 = project_ray_origin(event.position)
			var end:Vector3 = from + project_ray_normal(event.position) * RAY_LENGTH
		
			var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, end)
			
			if query:
				var result = worldspace.intersect_ray(query)
				
				if result and result.position:
					var explosion: Explosion = explosion_scene.instantiate()
					explosions_container_node_3d.add_child(explosion)
					explosion.explode_at_position(result.position)
				
				# TODO: Fix this
	
	## Camera Orbit
	if (
		_is_camera_in_orbit_mode and
		event is InputEventMouseMotion
	):
		camera_container.rotation.y -= event.relative.x * MOUSE_SENSITIVITY
		camera_container.rotation.x -= event.relative.y * MOUSE_SENSITIVITY
