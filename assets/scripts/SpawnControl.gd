extends Node

var enemy_path = "res://assets/prefabs/Enemy.tscn"
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
	scene.position = Vector2(x_position, y_position)
	scene.damage = rng.randi_range(1, 15)
	scene.speed = rng.randi_range(25, 100)
	scene.combat_speed = rng.randf_range(.5, 2)
	add_child(scene)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
