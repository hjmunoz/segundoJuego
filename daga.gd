extends Area2D

var velocidad = 600
var direccion = 1

func _physics_process(delta):
	# Movimiento constante de la daga
	position.x += velocidad * direccion * delta

# Esta es la función que se creó al conectar la señal
func _on_body_entered(body: Node2D) -> void:
	# Verificamos si lo que tocamos es un enemigo
	if body.is_in_group("Villanos"):
		body.queue_free() # El enemigo desaparece
		queue_free()      # La daga también desaparece al impactar
		
	elif body is TileMap:
		queue_free()
		
	
			
	
	# Opcional: Si toca el suelo (TileMap), la daga se rompe
	elif body is TileMap:
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Objetos"):
		area.queue_free()
		queue_free()
