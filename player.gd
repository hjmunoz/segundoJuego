extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:
	# 1. Gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 2. Salto (Flecha arriba)
	if Input.is_action_just_pressed("move_up") and is_on_floor():
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


func _on_detector_dañó_body_entered(body: Node2D) -> void:
	if body.is_in_group("Villanos"):
		# 1. Iniciamos el sonido de inmediato
		$SonidoMuerte.play()
		
		# 2. En lugar de borrar el nodo, lo hacemos invisible
		# Esto hace que ante tus ojos el PJ "desaparezca" al segundo 0
		visible = false 
		
		# 3. Desactivamos sus colisiones para que no lo sigan golpeando 
		# mientras el sonido termina de sonar
		$CollisionShape2D.set_deferred("disabled", true)
		
		# 4. Detenemos su movimiento para que no se escuche que sigue caminando
		set_physics_process(false)
		
		# 5. Esperamos a que el sonido termine de sonar en la oscuridad
		await $SonidoMuerte.finished 
		
		# 6. Ahora que el sonido acabó, lo borramos de verdad
		queue_free()
