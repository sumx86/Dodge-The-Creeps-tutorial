extends Area2D

signal hit

export var speed = 200
var screen_size
var _animation
var lockedMode

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	self.lockedMode = true
	self.screen_size = get_viewport_rect().size

func spawn(pos):
	self.position = pos
	self.show();
	self.lockedMode = false
	$CollisionShape2D.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if(!self.lockedMode):
		if(Input.is_action_pressed("move_right")):
			velocity.x += 1
		if(Input.is_action_pressed("move_left")):
			velocity.x -= 1
		if(Input.is_action_pressed("move_down")):
			velocity.y += 1
		if(Input.is_action_pressed("move_up")):
			velocity.y -= 1
		
		self.determine_animation(velocity)
		
		if(velocity.length() > 0):
			velocity = velocity.normalized() * speed
			$AnimatedSprite.play()
		else:
			$AnimatedSprite.stop()
		
		self.position += velocity * delta
		self.position.x = clamp(self.position.x, 0, self.screen_size.x)
		self.position.y = clamp(self.position.y, 0, self.screen_size.y)


func determine_animation(velocity: Vector2):
	if(velocity.x != 0):
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0


func _on_Player_body_entered(body):
	self.hide()
	self.emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
