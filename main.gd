extends Node3D

# Esto crea una casilla en el Inspector para que arrastremos nuestra escena Card
@export var card_scene: PackedScene 

var first_card = null
var second_card = null
var can_click: bool = true

func _ready():
	generar_tablero()

func generar_tablero():
	# Arreglo con los identificadores de nuestras 8 cartas (4 pares)
	var ids = [1, 1, 2, 2, 3, 3, 4, 4] 
	ids.shuffle() # Mezcla el arreglo aleatoriamente
	
	var columnas = 4
	var espaciado = 1.5 # Distancia entre las cartas (ajústalo según veas)
	
	for i in range(ids.size()):
		# Instanciar (crear una copia) de nuestra carta
		var carta = card_scene.instantiate()
		add_child(carta)
		
		# Matemáticas para la cuadrícula:
		# i / columnas nos da la fila (0, 0, 0, 0, 1, 1, 1, 1)
		# i % columnas nos da la columna (0, 1, 2, 3, 0, 1, 2, 3)
		var fila = i / columnas
		var col = i % columnas
		
		# Posicionamos la carta en los ejes X y Z (Y es la altura, la dejamos en 0)
		carta.position = Vector3(col * espaciado, 0, fila * espaciado)
		
		# Le asignamos su valor y conectamos su señal al script principal
		carta.set_card_value(ids[i])
		carta.card_clicked.connect(_on_card_clicked)

func _on_card_clicked(carta):
	# Si el jugador está esperando a que se volteen cartas equivocadas, ignoramos el clic
	if not can_click: 
		return
	
	carta.flip()
	
	# Lógica del memorama
	if first_card == null:
		first_card = carta # Guardamos la primera selección
	else:
		second_card = carta # Guardamos la segunda selección
		can_click = false # Bloqueamos clics adicionales
		comprobar_pares()

func comprobar_pares():
	if first_card.card_id == second_card.card_id:
		# ¡Es un par!
		first_card.is_matched = true
		second_card.is_matched = true
		resetear_seleccion()
	else:
		# No coinciden, pausamos la ejecución 1 segundo antes de voltearlas
		await get_tree().create_timer(1.0).timeout
		first_card.flip()
		second_card.flip()
		resetear_seleccion()

func resetear_seleccion():
	first_card = null
	second_card = null
	can_click = true
