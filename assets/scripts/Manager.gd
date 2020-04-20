extends Node

const math_utils := preload("math_utils.gd")

export var spawn_radius_min: float
export var spawn_radius_max: float
export var max_resources: int

export var enemy_max_group: int
export var enemy_zone_radius: float
export var enemy_spawn_safe_time: float
export var enemy_spawn_increase_exponent: float
export var enemy_spawn_increase_base: float
export var enemy_spawn_increase_offset: float

var noise := OpenSimplexNoise.new()

const resource_prefab := preload("res://assets/prefabs/Resource.tscn")
const enemy_prefab := preload("res://assets/prefabs/Enemy.tscn")

var rng := RandomNumberGenerator.new()

onready var player = $"../Player"
onready var camera = player.get_node("Camera2D")

# Generate a random position whose distance from the origin is between the radius bounds.
func random_position() -> Vector2:
	return math_utils.randvec_with_radius_range(rng, spawn_radius_min, spawn_radius_max)

var enemy_count := 0

func _on_Enemy_tree_exiting() -> void:
	enemy_count -= 1

func spawn_enemy(pos: Vector2) -> void:	
	var node: Node2D = enemy_prefab.instance()
	node.position = pos
	
	# handle removing the resource
	node.connect("tree_exiting", self, "_on_Enemy_tree_exiting")
	
	add_child(node)
	enemy_count += 1

func get_player_view_radius() -> float:
	var size: Vector2 = get_viewport().size * camera.zoom
	return max(size.x, size.y) / 2.0

func get_max_enemies(secs: float) -> int:
	return (enemy_spawn_increase_offset + pow(enemy_spawn_increase_base, enemy_spawn_increase_exponent * secs)) as int

# Spawn a resource if the resource limit hasn't been reached.
func maybe_spawn_enemy() -> void:
	var secs: float = (OS.get_ticks_msec() / 1000.0) - enemy_spawn_safe_time
	if secs < 0:
		return
	
	if enemy_count >= get_max_enemies(secs):
		return

	var value := noise.get_noise_1d(OS.get_ticks_msec())
	if value < 0:
		return

	var count := ceil(value * enemy_max_group)
	var spawn_radius := count * enemy_zone_radius
	var view_radius := get_player_view_radius() + spawn_radius
	var pos: Vector2
	while true:
		pos = random_position()
		var dist2player: float = (player.position - pos).length()
		if dist2player > view_radius:
			break
	
	for i in count:
		var enemy_pos := pos + Vector2(rng.randf_range(0, spawn_radius), rng.randf_range(0, spawn_radius))
		spawn_enemy(enemy_pos)

var resource_count := 0

func _on_Resource_tree_exiting() -> void:
	resource_count -= 1

# Spawn a resource at the given position.
func spawn_resource(pos: Vector2) -> void:
	var node: Node2D = resource_prefab.instance()
	node.position = pos
	node.init_random(rng)
	
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
	noise.seed = rng.randi()
	noise.period = 128

func _on_Timer_timeout() -> void:
	maybe_spawn_resource()
	maybe_spawn_enemy()
