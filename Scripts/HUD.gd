extends CanvasLayer
var max_lives = 3
var last_score = 0

func _process(delta):
	if Global.player_score != last_score:
		last_score = Global.player_score
		$LivesContainer/ScoreLabel.text = "Score: " + str(Global.player_score)
	#$ScoreLabel.text = "Score: " + str(score)

func _ready():
	#update_score(Global.player_score)
	var perola = $"LivesContainer"
	perola.anchor_left = 0.5
	perola.anchor_right = 0.5
	perola.anchor_top = 1
	perola.anchor_bottom = 1
	#perola.margin_top = -50

func update_lives(lives):
	for i in range(max_lives):
		var life_texture = $"LivesContainer".get_node("Life" + str(i + 1))
		life_texture.visible = i < lives
