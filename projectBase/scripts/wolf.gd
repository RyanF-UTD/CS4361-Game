extends CharacterBody2D

# Constants
const CHASE_SPEED = 150  # Speed when chasing the player
const BARK_DURATION = 3  # Duration of barking before chasing
const GRAVITY = 900        # Gravity force
# Variables
var player = null
var state = "idle"  # States: "idle", "barking", "chasing", "attacking"

func _ready():
	# Connect signals
	$Detection.connect("body_entered", Callable(self, "_on_area_body_entered"))
	$Detection.connect("body_exited", Callable(self, "_on_area_body_exited"))
	$Timer.connect("timeout", Callable(self, "_on_timer_timeout"))

func _physics_process(delta):
		# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0  # Reset vertical velocity on the floor
		
	match state:
		"idle":
			idle_logic()
		"barking":
			barking_logic()
		"chasing":
			chasing_logic()
		"attacking":
			attacking_logic()

# Logic for idle state
func idle_logic():
	$Animation.play("idle")

# Logic for barking state
func barking_logic():
	$Animation.play("bark")
	if not $Audio.playing:
		$Audio.play()

# Logic for chasing state
func chasing_logic():
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity.x = direction.x * CHASE_SPEED
		if direction.x < 0:
			$Animation.flip_h = false
		elif direction.x > 0:
			$Animation.flip_h = true
		$Animation.play("run")
		move_and_slide()
	else:
		state = "idle"

# Logic for attacking state
func attacking_logic():
	$Animation.play("attack")
	velocity = Vector2.ZERO

# Signal: Player enters detection area
func _on_area_body_entered(body):
	if body.is_in_group("Player") and state == "idle":
		player = body
		state = "barking"
		$Timer.start(BARK_DURATION)

# Signal: Player exits detection area
func _on_area_body_exited(body):
	if body == player:
		player = null
		state = "idle"

# Signal: Timer completes (barking ends)
func _on_timer_timeout():
	if state == "barking":
		state = "chasing"

# Signal: Detect collision with the player
func _on_body_entered(body):
	if body.is_in_group("Player") and state == "chasing":
		state = "attacking"
		body.die()
