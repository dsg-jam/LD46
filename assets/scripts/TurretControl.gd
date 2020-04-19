extends KinematicBody2D

const math_utils := preload("math_utils.gd")

export var health = 100
export var level = 1
export var combat_speed = 1
export var bullet_1_range = 20
export var bullet_2_range = 5
export var bullet_3_range = 1
export var radius = 5

export var upgrade_cost = {"wood": 0, "stone": 0, "iron": 0}

var turrets = [load("res://assets/prefabs/Turret_2.tscn"), load("res://assets/prefabs/Turret_3.tscn")]
var bullets = [preload("res://assets/prefabs/Bullet_1.tscn"), preload("res://assets/prefabs/Bullet_2.tscn"), preload("res://assets/prefabs/Bullet_3.tscn")]

var bullet_selection = math_utils.prepare({0: bullet_1_range, 1: bullet_2_range, 2: bullet_3_range})

var rng := RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()

func create_bullet(bullet, body):
	var node: Node2D = bullets[bullet].instance()
	node.enemy_body = body
	node.position = (body.position - position).normalized() * radius + position
	get_tree().current_scene.add_child(node)

func turret_area() -> void:
	for body in $Area2D.get_overlapping_bodies():
		if !body.is_in_group("enemies"):
			continue

		var resource = body.get_parent()
		if !resource:
			continue
		
		var bullet_select = math_utils.rand_selection_weighted(rng, bullet_selection)
		create_bullet(bullet_select, body)
		break
		


# Returns true if there are enough resources to upgrade the turret
#func upgrade_resources(available_resources) -> bool:
#	if level <= 2:
#		if available_resources["wood"] >= upgrade_cost["wood"] and available_resources["stone"] >= upgrade_cost["stone"] and available_resources["iron"] >= upgrade_cost["iron"]:
#			return true
#		else:
#			# "Not enough resources"
#			return false
#	else:
#		# "Turret already has max level"
#		return false
#
#
#func upgrade_turret(available_resources) -> bool:
#	if upgrade_resources(available_resources):
#		level += 1
#		var node: Node2D = turrets[level-2].instance()
#		node.position = position
#		queue_free()
#		get_tree().current_scene.add_child(node)
#		return true
#	else:
#		# "Try again :)"
#		return false


func _on_Timer_timeout():
	turret_area()

