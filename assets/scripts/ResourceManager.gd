extends Node

export var spawn_radius_min: float
export var spawn_radius_max: float
export var max_resources: int = 50

const math_utils := preload("math_utils.gd")
const resource_prefab := preload("res://assets/prefabs/Resource.tscn")

var rng := RandomNumberGenerator.new()
var resource_count := 0

# Generate a random position whose distance from the origin is between the radius bounds.
func random_position() -> Vector2:
	return math_utils.randvec_with_radius_range(rng, spawn_radius_min, spawn_radius_max)

# Spawn a resource at the given position.
func spawn_resource(pos: Vector2) -> void:
	var node: Node2D = resource_prefab.instance()
	node.position = pos
	
	add_child(node)
	resource_count += 1
	
func remove_resource(resource: Node2D) -> void:
	remove_child(resource)
	resource_count -= 1

func _ready() -> void:
	rng.randomize()

# Spawn a resource if the resource limit hasn't been reached.
func maybe_spawn_resource() -> bool:
	if resource_count >= max_resources:
		# still enough resources
		return false

	spawn_resource(random_position())
	return true

func _on_Timer_timeout() -> void:
	maybe_spawn_resource()
