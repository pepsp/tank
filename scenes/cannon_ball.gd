extends RigidBody3D

@export var velocidad: float = 7.2


func disparar(direccion: Vector3) -> void:
	linear_velocity = direccion.normalized() * velocidad

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var v := state.linear_velocity
	if v.length() > 0.001:
		state.linear_velocity = v.normalized() * velocidad
