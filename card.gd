extends Area3D

signal card_clicked(card)

var card_id: int = -1
var is_flipped: bool = false
var is_matched: bool = false

func set_card_value(id: int):
	card_id = id
	
	# Creamos un material nuevo para esta carta
	var material = StandardMaterial3D.new()
	
	# Asignamos un color dependiendo de su ID
	match id:
		1: material.albedo_color = Color.RED
		2: material.albedo_color = Color.BLUE
		3: material.albedo_color = Color.GREEN
		4: material.albedo_color = Color.YELLOW
		
	# Le aplicamos ese material al FrontMesh que acabamos de crear
	$FrontMesh.material_override = material

func flip():
	if is_matched: return
	is_flipped = !is_flipped
	
	var tween = create_tween()
	# Rota 180 grados (PI en radianes) para mostrar la cara u ocultarla
	var target_rotation = PI if is_flipped else 0.0
	tween.tween_property(self, "rotation:z", target_rotation, 0.3)

func _on_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not is_flipped and not is_matched:
			emit_signal("card_clicked", self)
