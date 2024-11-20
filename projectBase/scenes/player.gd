extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 900
# State definitions
enum PlayerState { IDLE, WALKING, JUMPING, DEAD }
var current_state = PlayerState.IDLE

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	# Handle input and state transitions
	if is_on_floor():
		if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			current_state = PlayerState.WALKING
		else:
			current_state = PlayerState.IDLE
	else:
		current_state = PlayerState.JUMPING
		# Update animation based on state
	match current_state:
		PlayerState.IDLE:
			$AnimatedSprite2D.play("idle")
		PlayerState.WALKING:
			$AnimatedSprite2D.play("run")
		PlayerState.JUMPING:
			$AnimatedSprite2D.play("jump")
		PlayerState.DEAD:
			$AnimatedSprite2D.play("dead")
	# Handle horizontal movement
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)

	# Handle jumping
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Apply movement
	move_and_slide()
