extends Area2D
signal hit

#@export keyword allows for setting in the Inspector tab on the right
@export var speed = -10 #movement speed of floppy
var screen_size #size of game window

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	#hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# SPACEBAR/UP ARROW TO JUMP
	var jump = Input.is_action_just_pressed("jump") #action variable for a jump
	var velocity = Vector2.ZERO						#player's movement vector
	
	##checks if collision is not disabled, if not, apply gravity
	#if $CollisionShape2D.disabled:
	#if the Player jumps, move up by a couple of pixels and reset speed of gravity
	# otherwise, exponentially add gravity
	if jump:
		speed = -10
		velocity.y -= 12000
	else:
		speed += 3
		velocity.y += speed
		
	print(position) #temp used to debug
	$AnimatedSprite2D.play()
	
	position += velocity * delta						#ensures consistency with frames
	position = position.clamp(Vector2.ZERO, screen_size) #prevents Player from leaving screen
	
#checks if a body comes in contact with the Player
func _on_body_entered(body):
	hide()		#hides the Player if touched by a pipe
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

#starts/restarts the Player position for a new game
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
