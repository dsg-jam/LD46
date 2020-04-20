extends KinematicBody2D

const math_utils := preload("math_utils.gd")

export var health = 100
export var level = 1
export var bullet_1_range = 20
export var bullet_2_range = 5
export var bullet_3_range = 1
export var radius = 5

var companion
var upgrade_display

export var upgrade_cost = {"wood": 0, "stone": 0, "iron": 0}

var bullets = [preload("res://assets/prefabs/Bullet_1.tscn"), preload("res://assets/prefabs/Bullet_2.tscn"), preload("res://assets/prefabs/Bullet_3.tscn")]

var bullet_selection = math_utils.prepare_weighted_selection({0: bullet_1_range, 1: bullet_2_range, 2: bullet_3_range})

var rng := RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	companion = get_tree().current_scene.get_node("Companion")
	upgrade_display = $UpgradeDisplay
	
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

		if not body.is_reassigned:
			body.is_reassigned = true
			body.target_position = position
		
		var bullet_select = math_utils.rand_selection_weighted(rng, bullet_selection)
		create_bullet(bullet_select, body)
		break

func remove_turret() -> void:
	for body in $Area2D.get_overlapping_bodies():
		if !body.is_in_group("enemies"):
			continue

		if body.is_reassigned:
			body.is_reassigned = false
	queue_free()

func reduce_health(amount) -> void:
	health -= amount
	if health <= 0:
		remove_turret()

func remove():
	queue_free()

func _on_Timer_timeout():
	turret_area()

