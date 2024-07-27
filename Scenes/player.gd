extends CharacterBody2D
class_name Player

const BULLET_RESOURCE = preload("res://Scenes/bullet.tscn")

var screen_size
var attack_debounce = false
var iframe_active = false

const attack_cooldown_default = 0.5

#Player vars
const SPEED = 200.0
const MAX_HEALTH = 4
@onready var health = MAX_HEALTH
@onready var direction = Vector2.ZERO
var alive = true

signal health_changed(new_health)
signal player_die

func _ready():
	screen_size = get_viewport_rect().size
	$attackCooldown.wait_time = attack_cooldown_default
	
	var spawn_point_group_reference = get_tree().get_nodes_in_group("player_spawn_point")[0]
	if spawn_point_group_reference:
		position = spawn_point_group_reference.position
	else:
		position = screen_size/2

func _process(delta):
	animationHandler()

func _physics_process(delta):
	input_handler()

	#Normalize velocity to prevent diagonal movement being faster
	velocity = velocity.normalized() 
	velocity = velocity * SPEED

	move_and_slide()
	position.x = clamp(position.x, 87, screen_size.x - 86)
	position.y = clamp(position.y, 46, screen_size.y - 96)

func input_handler():
	#Keyboard inputs
	direction.x = Input.get_axis("move_left", "move_right")
	velocity.x = direction.x
	direction.y = Input.get_axis("move_up", "move_down")
	velocity.y = direction.y
	
	#Mouse inputs
	if Input.is_action_pressed("attack_click") && !attack_debounce:
		attack_debounce = true
		$attackCooldown.start()
		var bullet_instance = BULLET_RESOURCE.instantiate()
		add_child(bullet_instance)
		bullet_instance.on_fire(position)

func animationHandler():
	if alive:
		if attack_debounce && direction == Vector2(0, 0):
			$AnimatedSprite2D.play("shoot_side")
		elif direction == Vector2(0, 0):
			$AnimatedSprite2D.play("idle")
		elif direction == Vector2(1, 0):
			$AnimatedSprite2D.play("run_right")
		elif direction == Vector2(-1, 0):
			$AnimatedSprite2D.play("run_left")
		elif direction == Vector2(0, 1):
			$AnimatedSprite2D.play("run_down")
		elif direction == Vector2(0, -1):
			$AnimatedSprite2D.play("run_up")

func _on_main_game_start():
	health_changed.emit(health)

func _on_health_changed(new_health):
	health = new_health
	if health <= 0:
		player_die.emit()

func _on_attack_cooldown_timeout():
	attack_debounce = false


func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy") && !iframe_active && alive && body.get_is_collision_active():
		iframe_active = true
		$iFrameDebounce.start()
		body.die()
		var new_health = health - body.DAMAGE
		if new_health < 0:
			new_health = 0
		health_changed.emit(new_health)


func _on_i_frame_debounce_cooldown_timeout():
	iframe_active = false


func _on_player_die():
	alive = false
	$AnimatedSprite2D.play("die")
	set_physics_process(false)
