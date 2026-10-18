extends Node3D

var player_speed: float = 6.0

var player: CharacterBody3D
var camera: Camera3D


func _ready() -> void:
	create_environment()
	create_ground()
	create_base()
	create_egg()
	create_player()


func _physics_process(delta: float) -> void:
	if player == null:
		return

	var input_dir := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)

	var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()

	player.velocity.x = direction.x * player_speed
	player.velocity.z = direction.z * player_speed

	if not player.is_on_floor():
		player.velocity.y -= 20.0 * delta
	else:
		player.velocity.y = 0.0

	player.move_and_slide()


func create_environment() -> void:
	var world_environment := WorldEnvironment.new()
	var environment := Environment.new()

	environment.background_mode = Environment.BG_SKY
	environment.sky = Sky.new()
	environment.sky.sky_material = ProceduralSkyMaterial.new()

	world_environment.environment = environment
	add_child(world_environment)

	var sunlight := DirectionalLight3D.new()
	sunlight.rotation_degrees = Vector3(-50, -30, 0)
	sunlight.light_energy = 1.2
	add_child(sunlight)

	camera = Camera3D.new()
	camera.position = Vector3(10, 10, 14)
	camera.look_at(Vector3.ZERO, Vector3.UP)
	camera.current = true
	add_child(camera)


func create_ground() -> void:
	var ground := StaticBody3D.new()
	ground.position.y = -0.5

	var mesh_instance := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = Vector3(40, 1, 40)
	mesh_instance.mesh = mesh

	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.25, 0.65, 0.3)
	mesh_instance.material_override = material
	ground.add_child(mesh_instance)

	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(40, 1, 40)
	collision.shape = shape
	ground.add_child(collision)

	add_child(ground)


func create_base() -> void:
	var base := MeshInstance3D.new()
	var mesh := BoxMesh.new()

	mesh.size = Vector3(8, 0.3, 8)
	base.mesh = mesh
	base.position = Vector3(0, 0.2, 0)

	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.2, 0.45, 1.0)
	base.material_override = material

	add_child(base)


func create_egg() -> void:
	var egg := MeshInstance3D.new()
	var mesh := SphereMesh.new()

	mesh.radius = 0.7
	mesh.height = 1.5
	egg.mesh = mesh
	egg.position = Vector3(0, 1.2, -3)

	var material := StandardMaterial3D.new()
	material.albedo_color = Color(1.0, 0.8, 0.15)
	egg.material_override = material

	add_child(egg)


func create_player() -> void:
	player = CharacterBody3D.new()
	player.name = "Player"
	player.position = Vector3(0, 1.2, 4)

	var mesh_instance := MeshInstance3D.new()
	var capsule := CapsuleMesh.new()
	capsule.radius = 0.5
	capsule.height = 1.8
	mesh_instance.mesh = capsule

	var material := StandardMaterial3D.new()
	material.albedo_color = Color(1.0, 0.35, 0.2)
	mesh_instance.material_override = material
	player.add_child(mesh_instance)

	var collision := CollisionShape3D.new()
	var shape := CapsuleShape3D.new()
	shape.radius = 0.5
	shape.height = 1.8
	collision.shape = shape
	player.add_child(collision)

	add_child(player)
