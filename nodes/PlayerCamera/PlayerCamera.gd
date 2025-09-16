extends Node3D
class_name PlayerCamera

const RAY_LENGTH = 200.0
const MOUSE_SENSITIVITY = 0.005

@export var explosion_scene: PackedScene
@export_range(5, 250, 1) var distance: float = 20.0 : set = _set_distance
@export var explosions_container_node_3d: Node3D

@onready var camera_3d: Camera3D = %Camera3D
@onready var explosion_target: ExplosionTarget = %ExplosionTarget

var zoom: float = 5.0 : set = _set_zoom
var _is_mouse_left_being_pressed: bool = false
var _is_mouse_right_being_pressed: bool = false
var _explosion_global_position: Vector3 = Vector3.ZERO : set = _set_explosion_global_position


func _set_distance(new_distance: float) -> void:
	distance = clampf(new_distance, 5, 250)
	
	if camera_3d:
		camera_3d.z = distance


func _set_explosion_global_position(new_explosion_global_position: Vector3) -> void:
	_explosion_global_position = new_explosion_global_position
	
	explosion_target.global_position = _explosion_global_position
	explosion_target.visible = not _explosion_global_position.is_zero_approx()


func _set_zoom(new_zoom: float) -> void:
	zoom = clampf(new_zoom, 1, 20)
	
	camera_3d.position.z = zoom


func _input(event: InputEvent):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var worldspace: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
		var from:Vector3 = camera_3d.project_ray_origin(event.position)
		var end:Vector3 = from + camera_3d.project_ray_normal(event.position) * RAY_LENGTH
	
		var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, end)
		
		if query:
			var result = worldspace.intersect_ray(query)
			
			if result and result.position:
				_explosion_global_position = result.position
	
	if event.is_action_released("mouse_click_left"):
		#print("Player > event.is_action_released(mouse_click_left)")
		
		if explosions_container_node_3d:
			var explosion: ExplosionUsingArea2d = explosion_scene.instantiate()
			explosions_container_node_3d.add_child(explosion)
			explosion.explode_at_position(_explosion_global_position)
			
			_explosion_global_position = Vector3.ZERO
		
		else:
			push_error("`explosions_container_node_3d` was not found")
	
	## Camera Orbit
	if (
		Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and
		event is InputEventMouseMotion
	):
		rotation.y -= event.relative.x * MOUSE_SENSITIVITY
		rotation.x -= event.relative.y * MOUSE_SENSITIVITY

	if event.is_action_released("mouse_wheel_up"):
		zoom -= 1
	
	if event.is_action_released("mouse_wheel_down"):
		zoom += 1
