
extends Node3D

@onready var camera: Camera3D = $Camera3D

func _ready():
	var limites = obtener_limites_visibles()

	print("ESQUINAS VISIBLES DEL PISO:")

	for punto in limites:
		print(punto)


func obtener_limites_visibles() -> Array[Vector3]:
	var pantalla = camera.get_viewport().get_visible_rect().size

	var esquinas = [
		Vector2(0, 0),
		Vector2(pantalla.x, 0),
		Vector2(pantalla.x, pantalla.y),
		Vector2(0, pantalla.y)
	]

	var plano_piso = Plane(Vector3.UP, 0.0)
	var puntos: Array[Vector3] = []

	for esquina in esquinas:
		var origen = camera.project_ray_origin(esquina)
		var direccion = camera.project_ray_normal(esquina)

		var punto = plano_piso.intersects_ray(
			origen, direccion
		)

		if punto != null:
			puntos.append(punto)

	return puntos
