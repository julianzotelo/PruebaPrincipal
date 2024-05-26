class_name  player

extends CharacterBody2D

signal player_hit()

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var coyote_time = 0.1
var coyote_time_counter = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_on_floor():
		coyote_time_counter = coyote_time
		#$PJ/Anim.play("asd")
	else:
		coyote_time_counter -= delta
		

	if Input.is_action_just_pressed("Saltar") and coyote_time_counter > 0:
		velocity.y = JUMP_VELOCITY
		coyote_time_counter = 0
	if  Input.is_action_just_pressed("Izquierda"):
		$Sprite2D.flip_h = true
	elif  Input.is_action_just_pressed("Derecha"):
		$Sprite2D.flip_h = false
		
		
	var direction = Input.get_axis("Izquierda", "Derecha")
	if direction:
		velocity.x = direction * SPEED
		$Sprite2D/AnimationPlayer.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$Sprite2D/AnimationPlayer.play("RESET")


	move_and_slide()



func _on_area_2d_body_entered(body): 
	if body is Slime :
		body.vive=false;
		body.velocity.x = 0
		body.animation_player.play("Dead")


func _on_area_cuerpo_body_entered(body):
	if body is Slime :
		player_hit.emit()
