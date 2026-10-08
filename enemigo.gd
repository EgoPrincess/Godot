extends CharacterBody2D

var direction = 1
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var death = false


func _ready() -> void:
	$AnimatedSprite2D.play("Run")


func _physics_process(delta: float) -> void:
	
	if death:
		return
	
	velocity.x = SPEED + direction
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if $SaltarAbajo.is_colliding() and is_on_floor() and not $SaltarArriba.is_colliding():
		velocity.y =-443
	
	
	if not $Caer.is_colliding() and is_on_floor() and not $DetectarSuelo.is_colliding():
		direction = -direction
		$Caer.target_position.x = -$Caer.target_position.x
		$SaltarAbajo.target_position.x = -$SaltarAbajo.target_position.x
		$SaltarArriba.target_position.x = -$SaltarArriba.target_position.x
		$DetectarSuelo.position.x = -$DetectarSuelo.position.x
		velocity.x = -velocity.x
		$AnimatedSprite2D.flip_h = velocity.x < 0
	
	
	
	velocity.x = SPEED * direction
	
	move_and_slide()


func _on_kill_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("jugador"):
		body.velocity.y = -443
		death = true
		$AnimatedSprite2D.play("Death")


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "Death":
		queue_free()
