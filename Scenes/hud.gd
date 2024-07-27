extends CanvasLayer

const health_texturerect_width = 205
@onready var low_health_gradient_reference = $lowHealthGradient

func update_healthbar(current_health):
	var new_texturerect_x = 205 * (4 - current_health)
	$HealthBar.texture.region = Rect2(new_texturerect_x, 0, 210, 190)
	if current_health <= 1:
		low_health_gradient_reference.visible = true
	else:
		low_health_gradient_reference.visible = false

func update_score_label(new_score):
	$ScoreMessage/ScoreNumber.text = new_score

func _on_main_game_over():
	$DeadMessage.visible = true


func _on_main_update_score_hud(score):
	score = str(score)
	$ScoreMessage/ScoreNumber.text = score 
