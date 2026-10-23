extends CharacterBody3D

@export var vel_giro: float = 13.0
@export var vel_giro_canon: float = 7.0
@export var velocidad = 9.0

func _physics_process(delta: float) -> void:
	
	# Rotación del cañón hacia el mouse
	var mouse_pos = get_viewport().get_mouse_position()
	var centro_pantalla = get_viewport().get_visible_rect().size / 2
	var direccion_mouse = mouse_pos - centro_pantalla
	if direccion_mouse.length() > 5:
		var angulo_objetivo = atan2(-direccion_mouse.x, -direccion_mouse.y)
		$tank/controller/cannon.rotation.y = lerp_angle($tank/controller/cannon.rotation.y, angulo_objetivo, vel_giro * delta)
		
	# Movimiento / rotación tanque
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()
	
	if direction:
		var rot_actual = $tank/controller/body2.rotation.y
		var angulo_cuerpo = atan2(-direction.x, -direction.z)
	
		var diferencia = wrapf(angulo_cuerpo - rot_actual, -PI, PI)
		
		var velocidad_final = velocidad
		
		if abs(diferencia) > PI / 2:
			if diferencia > 0:
				angulo_cuerpo = rot_actual + (diferencia - PI)
			else:
				angulo_cuerpo = rot_actual + (diferencia + PI)
			
			velocidad_final = velocidad * 0.8 
		
		velocity.x = direction.x * velocidad_final
		velocity.z = direction.z * velocidad_final
		
		$tank/controller/body2.rotation.y = lerp_angle(rot_actual, angulo_cuerpo, vel_giro_canon * delta)
		
	else:
		velocity.x = move_toward(velocity.x, 0, velocidad)
		velocity.z = move_toward(velocity.z, 0, velocidad)

	move_and_slide()
