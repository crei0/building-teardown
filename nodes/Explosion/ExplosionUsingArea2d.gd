extends Area3D
class_name ExplosionUsingArea2d


const animation_name_explosion: String = "explode_animation"

@export var explosion_size_multiplier: int = 1 : set = _set_explosion_size_multiplier

@onready var collision_shape_3d: CollisionShape3D = %CollisionShape3D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var gpu_particles_3d_container_node_3d: Node3D = %GpuParticles3dContainerNode3D

var _worldspace: PhysicsDirectSpaceState3D


func _set_explosion_size_multiplier(new_explosion_size_multiplier: int) -> void:
	explosion_size_multiplier = new_explosion_size_multiplier
	
	# As precaution
	if !collision_shape_3d:
		collision_shape_3d = get_node("%CollisionShape3D") as CollisionShape3D
	
	if !gpu_particles_3d_container_node_3d:
		gpu_particles_3d_container_node_3d = get_node("%GpuParticles3dContainerNode3D") as Node3D
	
	if (
		collision_shape_3d and
		gpu_particles_3d_container_node_3d
	):
		var explosion_scale: Vector3 = Vector3(explosion_size_multiplier, explosion_size_multiplier, explosion_size_multiplier)
		
		collision_shape_3d.scale = explosion_scale
		gpu_particles_3d_container_node_3d.scale = explosion_scale


func _ready() -> void:
	_worldspace = get_world_3d().direct_space_state
	
	scale = Vector3.ONE


func explode_at_position(position: Vector3) -> void:
	global_position = position
	
	animation_player.play(animation_name_explosion)


func _on_body_entered(body: Node3D) -> void:
	if body is ModularBuildingBlock:
		var building_block: ModularBuildingBlock = body as ModularBuildingBlock
		
		building_block.damage_from_explosion_position(transform, explosion_size_multiplier)


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if _anim_name == animation_name_explosion:
		queue_free()
