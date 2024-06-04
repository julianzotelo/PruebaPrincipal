class_name  player

extends CharacterBody2D

signal player_hit()

var SPEED = 300.0
const JUMP_VELOCITY = -400.0

var direction = Vector2.ZERO
var coyote_time = 0.1
var coyote_time_counter = 0
var dash_speed = 1000
var dash_duration = 0.2
var cooldown = 1 * 1000
var last_dash = Time.get_ticks_msec()
var normal_speed = 300
var dir_dash 
var last_hit = 0
var duracion_inmunidad = 1 * 1000

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _input(event):
	if Input.is_action_just_pressed("dash"):
		start_dash()
		
func is_dashing():
	return not $TimerDash.is_stopped()

func start_dash():
	var time_now = Time.get_ticks_msec()
	if (time_now - last_dash) < cooldown:
		return
	dir_dash = direction
	last_dash = time_now
	$TimerDash.wait_time = dash_duration
	$TimerDash.start()

func _physics_process(delta):
	direction = Input.get_axis("Izquierda", "Derecha")
	SPEED = normal_speed
	if(is_dashing()):
		SPEED = dash_speed
		direction = dir_dash
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
	if not is_dashing():
		if  Input.is_action_pressed("Izquierda"):
			$Sprite2D.flip_h = true
		elif  Input.is_action_pressed("Derecha"):
			$Sprite2D.flip_h = false
	velocity.x = direction * SPEED
	if direction:
		velocity.x = direction * SPEED
		if not $Sprite2D/AnimationPlayer.current_animation == 'char_kill':
			$Sprite2D/AnimationPlayer.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func _on_area_2d_body_entered(body): 
	if body is Slime :
		body.vive=false;
		body.velocity.x = 0
		body.animation_player.play("Dead")
		$Sprite2D/AnimationPlayer.play("char_kill")

func _on_area_cuerpo_body_entered(body):
	var time_now = Time.get_ticks_msec()
	if (time_now - last_hit) < duracion_inmunidad:
		return
	if body is Slime :
		player_hit.emit()
		last_hit = Time.get_ticks_msec()
		$Sprite2D/AnimationPlayer.play("hurt")
		$TimerInmunidad.wait_time = duracion_inmunidad
		$TimerInmunidad.start()
			
func _on_animation_player_animation_finished(anim_name):
	if not (Input.is_action_pressed("Derecha") or Input.is_action_pressed("Izquierda")):
		$Sprite2D/AnimationPlayer.play("RESET")
