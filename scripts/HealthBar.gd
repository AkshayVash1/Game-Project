extends ProgressBar

var FullHealth = Color(0, 1, 0)
var HalfHealth = Color(1, 1, 0)
var LowHealth = Color(0.5, 0, 0)
var NoHealth = Color(0, 0, 0)

var minGreenHealth = 0.5
var minYellowHealth = 0.2
var minRedHealth = 0

var animation_name = "reduce_health"

func _ready() -> void:
	$Label.scale = scale

func _process(delta: float) -> void:
	var progress_value = value / max_value
	
	if progress_value > minGreenHealth:
		self_modulate = FullHealth
	elif progress_value > minYellowHealth:
		self_modulate = HalfHealth
	elif progress_value > minRedHealth && get_parent().name == "PlayerData":
		self_modulate = LowHealth
		if not $Animate.is_playing():
			$Animate.play("flash")
	else:
		self_modulate = NoHealth
		$Label.self_modulate = LowHealth

func _on_value_changed(value: float) -> void:
	$Label.text = "HP: %d/%d" % [int(value), int(max_value)]

func reduce_health(health_to_loose: int) -> void:
	var target_value = value - max_value * 0.01 * health_to_loose
	if target_value < 0:
		target_value = 0
	var animation = $Animate.get_animation(animation_name)
	if animation:
		animation.track_set_key_value(0, 0, value)
		animation.track_set_key_value(0, 1, target_value)
		$Animate.play(animation_name)

func enable_buttons() -> void:
	if get_parent().name == "PlayerData" && value != 0:
		%Actions.toggle_buttons(false)
