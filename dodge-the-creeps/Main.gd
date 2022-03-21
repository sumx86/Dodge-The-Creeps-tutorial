extends Node

export(PackedScene) var mob_scene
var mob
var mob_spawn_location
var mob_linear_velocity
var score
var paused
var running_state

func _ready():
	randomize()
	$MobTimer.add_to_group("timers")
	$ScoreTimer.add_to_group("timers")
	#self.new_game()
			
#Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _unhandled_input(event):
	if(event is InputEventKey):
		if(event.pressed and event.scancode == KEY_ESCAPE):
			if(self.running_state):
				self.toggle_pause_state()

func toggle_pause_state():
	$Player.set_locked_mode(not $Player.get_locked_mode())
	self.toggle_timers_pause_state()

func game_over():
	self.running_state = false
	$Music.stop()
	$DeathSound.play()
	$ScoreTimer.stop()
	#$MobTimer.stop()
	self.destroy_mobs_instances()
	$HUD.show_game_over()
	
func new_game():
	self.running_state = true
	self.score = 0
	$HUD.update_score(self.score)
	$HUD.show_message("Get Ready!")
	
	$Player.spawn($StartPosition.position, "down")
	$StartTimer.start()
	#self.start_timers()
	#$Music.play()

func _on_MobTimer_timeout():
	var mob = mob_scene.instance()
	mob.add_to_group("mobs")

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func destroy_mobs_instances():
	for mob in self.get_tree().get_nodes_in_group("mobs"):
		mob.queue_free()

func _on_ScoreTimer_timeout():
	self.score += 1
	$HUD.update_score(self.score)

func start_timers():
	for timer in self.get_tree().get_nodes_in_group("timers"):
		timer.set_paused(false)
		timer.start()

func toggle_timers_pause_state():
	for timer in self.get_tree().get_nodes_in_group("timers"):
		timer.set_paused(not timer.is_paused())
