extends KinematicBody2D

export var speed_mult: float = 80
export var build_distance: float = 14

var turrets_prefab = [preload("res://assets/prefabs/Turret_1.tscn"), preload("res://assets/prefabs/Turret_2.tscn"), preload("res://assets/prefabs/Turret_3.tscn")]

var interaction_area: Area2D

# reference to SimpleAnimationController.gd
var animation_controller

var inventory_ui_manager

const inventory := {}
var look_direction: Vector2

func maybe_get_node(path: NodePath) -> Node:
	if has_node(path):
		return get_node(path)
	return null

func _ready() -> void:
	interaction_area = $InteractionArea
	animation_controller = maybe_get_node("AnimatedSprite")
	
	var current_scene = get_tree().current_scene
	inventory_ui_manager = current_scene.get_node("CanvasLayer/InventoryUI")

func read_input() -> Vector2:
	var input := Vector2()
	if Input.is_action_pressed("player_right"):
		input.x += 1
	if Input.is_action_pressed("player_left"):
		input.x -= 1
	if Input.is_action_pressed("player_down"):
		input.y += 1
	if Input.is_action_pressed("player_up"):
		input.y -= 1

	return input.normalized()

func _physics_process(_delta: float) -> void:
	var input := read_input()
	if input.length() > 0:
		look_direction = input
	
	var velocity := input * speed_mult
	velocity = move_and_slide(velocity)
	
	if animation_controller:
		animation_controller.set_velocity_vector(velocity)

func mine_resource(resource) -> void:
	var resource_type: String = resource.resource_type
	var collected: int = resource.collect()
	add_item(resource_type, collected)

func mine_area() -> void:
	for body in interaction_area.get_overlapping_bodies():
		if !body.is_in_group("resources"):
			continue

		var resource = body.get_parent()
		if !resource:
			continue
			
		mine_resource(resource)
		# only allow mining one resource at a time
		break

func has_item(name: String, count: int) -> bool:
	return self.inventory.get(name, 0) >= count

func has_items(items: Dictionary) -> bool:
	for name in items.keys():
		if !has_item(name, items[name]):
			return false
	
	return true

func _change_item_count(name: String, count: int) -> void:
	inventory[name] = count
	inventory_ui_manager.update_item_count(name, count)
	

func add_item(name: String, count: int) -> int:
	var new_count = inventory.get(name, 0) + count
	_change_item_count(name, new_count)
	return new_count

func remove_item(name: String, count: int) -> void:
	var new_count = max(0, inventory.get(name, 0) - count)
	_change_item_count(name, new_count)

func remove_items(items: Dictionary) -> void:
	for name in items.keys():
		remove_item(name, items[name])

func try_remove_items(items: Dictionary) -> bool:
	if has_items(items):
		remove_items(items)
		return true
	return false

func spawn_turret() -> void:
	var turret = turrets_prefab[0].instance()
	if try_remove_items(turret.upgrade_cost):
		turret.position = self.position + look_direction * build_distance
		get_tree().current_scene.add_child(turret)
	else:
		print("Not enough items")

func try_upgrade_turret(turret) -> void:
	if turret.level <= 2:
		var node: Node2D = turrets_prefab[turret.level].instance()
		if try_remove_items(node.upgrade_cost):
			node.position = turret.position
			turret.queue_free()
			get_tree().current_scene.add_child(node)
		else:
			print("Not enough items")
	else:
		print("This turret has already lvl 3 :)")
		return

func try_build_turret() -> void:
	for body in interaction_area.get_overlapping_bodies():
		if !body.is_in_group("turrets"):
			continue
		var turret = body
		try_upgrade_turret(turret)
		return
	spawn_turret()

func _input(event: InputEvent) -> void:
	if event.is_action_released("player_mine"):
		mine_area()
		return

	if event.is_action_released("player_place_turret"):
		try_build_turret()
		return
