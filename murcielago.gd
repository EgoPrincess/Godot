extends CharacterBody2D

var direction = 1
const SPEED = 500.0
const VELOCIDAD_VERTICAL = 150.0

var death = false
var cayendo = false

var limite_izquierdo = -6983
var limite_derecho = 9097


func _ready() -> void:
	$AnimatedSprite2D.play("Run")


func _physics_process(delta: float) -> void:
	
	if death:
		
		# Cuando muere empieza a caer
		if cayendo:
			velocity += get_gravity() * delta
			move_and_slide()
			
			# Cuando toca el suelo espera 1 segundo
			if is_on_floor():
				cayendo = false
				await get_tree().create_timer(1.0).timeout
				queue_free()
		
		return
	
	
	# Mover el murcielago horizontalmente
	velocity.x = SPEED * direction
	
	
	# Mantener la distancia del suelo
	if not $Mantener.is_colliding():
		# No detecta suelo -> baja
		velocity.y = VELOCIDAD_VERTICAL
		
	elif $Subir.is_colliding():
		# Hay obstaculo demasiado cerca -> sube
		velocity.y = -VELOCIDAD_VERTICAL
		
	else:
		# Esta a la distancia correcta
		velocity.y = 0
	
	
	# Llegar al limite derecho
	if global_position.x >= limite_derecho:
		direction = -1
		$AnimatedSprite2D.flip_h = true
	
	# Llegar al limite izquierdo
	elif global_position.x <= limite_izquierdo:
		direction = 1
		$AnimatedSprite2D.flip_h = false
	
	
	move_and_slide()
	
	# Comprobar si el murcielago ha chocado contra el jugador
	for i in get_slide_collision_count():
		var colision = get_slide_collision(i)
		var cuerpo = colision.get_collider()
		
		if cuerpo.is_in_group("jugador"):
			var normal = colision.get_normal()
			
			# Si el choque es lateral, mata al jugador
			if abs(normal.x) > 0.5:
				cuerpo.morir()


func _on_kill_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("jugador"):
		body.velocity.y = -443
		death = true
		cayendo = true
		$AnimatedSprite2D.play("Death")


func _on_animated_sprite_2d_animation_finished() -> void:
	pass
