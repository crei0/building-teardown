extends Node3D
class_name PlayerCamera


const RAY_LENGTH: float = 200.0
const MOUSE_SENSITIVITY: float = 0.005
const MOUSE_ZOOM_DELTA: float = 0.5
const ZOOM_LERP_SPEED: float = 25.0

@export var explosion_scene: PackedScene
@export_range(5, 250, 1) var distance: float = 20.0 : set = _set_distance
@export var explosions_container_node_3d: Node3D
@export var building_container_node_3d: Node3D : set = _set_building_container_node_3d

@onready var camera_3d: Camera3D = %Camera3D
@onready var explosion_target: ExplosionTarget = %ExplosionTarget
@onready var building_label: Label = %BuildingLabel

var zoom: float = 5.0 : set = _set_zoom
var _explosion_global_position: Vector3 = Vector3.ZERO : set = _set_explosion_global_position
var _explosion_size_multiplier: int = 1
var _building_currently_active: Constants.BuildingType = Constants.BuildingType.None : set = _set_building_currently_active


#region Setters
func _set_distance(new_distance: float) -> void:
	distance = clampf(new_distance, 5, 250)
	
	if camera_3d:
		camera_3d.z = distance


func _set_explosion_global_position(new_explosion_global_position: Vector3) -> void:
	_explosion_global_position = new_explosion_global_position
	
	explosion_target.global_position = _explosion_global_position
	explosion_target.visible = not _explosion_global_position.is_zero_approx()
	explosion_target.player_camera = self


func _set_zoom(new_zoom: float) -> void:
	zoom = clampf(new_zoom, 3, 20)


func _set_building_container_node_3d(new_building_container_node_3d: Node3D) -> void:
	building_container_node_3d = new_building_container_node_3d
	
	_recalculate_aabb()


func _set_building_currently_active(new_building_currently_active: Constants.BuildingType) -> void:
	_building_currently_active = new_building_currently_active
	
	if building_label:
		var new_font_color: Color = Color.WHITE
		
		if _building_currently_active == Constants.BuildingType.None:
			new_font_color = Color.DARK_RED
		
		building_label.add_theme_color_override("font_color", new_font_color)
	
	Signals.building_currently_active_was_changed.emit(_building_currently_active)
#endregion


func _ready() -> void:
	Signals.building_recalculated_camera_position.connect(_on_building_recalculated_camera_position)
	
	_post_ready.call_deferred()


func _post_ready() -> void:
	# Force initialization
	camera_3d.position.z = zoom
	
	_building_currently_active = _building_currently_active



func _physics_process(delta: float) -> void:
	if camera_3d:
		if camera_3d.position.z - zoom > 1:
			camera_3d.position.z -= ZOOM_LERP_SPEED * delta
		
		if camera_3d.position.z - zoom < 1:
			camera_3d.position.z += ZOOM_LERP_SPEED * delta


func _unhandled_input(event: InputEvent) -> void:
	# Show an explosion indicator
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var worldspace: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
		var from:Vector3 = camera_3d.project_ray_origin(event.position)
		var end:Vector3 = from + camera_3d.project_ray_normal(event.position) * RAY_LENGTH
	
		var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, end)
		
		if query:
			var result = worldspace.intersect_ray(query)
			
			if result and result.position:
				_explosion_global_position = result.position
	
	# Trigger an explosion
	if event.is_action_released(Constants.INPUT_MOUSE_LEFT):
		if (
			explosions_container_node_3d and
			!_explosion_global_position.is_zero_approx()
		):
			var explosion: ExplosionUsingArea2d = explosion_scene.instantiate()
			
			explosion.explosion_size_multiplier = _explosion_size_multiplier
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

	if event.is_action_released(Constants.INPUT_MOUSE_WHEEL_UP):
		zoom -= MOUSE_ZOOM_DELTA
	
	if event.is_action_released(Constants.INPUT_MOUSE_WHEEL_DOWN):
		zoom += MOUSE_ZOOM_DELTA


# Based on https://www.reddit.com/r/godot/comments/18bfn0n/how_to_calculate_node3d_bounding_box/l058v0v/
func _calculate_spatial_bounds(parent : Node3D) -> AABB:
	var bounds : AABB = AABB()
	
	if parent is VisualInstance3D:
		bounds = parent.get_aabb();
	
	for i in range(parent.get_child_count()):
		var child : Node3D = parent.get_child(i)
		
		if child:
			var child_bounds : AABB = _calculate_spatial_bounds(child)
			
			if bounds.size == Vector3.ZERO && parent:
				bounds = child_bounds
			
			else:
				bounds = bounds.merge(child_bounds)
	
	if bounds.size == Vector3.ZERO && !parent:
		bounds = AABB(Vector3(-0.2, -0.2, -0.2), Vector3(0.4, 0.4, 0.4))
	
	bounds = parent.transform * bounds
  
	return bounds


func _recalculate_aabb() -> void:
	if (
		building_container_node_3d and
		
		building_container_node_3d.get_child_count() > 0
	):
		var aabb: AABB = _calculate_spatial_bounds(building_container_node_3d)
		
		position = aabb.get_center()
		
		# Change Zoom level to try to get the full building visible
		zoom = int(aabb.get_longest_axis_size())


#region Signals
func _on_load_building_option_button_item_selected(index: int) -> void:
	_building_currently_active = index as Constants.BuildingType


func _on_building_recalculated_camera_position() -> void:
	_recalculate_aabb()


func _on_explosion_size_h_slider_value_changed(value: float) -> void:
	_explosion_size_multiplier = value
	
	Signals.explosion_size_multiplier_changed.emit(value)
#endregion
