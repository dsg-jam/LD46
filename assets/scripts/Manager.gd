extends Node

const math_utils := preload("math_utils.gd")

export var spawn_radius_min: float
export var spawn_radius_max: float
export var max_enemies: int = 50
export var max_resources: int = 50

const resource_prefab := preload("res://assets/prefabs/Resource.tscn")
const enemy_prefab := preload("res://assets/prefabs/Enemy.tscn")

var rng := RandomNumberGenerator.new()

# Generate a random position whose distance from the origin is between the radius bounds.
func random_position() -> Vector2:
	return math_utils.randvec_with_radius_range(rng, spawn_radius_min, spawn_radius_max)

var enemy_count := 0

func _on_Enemy_tree_exiting() -> void:
	enemy_count -= 1
	print("enemies in world: ", enemy_count)

func spawn_enemy(pos: Vector2) -> void:
	var node: Node2D = enemy_prefab.instance()
	node.position = pos
	
	# handle removing the resource
	node.connect("tree_exiting", self, "_on_Enemy_tree_exiting")
	
	add_child(node)
	enemy_count += 1

# Spawn a resource if the resource limit hasn't been reached.
func maybe_spawn_enemy() -> bool:
	if enemy_count >= max_enemies:
		# still enough resources
		return false

	spawn_enemy(random_position())
	return true

var resource_count := 0

func _on_Resource_tree_exiting() -> void:
	resource_count -= 1
	print("resources in world: ", resource_count)

# Spawn a resource at the given position.
func spawn_resource(pos: Vector2) -> void:
	var node: Node2D = resource_prefab.instance()
	node.position = pos
	
	# handle removing the resource
	node.connect("tree_exiting", self, "_on_Resource_tree_exiting")
	
	add_child(node)
	resource_count += 1

# Spawn a resource if the resource limit hasn't been reached.
func maybe_spawn_resource() -> bool:
	if resource_count >= max_resources:
		# still enough resources
		return false

	spawn_resource(random_position())
	return true

func _ready() -> void:
	rng.randomize()

func _on_Timer_timeout() -> void:
	maybe_spawn_resource()
	maybe_spawn_enemy()
