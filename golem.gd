extends CharacterBody2D

var death = false


func _ready() -> void:
	$AnimatedSprite2D.play("Idle")


func _physics_process(delta: float) -> void:
	
	if death:
		return
	
	# Detectar jugador por la derecha
	if $Derecha.is_colliding():
		var cuerpo = $Derecha.get_collider()
		
		if cuerpo.is_in_group("jugador"):
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("Punch")
			cuerpo.morir()
	
	# Detectar jugador por la izquierda
	elif $Izquierda.is_colliding():
		var cuerpo = $Izquierda.get_collider()
		
		if cuerpo.is_in_group("jugador"):
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("Punch")
			cuerpo.morir()


func _on_kill_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("jugador"):
		body.velocity.y = -443
		death = true
		$AnimatedSprite2D.play("Death")


func _on_animated_sprite_2d_animation_finished() -> void:
	
	if $AnimatedSprite2D.animation == "Death":
		queue_free()
	
	elif $AnimatedSprite2D.animation == "Punch":
		$AnimatedSprite2D.play("Idle")


func _on_morir_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("jugador"):
		body.velocity.y = -443
		death = true
		$AnimatedSprite2D.play("Death")
