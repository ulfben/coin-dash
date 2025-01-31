extends Node
@export var coin_scene : PackedScene
@export var powerup_scene : PackedScene
@export var playtime = 30

var level = 1
var score = 0
var time_left = 0
var screensize = Vector2.ZERO
var playing = false

func _ready() -> void:
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize;
	$Player.hide()
	$HUD.update_score(score)
	$HUD.update_time(time_left)

func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start()
	$Player.show()
	$GameTimer.start()
	spawn_coins()

func get_random_pos() -> Vector2:
	return Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))

func spawn_coins():
	$LevelSound.play()
	for i in level + 4:
		var c = coin_scene.instantiate()
		add_child(c)
		c.screensize = screensize
		c.position = get_random_pos()

func game_over():
	$EndSound.play()
	playing = false
	$GameTimer.stop()
	get_tree().call_group("coins", "queue_free")
	$HUD.show_game_over()
	$Player.die()

func _process(delta: float) -> void:
	if playing and get_tree().get_nodes_in_group("coins").size() == 0:
		level += 1
		time_left += 5
		spawn_coins()
		$PowerupTimer.wait_time = randf_range(5, 10)
		$PowerupTimer.start()

func _on_game_timer_timeout() -> void:
	time_left -= 1
	$HUD.update_time(time_left)
	if(time_left < 1):
		game_over()

func _on_player_pickup(type) -> void:
	match type:
		"coin":
			$AudioListener2D.make_current()	
			$AudioListener2D.position = Vector2(240, 360)
			$CoinSound.position = $Player.position
			$CoinSound.play()
			score += 1
			$HUD.update_score(score)
		"powerup":
			$PowerupSound.play()
			time_left += 5
			$HUD.update_time(time_left)

func _on_player_hurt() -> void:
	game_over()

func _on_hud_start_game() -> void:
	new_game()

func _on_powerup_timer_timeout() -> void:
	var p = powerup_scene.instantiate()
	add_child(p)
	p.screensize = screensize
	p.position = get_random_pos()
