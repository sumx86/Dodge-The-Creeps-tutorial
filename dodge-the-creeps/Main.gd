extends Node

export(PackedScene) var mob_scene
var mob
var mob_spawn_location
var score

func _ready():
	randomize()
	#self.new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func game_over():
	$Music.stop()
	$DeathSound.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	self.destroy_mobs_instances()
	$HUD.show_game_over()
	
func new_game():
	self.score = 0
	$HUD.update_score(self.score)
	$HUD.show_message("Get Ready!")
	
	$Player.spawn($StartPosition.position)
	$StartTimer.start()
	$MobTimer.start()
	$ScoreTimer.start()
	$Music.play()

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
