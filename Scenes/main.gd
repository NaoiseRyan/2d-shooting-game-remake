extends Node


#Signals
signal game_start
signal game_over
signal update_score_hud
signal rush_mode_start
signal rush_mode_end


#Varibles
var score = 0
var enemy_one_kills = 0
var enemy_two_kills = 0
var rush_mode_active = false

var bg_texture_size = Vector2(1280, 720)

var enemy_two_array = []

#Varibles for screen change
const KILLS_UNTIL_RUSH_MODE_MAX = 18
var kills_until_rush_mode = KILLS_UNTIL_RUSH_MODE_MAX

#Resources
var enemyOneResource = preload("res://Scenes/enemy_one.tscn")
var enemyTwoResource = preload("res://Scenes/enemy_two.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	game_start.emit()

func _on_enemy_one_spawn_timer_timeout():
	var new_enemy_one = enemyOneResource.instantiate()
	add_child(new_enemy_one)
	var enemy_spawn_location = $enemyNodes/enemyOnePath/enemyOneSpawnLocation
	enemy_spawn_location.progress_ratio = randf()
	var new_enemy_one_position = enemy_spawn_location.position
	new_enemy_one.position = new_enemy_one_position
	new_enemy_one.enemy_one_update_score.connect(update_score)

func _on_game_start():
	$enemyNodes/enemyOneSpawnTimer.start()
	spawn_enemy_two()

func _on_player_player_die():
	print("player dead")
	game_over.emit()

func update_score(score_to_be_added, enemy_ref):
	#Updating Kill stats
	if enemy_ref.is_in_group("enemyOne"):
		enemy_one_kills += 1
	elif enemy_ref.is_in_group("enemyTwo"):
		enemy_two_kills += 1
	
	#The countdown for rushmodes start
	kills_until_rush_mode -= 1
	#Updating score
	score += score_to_be_added
	update_score_hud.emit(score)
	update_background()

func update_background():
	if kills_until_rush_mode > KILLS_UNTIL_RUSH_MODE_MAX / 1.5:
		$Background.texture.region = Rect2(0, bg_texture_size.y - bg_texture_size.y, bg_texture_size.x, bg_texture_size.y)
	elif kills_until_rush_mode > KILLS_UNTIL_RUSH_MODE_MAX / 2:
		$Background.texture.region = Rect2(0, bg_texture_size.y, bg_texture_size.x, bg_texture_size.y)
	elif kills_until_rush_mode > 0:
		$Background.texture.region = Rect2(0, bg_texture_size.y * 2, bg_texture_size.x, bg_texture_size.y)
	elif !rush_mode_active:
		rush_mode_active = true
		rush_mode_start.emit()

func _on_rush_mode_start():
	$Background.texture.region = Rect2(0, bg_texture_size.y * 3, bg_texture_size.x, bg_texture_size.y)
	$enemyNodes/RushModeTimer.start()

func _on_rush_mode_end():
	kills_until_rush_mode = KILLS_UNTIL_RUSH_MODE_MAX

func _on_rush_mode_timer_timeout():
	rush_mode_end.emit()
	rush_mode_active = false

func spawn_enemy_two():
	if enemy_two_array.size() < 2:
		print("less then 3")
		var new_enemy_two = enemyTwoResource.instantiate()
		add_child(new_enemy_two)
		var enemy_spawn_location = $enemyNodes/enemyTwoPath/enemyTwoSpawnLocation
		enemy_spawn_location.progress_ratio = randf()
		new_enemy_two.position = enemy_spawn_location.position

#a
