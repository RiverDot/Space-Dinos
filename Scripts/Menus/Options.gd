extends CanvasLayer

var open: bool = false

func _set_open(value: bool):
	open = value
	visible = open

func _ready():
	$Control/Sound_Options_Container/Master_Slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	$Control/Sound_Options_Container/Music_Slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	$Control/Sound_Options_Container/SFX_Slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	$Control/Sound_Options_Container/UI_Slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("UI")))


func _on_master_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))


func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))


func _on_ui_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("UI"), linear_to_db(value))



