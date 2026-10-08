extends CharacterBody2D

var velocidad_x = 400
var salto = -443
var luna = false
var death = false
var normal

func _physics_process(delta: float) -> void:
	
	# Si estamos muertos no hacemos nada
	if death:
		return
	
	# Mover derecha
	if Input.is_action_pressed("mover_derecha"):
		velocity.x = velocidad_x
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("Run")
	
	# Mover izquierda
	elif Input.is_action_pressed("mover_izquierda"):
		velocity.x = -velocidad_x
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("Run")
	
	# No moverse horizontalmente
	else:
		velocity.x = 0
		$AnimatedSprite2D.play("idle")
	
	# Gravedad
	if not is_on_floor() and luna == false:
		velocity += get_gravity() * delta
	else:
		velocity += get_gravity() * delta * 0.5
	
	# toggle gravedad
	if Input.is_action_just_pressed("gravedad"):
		luna = not luna
	
	# Saltar
	if Input.is_action_just_pressed("saltar") and is_on_floor():
		velocity.y = salto
	
	if not is_on_floor():
		$AnimatedSprite2D.play("Fall")
	
	move_and_slide()

	for i in get_slide_collision_count():
		var colision = get_slide_collision(i)
		var cuerpo = colision.get_collider()
		
		if cuerpo.is_in_group("enemy"):
			normal = colision.get_normal()
			
			if abs(normal.x) > 0.5:
				death = true
				$AnimatedSprite2D.play("Death")
				await get_tree().create_timer(2.0).timeout
				get_tree().quit()
