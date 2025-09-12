extends Area3D
class_name ExplosionUsingArea2d

@onready var collision_shape_3d: CollisionShape3D = %CollisionShape3D

var _worldspace: PhysicsDirectSpaceState3D


func _ready() -> void:
	_worldspace = get_world_3d().direct_space_state
	
	scale = Vector3.ONE * Globals.EXPLOSION_SCALE


func explode_at_position(position: Vector3) -> void:
	#print("ExplosionUsingArea2d > explode_at_position > position = ", position)
	
	global_position = position


func _on_body_entered(body: Node3D) -> void:
	#print("ExplosionUsingArea2d > _on_body_entered > body = ", body)
	
	if body is BuildingBlock:
		var building_block: BuildingBlock = body as BuildingBlock
		
		building_block.damage_from_explosion_position(global_position)
			
		
		#(body as RigidBody3D).apply_impulse(global_position)
	
	queue_free()
