extends Area2D

signal hit

export var speed = 400 # player speed in px/sec
var screen_size # game window size

var velocity = Vector2.ZERO # the players movement vector
var max_speed = 500
var direction = PI/2
var rotation_speed = PI/18
var attenuation = 0.98

func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite.animation = "up"
	hide()
	
func _process(delta):
	var acceleration = Vector2.ZERO # the players movement vector
	
	if Input.is_action_pressed("move_right"):
		direction += rotation_speed
	if Input.is_action_pressed("move_left"):
		direction -= rotation_speed
	if Input.is_action_pressed("move_down"):
		pass
	if Input.is_action_pressed("move_up"):
		acceleration.y -= 20
		acceleration = acceleration.rotated(direction)
		 
	velocity += acceleration
	velocity = velocity.clamped(max_speed)
	velocity *= attenuation
	
	if Input.is_action_just_released("move_up"):
		$AnimatedSprite.stop()
	elif Input.is_action_just_pressed("move_up"):
		$AnimatedSprite.play()
		
	position += velocity * delta

	if position.x > screen_size.x:
		position.x -= screen_size.x
	elif position.x < 0:
		position.x += screen_size.x
			
	if position.y > screen_size.y:
		position.y -= screen_size.y
	elif position.y < 0:
		position.y += screen_size.y
	
	if rotation > PI * 2:
		rotation -= PI * 2
	elif rotation < -PI * 2:
		rotation += PI * 2
	
	$AnimatedSprite.rotation = direction
	


func _on_Player_body_entered(body):
	hide() # player disappears after being hit
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
	

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
