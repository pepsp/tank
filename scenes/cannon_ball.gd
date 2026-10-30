extends RigidBody3D

@export var velocidad: float = 7.2
@export var rebotes := 0
@export var max_rebotes := 1
const TERRENO := 3


func disparar(direccion: Vector3) -> void:
	linear_velocity = direccion.normalized() * velocidad

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var v := state.linear_velocity
	if v.length() > 0.001:
		state.linear_velocity = v.normalized() * velocidad


func _on_body_entered(body: Node) -> void:
	if body.get_collision_layer_value(TERRENO):
		rebotes += 1
		if rebotes > max_rebotes:
			queue_free()
		return
	queue_free()
