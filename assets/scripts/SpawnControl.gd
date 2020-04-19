extends Node

var enemy_path = "res://assets/prefab/Enemy.tscn"
#var resource_path = "res://assets/prefab/Resource.tscn"
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_enemy(-100, 100)


func spawn_enemy(min_radius, max_radius):
	rng.randomize()
	var scene_resource = load(enemy_path)
	var scene = scene_resource.instance()
	var x_position = rng.randf_range(min_radius, max_radius)
	var y_position = rng.randf_range(min_radius, max_radius)
	print(x_position)
	print(y_position)
	scene.position = Vector2(x_position, y_position)
	add_child(scene)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
