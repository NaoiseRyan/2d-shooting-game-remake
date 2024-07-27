extends CharacterBody2D
class_name enemyOne

signal enemy_one_update_score(score, enemy_ref)

var player_ref

var speed = randf_range(85.0, 125.0)
const DAMAGE = 1
const SCORE_VALUE = 100
var direction

var rush_mode = false


func _ready():
	player_ref = get_player_reference()
	get_parent().rush_mode_start.connect(rush_mode_start)
	get_parent().rush_mode_end.connect(rush_mode_end)

func _process(delta):
	animationHandler()

func _physics_process(delta):
	if player_ref != null:
		var player_position = player_ref.position
		velocity = (player_position - position).normalized() * speed
		if rush_mode:
			velocity *= 2
		
		move_and_slide()

func get_player_reference():
	var player_ref_2 = get_tree().get_nodes_in_group("player")
	if len(player_ref_2) > 0:
		return player_ref_2[0]
	else:
		push_error("The player cannot be found")

func animationHandler():
	if velocity.x > 0 && velocity.x > velocity.y:
		$AnimatedSprite2D.play("run_right")
	elif velocity.x < 0 && velocity.x < velocity.y:
		$AnimatedSprite2D.play("run_left")
	elif velocity.y > 0:
		$AnimatedSprite2D.play("run_down")
	elif velocity.y < 0:
		$AnimatedSprite2D.play("run_up")

func killed():
	enemy_one_update_score.emit(SCORE_VALUE, self)
	create_death_score_label()
	set_physics_process(false)
	die()
	$AnimatedSprite2D.play("die")
	
func die():
	set_process(false)
	$CollisionShape2D.disabled = true
	$AnimatedSprite2D.play("attack")
	await $AnimatedSprite2D.animation_finished
	queue_free()

func create_death_score_label():
	#Creating the score label on enemy
	var death_score_label = Label.new()
	add_child(death_score_label)
	death_score_label.text = str(SCORE_VALUE)
	death_score_label.anchors_preset = 8
	death_score_label.add_theme_font_size_override("font_size", 20)
	#Tween to make text fly up after spawning
	var position_tween = create_tween()
	position_tween.tween_property(death_score_label, "position:y", death_score_label.position.y - 40, .35)
	var alpha_tween = create_tween()
	alpha_tween.tween_property(death_score_label, "modulate:a", 0, .35)

func get_is_collision_active():
	var return_var
	if $CollisionShape2D.disabled:
		return_var = false
	else:
		return_var = true
	return return_var


func rush_mode_start():
	rush_mode = true
	
func rush_mode_end():
	rush_mode = false
