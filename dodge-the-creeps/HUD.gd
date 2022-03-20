extends CanvasLayer

signal start_game

func _ready():
	pass # Replace with function body.

#func _process(delta):
#	pass

func show_message(text: String):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()


func show_game_over():
	self.show_message("Game Over")
	yield($MessageTimer, "timeout")
	
	$Message.text = "Dodge The Creeps!"
	$Message.show()
	
	yield(self.get_tree().create_timer(0.5), "timeout")
	$StartButton.show()


func update_score(score: int):
	$ScoreLabel.text = str(score)

func _on_MessageTimer_timeout():
	$Message.hide()
	$Message.text = ""

func _on_StartButton_pressed():
	$StartButton.hide()
	self.emit_signal("start_game")
