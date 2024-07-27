extends CharacterBody2D
class_name enemyTwo

signal enemy_two_update_score(score, enemy_ref)

const SPEED = 5.0
const DAMAGE = 2
const SCORE_VALUE = 200
var direction

var rush_mode = false

var attacking = false

var path_follow_ref

#This entire class is fucked by not setting up a base class better

func _physics_process(delta):
	path_follow_ref.progress += SPEED
	if rush_mode:
		path_follow_ref.progress += 5
	velocity = self.position - path_follow_ref.position
	self.position = path_follow_ref.position

func _process(delta):
	animationHandler()

func _ready():
	get_parent().rush_mode_start.connect(rush_mode_start)
	get_parent().rush_mode_end.connect(rush_mode_end)

func animationHandler():
	if !attacking:
		if velocity.y == 0 && velocity.x > 0:
			$AnimatedSprite2D.play("run_left")
		if velocity.y == 0 && velocity.x < 0:
			$AnimatedSprite2D.play("run_right")
		if velocity.x == 0 && velocity.y > 0:
			$AnimatedSprite2D.play("run_up")
		if velocity.x == 0 && velocity.y < 0:
			$AnimatedSprite2D.play("run_down")

#Actually the attack function
func die():
	attacking = true
	$AnimatedSprite2D.play("attack")
	await $AnimatedSprite2D.animation_finished
	attacking = false

func killed():
	enemy_two_update_score.emit(SCORE_VALUE, self)
	create_death_score_label()
	set_physics_process(false)
	set_process(false)
	$CollisionShape2D.disabled = true
	$AnimatedSprite2D.play("die")
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

func record_path_follow(ref):
	path_follow_ref = ref

func rush_mode_start():
	rush_mode = true
	
func rush_mode_end():
	rush_mode = false
