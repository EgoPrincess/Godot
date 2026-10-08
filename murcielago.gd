extends CharacterBody2D

var direction = 1
const SPEED = 500.0
var death = false
var cayendo = false

var limite_izquierdo = 0
var limite_derecho = 2000


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
	
	# Mover el murcielago
	velocity.x = SPEED * direction
	
	# Llegar al limite derecho
	if global_position.x >= limite_derecho:
		direction = -1
		$AnimatedSprite2D.flip_h = true
	
	# Llegar al limite izquierdo
	elif global_position.x <= limite_izquierdo:
		direction = 1
		$AnimatedSprite2D.flip_h = false
	
	move_and_slide()


func _on_kill_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("jugador"):
		body.velocity.y = -443
		death = true
		cayendo = true
		$AnimatedSprite2D.play("Death")


func _on_animated_sprite_2d_animation_finished() -> void:
	pass
