extends CharacterBody2D

var direction = 1
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var death = false

var angulo = -PI / 2
const DISTANCIA_BOLA = 51.55
const VELOCIDAD_BOLA = 2.5


func _ready() -> void:
	$AnimatedSprite2D.play("Run")
	$Fireball/AnimatedSprite2D.play("Run")


func _physics_process(delta: float) -> void:
	
	# Girar la bola en sentido horario
	angulo += VELOCIDAD_BOLA * delta
	
	$Fireball.position.x = cos(angulo) * DISTANCIA_BOLA
	$Fireball.position.y = sin(angulo) * DISTANCIA_BOLA
	
	# Girar la animacion segun el movimiento de la bola
	$Fireball.rotation = angulo + PI / 2
	
	if death:
		return
	
	velocity.x = SPEED * direction
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Saltar los obstaculos
	if $SaltarAbajo.is_colliding() and is_on_floor() and not $SaltarArriba.is_colliding():
		velocity.y = JUMP_VELOCITY
	
	# Girar al llegar a un borde
	if not $Caer.is_colliding() and is_on_floor() and not $DetectarSuelo.is_colliding():
		direction = -direction
		
		$Caer.target_position.x = -$Caer.target_position.x
		$SaltarAbajo.target_position.x = -$SaltarAbajo.target_position.x
		$SaltarArriba.target_position.x = -$SaltarArriba.target_position.x
		$DetectarSuelo.position.x = -$DetectarSuelo.position.x
		
		$AnimatedSprite2D.flip_h = direction < 0
	
	move_and_slide()


func _on_morir_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("jugador") and not death:
		body.velocity.y = -443
		death = true
		velocity = Vector2.ZERO
		$AnimatedSprite2D.play("Death")


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "Death":
		queue_free()


func _on_fireball_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		body.morir()
