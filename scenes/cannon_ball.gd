extends RigidBody3D

@export var velocidad: float = 10.0

func disparar(direccion: Vector3) -> void:
	linear_velocity = direccion * velocidad
