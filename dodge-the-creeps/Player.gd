extends Area2D

signal hit

export var speed = 130
var screen_size
var _animation
var lockedMode
var direction
var new_direction
var velocity = Vector2.ZERO
var frames

var last_key
var keys: Array = []

enum directions {UP, DOWN, LEFT, RIGHT}

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	self.lockedMode = true
	self.screen_size = get_viewport_rect().size
	self.frames = $AnimatedSprite.frames
	

func spawn(pos: Vector2, animation: String):
	self.position = pos
	$AnimatedSprite.animation = animation
	$AnimatedSprite.set_frame(0)
	self.show();
	self.lockedMode = false
	$CollisionShape2D.disabled = false

func _unhandled_input(event):
	if event is InputEventKey:
		if event.scancode == KEY_DOWN or event.scancode == KEY_UP or event.scancode == KEY_LEFT or event.scancode == KEY_RIGHT:
			if event.pressed:
				if !self.keys.has(event.scancode):
					self.keys.push_back(event.scancode)
			else:
				if self.keys.has(event.scancode):
					self.keys.pop_at(self.keys.find(event.scancode, 0))

func _process(delta):
	self.velocity = Vector2.ZERO
	if self.keys.size() > 0:
		self.last_key = self.keys[-1]
		if self.last_key == KEY_DOWN:  self.velocity = Vector2(0,  1)
		if self.last_key == KEY_UP:    self.velocity = Vector2(0, -1)
		if self.last_key == KEY_LEFT:  self.velocity = Vector2(-1, 0)
		if self.last_key == KEY_RIGHT: self.velocity = Vector2(1,  0)
	
	if self.velocity != Vector2.ZERO:
		self.process_player_movement()
		self.move_player(delta)
	else:
		$AnimatedSprite.set_frame(0)

func process_player_movement():
	match self.velocity:
		Vector2(-1, 0), Vector2(1, 0):
			$AnimatedSprite.animation = "walkx"
			$AnimatedSprite.flip_h = self.velocity.x < 0
		Vector2(0, 1):
			$AnimatedSprite.animation = "down"
		Vector2(0, -1):
			$AnimatedSprite.animation = "up"
	$AnimatedSprite.play()
			
func move_player(delta: float):
	self.position += self.velocity * speed * delta
	self.position.x = clamp(self.position.x, 0, self.screen_size.x - (self.frames.get_frame($AnimatedSprite.animation, 0).get_size().x / 2))
	self.position.y = clamp(self.position.y, 0, self.screen_size.y - (self.frames.get_frame($AnimatedSprite.animation, 0).get_size().y / 2))

func _on_Player_body_entered(body):
	self.hide()
	self.emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)


func get_locked_mode():
	return self.lockedMode

func set_locked_mode(mode: bool):
	self.lockedMode = mode
