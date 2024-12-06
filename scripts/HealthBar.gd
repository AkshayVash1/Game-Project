extends ProgressBar

@export var hp_label: Label

var green = Color(0, 1, 0)
var yellow = Color(1, 1, 0)
var red = Color(1, 0, 0)
var bright_red = Color(1, 0, 0.2)
var dark_red = Color(0.5, 0, 0)
var is_flashing = false
var flash_timer: Timer

func _ready() -> void:
	flash_timer = Timer.new()
	flash_timer.wait_time = 0.5
	flash_timer.one_shot = false
	flash_timer.stop()
	add_child(flash_timer)
	## cannot be updated every frame or the timer resets
	flash_timer.connect("timeout", Callable(self, "_on_flash_timer_timeout"))
	hp_label.scale = scale

## updates every frame
func _process(delta: float) -> void:
	var progress_value = value / max_value
	
	if progress_value > 0.5:
		modulate = green
		stop_flashing()
	elif progress_value > 0.2:
		modulate = yellow
		stop_flashing()
	elif progress_value > 0:
		if get_parent().name == "PlayerData":
			if not is_flashing:
				modulate = bright_red
				is_flashing = true
				flash_timer.start()
		else:
			modulate = bright_red
	else:
		modulate == dark_red
		stop_flashing()

func stop_flashing() -> void:
	if is_flashing:
		is_flashing = false
		flash_timer.stop()

func _on_flash_timer_timeout() -> void:
	modulate = bright_red if modulate == dark_red else dark_red

func _on_value_changed(value: float) -> void:
	hp_label.text = "HP: %d/%d" % [int(value), int(max_value)]
	
func reduce_health(health_to_loose: int) -> void:
	var target_value = value - max_value * 0.01 * health_to_loose
	if target_value < 0:
		target_value = 0
	var tween = get_tree().create_tween()
	tween.tween_property(self, "value", target_value, 0.5)
