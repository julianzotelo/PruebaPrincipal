class_name Slime
extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0
var vive :bool = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var character = $"../Character"
@onready var raycast_front = $RayCast2D
@onready var raycast_back = $RayCast2D2
@onready var sprite = $Sprite2D
@onready var animation_player = $Sprite2D/AnimationPlayer


func _ready():
	velocity.x = SPEED
	animation_player.play("move")
	
	
func _physics_process(delta):
	if not vive:
		return
	if (raycast_front.is_colliding() and raycast_front.get_collider() == character) or (raycast_back.is_colliding() and raycast_back.get_collider() == character):
		seguir_jugador()
	else:
		patrullar()
	
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

func patrullar():
	if is_on_wall():
		cambiar_direccion()
	else:
		mantener_direccion()

func cambiar_direccion():
	if not sprite.flip_h:
		velocity.x = SPEED
		sprite.flip_h = true
	else:
		velocity.x = -SPEED
		sprite.flip_h = false

func mantener_direccion():
	if sprite.flip_h:
		velocity.x = SPEED
	else:
		velocity.x = -SPEED

func seguir_jugador():
	var direccion = (character.global_position - global_position).normalized()
	velocity.x = direccion.x * SPEED * 1.5
	sprite.flip_h = velocity.x > 0
	move_and_slide()

func matar():
	queue_free()
