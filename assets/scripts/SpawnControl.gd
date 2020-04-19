extends Node

var enemy_path = preload("res://assets/prefabs/Enemy.tscn")
#var resource_path = "res://assets/prefab/Resource.tscn"


export var spawn_radius_min: float
export var spawn_radius_max: float
export var max_enemies: int = 25

const math_utils := preload("math_utils.gd")

var rng = RandomNumberGenerator.new()
var enemy_count := 0

# Called when the node enters the scene tree for the first time.

func _on_Resource_tree_exiting() -> void:
	enemy_count -= 1
	print("enemies in world: ", enemy_count)

# Spawn a resource at the given position.
func spawn_resource(pos: Vector2) -> void:
	var node: Node2D = enemy_path.instance()
	node.position = pos
	node.damage = rng.randi_range(1, 15)
	node.speed = rng.randi_range(25, 100)
	node.combat_speed = rng.randf_range(.5, 2)
	add_child(node)
	enemy_count += 1

func _ready() -> void:
	rng.randomize()

# Generate a random position whose distance from the origin is between the radius bounds.
func random_position() -> Vector2:
	return math_utils.randvec_with_radius_range(rng, spawn_radius_min, spawn_radius_max)

# Spawn a resource if the resource limit hasn't been reached.
func maybe_spawn_resource() -> bool:
	if enemy_count >= max_enemies:
		# still enough resources
		return false

	spawn_resource(random_position())
	return true


func _on_Timer_timeout():
	maybe_spawn_resource()
