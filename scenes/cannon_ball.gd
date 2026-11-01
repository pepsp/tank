extends RigidBody3D

@export var velocidad: float = 5.2
@export var rebotes := 0
@export var max_rebotes := 1
const TERRENO := 3


func disparar(direccion: Vector3) -> void:
	linear_velocity = direccion.normalized() * velocidad

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var v := state.linear_velocity
	if v.length() > 0.001:
		state.linear_velocity = v.normalized() * velocidad
		var direccion := v.normalized()
		var objetivo := state.transform.origin + direccion

		state.transform = state.transform.looking_at(
			objetivo,
			Vector3.UP
		)


func _on_body_entered(body: Node) -> void:
	if body.get_collision_layer_value(TERRENO):
		rebotes += 1
		if rebotes > max_rebotes:
			destroy()
		return
	destroy()



func destroy():
	queue_free()
