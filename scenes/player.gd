
extends CharacterBody3D

@export var vel_giro: float = 13.0
@export var vel_giro_canon: float = 7.0
@export var velocidad: float = 9.0

@onready var cannon: Node3D = $tank/controller/cannon
@onready var body2: Node3D = $tank/controller/body2

func _process(delta: float) -> void:
	_apuntar_canon(delta)

func _physics_process(delta: float) -> void:
	_mover_tanque(delta)
	move_and_slide()

func _apuntar_canon(delta: float) -> void:
	var camara := get_viewport().get_camera_3d()
	if camara == null:
		return

	var mouse_pos := get_viewport().get_mouse_position()
	var origen := camara.project_ray_origin(mouse_pos)
	var dir := camara.project_ray_normal(mouse_pos)

	# Plano horizontal a la altura del cañón
	var plano := Plane(Vector3.UP, cannon.global_position.y)
	var punto = plano.intersects_ray(origen, dir)
	if punto == null:
		return

	var hacia_mouse: Vector3 = punto - cannon.global_position
	hacia_mouse.y = 0.0

	# Zona muerta: mouse casi encima del cañón
	if hacia_mouse.length() < 0.3:
		return

	# Frente del cañón = -Z
	var angulo_global := atan2(-hacia_mouse.x, -hacia_mouse.z)
	cannon.global_rotation.y = lerp_angle(cannon.global_rotation.y, angulo_global, vel_giro * delta)

func _mover_tanque(delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()

	if direction:
		var rot_actual: float = body2.rotation.y
		var angulo_cuerpo: float = atan2(-direction.x, -direction.z)
		var diferencia: float = wrapf(angulo_cuerpo - rot_actual, -PI, PI)
		var velocidad_final: float = velocidad

		# Si el giro es mayor a 90°, el tanque va en reversa en vez de girar
		if abs(diferencia) > PI / 2:
			if diferencia > 0:
				angulo_cuerpo = rot_actual + (diferencia - PI)
			else:
				angulo_cuerpo = rot_actual + (diferencia + PI)
			velocidad_final = velocidad * 0.8

		velocity.x = direction.x * velocidad_final
		velocity.z = direction.z * velocidad_final
		body2.rotation.y = lerp_angle(rot_actual, angulo_cuerpo, vel_giro_canon * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, velocidad)
		velocity.z = move_toward(velocity.z, 0, velocidad)
