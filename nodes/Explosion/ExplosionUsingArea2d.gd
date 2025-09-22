extends Area3D
class_name ExplosionUsingArea2d


@onready var collision_shape_3d: CollisionShape3D = %CollisionShape3D
@onready var animation_player: AnimationPlayer = %AnimationPlayer

var _worldspace: PhysicsDirectSpaceState3D


func _ready() -> void:
	_worldspace = get_world_3d().direct_space_state
	
	scale = Vector3.ONE * Globals.BASE_EXPLOSION_SCALE


func explode_at_position(position: Vector3) -> void:
	global_position = position
	
	animation_player.play("explode_animation")


func _on_body_entered(body: Node3D) -> void:
	if body is ModularBuildingBlock:
		var building_block: ModularBuildingBlock = body as ModularBuildingBlock
		
		building_block.damage_from_explosion_position(global_position)
		
		#(body as RigidBody3D).apply_impulse(global_position)


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if _anim_name == "explode_animation":
		queue_free()
