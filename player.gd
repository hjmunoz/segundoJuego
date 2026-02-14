extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -520.0

const DAGA_SCENE = preload("res://daga.tscn") 

func _physics_process(delta: float) -> void:
	# Gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Salto
	if Input.is_action_just_pressed("move_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# MOVIMIENTO
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction != 0:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play("player2")
		
		# GIRAR SIN TEMBLAR: Solo usamos flip_h
		if direction < 0:
			$AnimatedSprite2D.flip_h = true
			# Movemos el punto de disparo a la izquierda del cuerpo
			$puntoDisparo.position.x = -abs($puntoDisparo.position.x)
		else:
			$AnimatedSprite2D.flip_h = false
			# Movemos el punto de disparo a la derecha del cuerpo
			$puntoDisparo.position.x = abs($puntoDisparo.position.x)
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.stop()

	if Input.is_action_just_pressed("disparar"): 
		lanzar_daga()

	move_and_slide()

func lanzar_daga():
	var daga = DAGA_SCENE.instantiate()
	daga.global_position = $puntoDisparo.global_position
	
	# DIRECCIÓN DE LA DAGA: Ahora depende de flip_h, no de scale
	if $AnimatedSprite2D.flip_h:
		daga.direccion = -1
	else:
		daga.direccion = 1
		
	get_tree().root.add_child(daga)

func _on_detector_dañó_body_entered(body: Node2D) -> void:
	if body.is_in_group("Villanos"):
		$SonidoMuerte.play()
		visible = false 
		$CollisionShape2D.set_deferred("disabled", true)
		set_physics_process(false)
		await $SonidoMuerte.finished 
		queue_free()
