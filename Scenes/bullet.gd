extends Area2D

var mouse_position
var mouse_rotation

const SPEED = 20

func on_fire(player_position):
	position = player_position
	$AnimatedSprite2D.play()
	mouse_position = get_global_mouse_position()
	mouse_rotation = global_position.direction_to(mouse_position).angle()
	rotation = mouse_rotation

func _physics_process(delta):
	position += transform.x * SPEED


func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	if body.get_is_collision_active():
		queue_free()
		if body.is_in_group("enemy"):
			body.killed()
