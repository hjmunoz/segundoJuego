extends CharacterBody2D

var velocidad = 60.0
var direccion = 1

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += 900 * delta
	
	# LÓGICA DE GIRO MEJORADA
	var choca_con_algo = $RayoFrente.is_colliding()
	var objeto_al_frente = $RayoFrente.get_collider() # Esto nos dice QUÉ está tocando el rayo

	# Solo damos la vuelta si:
	# - Es una pared (is_on_wall)
	# - O no hay suelo (vacío)
	# - O el rayo toca algo que NO es el jugador (para que el jugador sí pueda tocarlo)
	if is_on_wall() or not $RayCastAbajo.is_colliding():
		dar_la_vuelta()
	elif choca_con_algo and not objeto_al_frente.is_in_group("Player"):
		dar_la_vuelta()
		
	velocity.x = direccion * velocidad
	move_and_slide()

func dar_la_vuelta():
	direccion *= -1
	scale.x = -scale.x
	# Si tienes el sonido, lo tocamos con seguridad
	if has_node("CaminarVillano1"):
		$CaminarVillano1.play()
