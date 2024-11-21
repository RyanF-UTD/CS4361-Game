extends CharacterBody2D
# Constants
const CHASE_SPEED = 150  # Speed when chasing the player
const GRAVITY = 900        # Gravity force
# Variables
var player = null
var state = "Idle"  # States: "Idle", "Flying", "Attack_Side", "Death"

func _ready():
	# Connect signals
	$Detection.connect("body_entered", Callable(self, "_on_area_body_entered"))
	$Detection.connect("body_exited", Callable(self, "_on_area_body_exited"))

func _physics_process(delta):
		# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0  # Reset vertical velocity on the floor
		
	match state:
		"Idle":
			idle_logic()
		"Flying":
			flying_logic()
		"Attack_Side":
			attacking_logic()

# Logic for idle state
func idle_logic():
	$Animation.play("Idle")

# Logic for flying state
func flying_logic():
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity.x = direction.x * CHASE_SPEED
		if direction.x < 0:
			$Animation.flip_h = true
		elif direction.x > 0:
			$Animation.flip_h = false
		$Animation.play("Flying")
		move_and_slide()
	else:
		state = "Idle"

# Logic for attacking state
func attacking_logic():
	$Animation.play("Attack_Side")
	velocity = Vector2.ZERO

# Signal: Player enters detection area
func _on_area_body_entered(body):
	if body.is_in_group("Player") and state == "Idle":
		player = body
		state = "Flying"

# Signal: Player exits detection area
func _on_area_body_exited(body):
	if body == player:
		player = null
		state = "Idle"


# Signal: Detect collision with the player
func _on_body_entered(body):
	if body.is_in_group("Player") and state == "Flying":
		state = "Attack_Side"
		body.die()
