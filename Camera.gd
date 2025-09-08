extends Camera3D
class_name Camera

const RAY_LENGTH = 1000.0
const MOUSE_SENSITIVITY = 0.005

@onready var explosions_container_node_3d: Node3D = %ExplosionsContainerNode3D
@onready var camera_container: Node3D = %CameraContainer

@export var explosion_scene: PackedScene


func _unhandled_input(event: InputEvent) -> void:
	# Camera Orbit
	if (
		camera_container and
		event is InputEventMouseMotion
	):
		camera_container.rotation.y -= event.relative.x * MOUSE_SENSITIVITY
		camera_container.rotation.x -= event.relative.y * MOUSE_SENSITIVITY


func _input(event):
	if (
		event is InputEventMouseButton and 
		event.pressed and
		event.button_index == MOUSE_BUTTON_LEFT
	):
		var worldspace: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
		var from:Vector3 = project_ray_origin(event.position)
		var target:Vector3 = from + project_ray_normal(event.position) * RAY_LENGTH
	
		print("click target", target)
		
		for child in explosions_container_node_3d.get_children():
			explosions_container_node_3d.remove_child(child)
			child.queue_free()
			
		var explosion: Explosion = explosion_scene.instantiate()
		explosion.global_position = target
		explosions_container_node_3d.add_child(explosion)
		
		# TODO: Fix this
