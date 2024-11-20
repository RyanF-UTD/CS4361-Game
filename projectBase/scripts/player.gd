extends CharacterBody2D

# Constants
const SPEED = 200          # Maximum movement speed
const JUMP_FORCE = -400    # Jump force
const GRAVITY = 900        # Gravity applied to the character
const FRICTION = 800       # How quickly the character stops when no input is given
const ACCELERATION = 1200  # How quickly the character reaches full speed
# State definitions
enum PlayerState { IDLE, WALKING, JUMPING, DEAD }
var current_state = PlayerState.IDLE

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	# Handle input and state transitions
	if is_on_floor():
		if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			current_state = PlayerState.WALKING
			var direction = Input.get_axis("ui_left", "ui_right")
				# Flip the sprite based on movement direction
			if direction < 0:
				$Animation.flip_h = true
			elif direction > 0:
				$Animation.flip_h = false
		else:
			current_state = PlayerState.IDLE
	else:
		current_state = PlayerState.JUMPING
		# Update animation based on state
	match current_state:
		PlayerState.IDLE:
			$Animation.play("idle")
		PlayerState.WALKING:
			$Animation.play("run")
		PlayerState.JUMPING:
			$Animation.play("jump")
		PlayerState.DEAD:
			$Animation.play("dead")
	# Handle horizontal movement
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		# Accelerate towards the desired speed
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
	else:
		# Apply friction to stop sliding
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	# Handle jumping
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_FORCE

	# Apply movement
	move_and_slide()
