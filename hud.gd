extends CanvasLayer
signal start_game

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		_on_start_button_pressed()

func update_score(value):
	$MarginContainer/Score.text = str(value)
	
func update_time(value):
	$MarginContainer/Time.text = str(value)
	
func show_message(text):
	$message.text = text
	$message.show()
	$Timer.start()

func show_game_over():
	show_message("Game Over")
	await $Timer.timeout
	$StartButton.show()
	$message.text = "Coin Dash!"
	$message.show()

func _on_timer_timeout() -> void:
	$message.hide()

func _on_start_button_pressed() -> void:
	$StartButton.hide()
	$message.hide()
	start_game.emit()
