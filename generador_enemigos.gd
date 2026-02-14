extends Node2D

# 1. LA VARIABLE DEBE IR AQUÍ (Fuera de las funciones)
@export var enemigo_escena: PackedScene 

func _ready() -> void:
	# Esto es para que los números cambien de verdad cada vez que juegas
	randomize() 

func _on_timer_timeout() -> void:
	# Aquí es donde usamos la variable
	if enemigo_escena != null:
		var nuevo_enemigo = enemigo_escena.instantiate()
		
		# Ajustado para que no salgan debajo del suelo (Y = 140)
		var x_aleatoria = randf_range(0, 1000)
		var y_aleatoria = 0 
		
		nuevo_enemigo.position = Vector2(x_aleatoria, y_aleatoria)
		get_parent().add_child(nuevo_enemigo)
