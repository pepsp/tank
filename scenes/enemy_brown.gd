extends CharacterBody3D

@export var escena_cb: PackedScene
@export var max_cbs = 1
@export var vel_giro_canon: float = 3.2
@onready var punto_disparo: Marker3D = $tank/controller/cannon/cube/PuntoDisparo
@onready var cannon: Node3D = $tank/controller/cannon
@onready var area_3d: Area3D = $PlayerDetection

var active_cbs := 0
var objetivo: CharacterBody3D = null


func _physics_process(delta: float) -> void:
	objetivo = get_jugador_cercano()
	if objetivo:
		aiming(objetivo, delta)


func get_jugador_cercano() -> CharacterBody3D:
	var jugador_cercano: CharacterBody3D = null
	var distancia_minima: float = INF

	for body in area_3d.get_overlapping_bodies():
		if body == self:
			continue  # ignorarse a sí mismo
		if body.is_in_group("players"):
			var distancia = global_position.distance_squared_to(body.global_position)
			if distancia < distancia_minima:
				distancia_minima = distancia
				jugador_cercano = body

	return jugador_cercano


func aiming(blanco: Node3D, delta: float) -> void:
	var direccion = blanco.global_position - cannon.global_position
	direccion.y = 0
	if direccion.length_squared() < 0.001:
		return

	var angulo_objetivo = atan2(-direccion.x, -direccion.z)
	cannon.global_rotation.y = lerp_angle(cannon.global_rotation.y, angulo_objetivo, vel_giro_canon * delta)
