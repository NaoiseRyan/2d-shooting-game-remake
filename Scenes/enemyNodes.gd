extends Node

var enemyOne = preload("res://Scenes/enemy_one.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_enemy_one_spawn_timer_timeout():
	var new_enemy_one = enemyOne.instantiate()
	new_enemy_one.spawned_in()
	print(new_enemy_one.position)
	#$enemyOnePath/enemyOneSpawnLocation.progress_ratio = randf()
	#var new_enemy_one_position = $enemyOnePath/enemyOneSpawnLocation.position
	#new_enemy_one.position = new_enemy_one_position
	#print(new_enemy_one.position)
	new_enemy_one.position = Vector2(500,500)
