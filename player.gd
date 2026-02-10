extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:
	# 1. Gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 2. Salto (Flecha arriba)
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 3. Ataque (Espacio)
	if Input.is_action_just_pressed("ui_accept"):
		$ataque.play("atacar")

	# 4. Movimiento (D, A y Flechas)
	# Usamos "ui_left" y "ui_right" porque Godot ya incluye A, D y Flechas ahí
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction != 0:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.flip_h = (direction < 0)
		$AnimatedSprite2D.play("player2")
		
		# --- AJUSTE DE LA ESPADA ---
		# Si se aleja mucho, cambia el 7 por un número más pequeño como 5
		$Espada.position.x = 4 * direction  
		$Espada.scale.x = 0.04 * direction
		$Espada.z_index = 1 
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.stop()

	move_and_slide()
