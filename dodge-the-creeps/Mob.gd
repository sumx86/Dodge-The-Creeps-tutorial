extends RigidBody2D

var mob_types

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.playing = true
	self.mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = self.mob_types[randi() % self.mob_types.size()]
	print($AnimatedSprite.animation)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()
