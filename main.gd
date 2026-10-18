extends Node3D

var player: CharacterBody3D
var joy_center := Vector2.ZERO
var joy_value := Vector2.ZERO
var joy_active := false
var joy_base: ColorRect
var joy_knob: ColorRect
var joy_radius := 55.0
var speed := 6.0


func _ready() -> void:
	make_world()
	make_ground()
	make_base()
	make_egg()
	make_player()
	make_controls()


func _physics_process(delta: float) -> void:
	var input_dir := joy_value

	input_dir.x += Input.get_action_strength("ui_right")
	input_dir.x -= Input.get_action_strength("ui_left")
	input_dir.y += Input.get_action_strength("ui_down")
	input_dir.y -= Input.get_action_strength("ui_up")
	input_dir = input_dir.limit_length(1.0)

	player.velocity.x = input_dir.x * speed
	player.velocity.z = input_dir.y * speed

	if not player.is_on_floor():
		player.velocity.y -= 20.0 * delta
	else:
		player.velocity.y = 0.0

	player.move_and_slide()


func make_world() -> void:
	var env := WorldEnvironment.new()
	var e := Environment.new()
	e.background_mode = Environment.BG_SKY
	e.sky = Sky.new()
	e.sky.sky_material = ProceduralSkyMaterial.new()
	env.environment = e
	add_child(env)

	var light := DirectionalLight3D.new()
	light.rotation_degrees = Vector3(-50, -30, 0)
	add_child(light)

	var cam := Camera3D.new()
	cam.position = Vector3(10, 10, 14)
	cam.look_at(Vector3.ZERO)
	cam.current = true
	add_child(cam)


func make_ground() -> void:
	var body := StaticBody3D.new()
	body.position.y = -0.5

	var mesh := BoxMesh.new()
	mesh.size = Vector3(40, 1, 40)
	var visual := MeshInstance3D.new()
	visual.mesh = mesh
	visual.material_override = mat(Color(0.25, 0.65, 0.3))
	body.add_child(visual)

	var col := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = mesh.size
	col.shape = shape
	body.add_child(col)
	add_child(body)


func make_base() -> void:
	var base := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = Vector3(8, 0.3, 8)
	base.mesh = mesh
	base.position = Vector3(0, 0.2, 0)
	base.material_override = mat(Color(0.2, 0.45, 1.0))
	add_child(base)


func make_egg() -> void:
	var egg := MeshInstance3D.new()
	var mesh := SphereMesh.new()
	mesh.radius = 0.7
	mesh.height = 1.5
	egg.mesh = mesh
	egg.position = Vector3(0, 1.2, -3)
	egg.material_override = mat(Color(1.0, 0.8, 0.15))
	add_child(egg)


func make_player() -> void:
	player = CharacterBody3D.new()
	player.name = "Player"
	player.position = Vector3(0, 1.2, 4)

	var visual := MeshInstance3D.new()
	var mesh := CapsuleMesh.new()
	mesh.radius = 0.5
	mesh.height = 1.8
	visual.mesh = mesh
	visual.material_override = mat(Color(1.0, 0.35, 0.2))
	player.add_child(visual)

	var col := CollisionShape3D.new()
	var shape := CapsuleShape3D.new()
	shape.radius = 0.5
	shape.height = 1.8
	col.shape = shape
	player.add_child(col)
	add_child(player)


func make_controls() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)

	var size := get_viewport().get_visible_rect().size
	joy_center = Vector2(95, size.y - 105)

	joy_base = ColorRect.new()
	joy_base.position = joy_center - Vector2(60, 60)
	joy_base.size = Vector2(120, 120)
	joy_base.color = Color(0.2, 0.2, 0.2, 0.5)
	layer.add_child(joy_base)

	joy_knob = ColorRect.new()
	joy_knob.size = Vector2(44, 44)
	joy_knob.color = Color(1, 1, 1, 0.8)
	layer.add_child(joy_knob)
	update_joystick()


func update_joystick() -> void:
	joy_knob.position = joy_center + joy_value * joy_radius - Vector2(22, 22)


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			if event.position.distance_to(joy_center) < 100:
				joy_active = true
				set_joy(event.position)
		else:
			joy_active = false
			joy_value = Vector2.ZERO
			update_joystick()

	elif event is InputEventScreenDrag and joy_active:
		set_joy(event.position)


func set_joy(pos: Vector2) -> void:
	joy_value = ((pos - joy_center) / joy_radius).limit_length(1.0)
	update_joystick()


func mat(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	return material
