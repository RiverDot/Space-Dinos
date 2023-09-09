extends Node

enum SFXType { GAME, UI }

@export var soundIns: PackedScene

func _play_sound(sound: AudioStream, type: SFXType, pitch: float = 1.0, volume: float = 1.0):
	var sfx: SFX = soundIns.instantiate()

	sfx.stream = sound
	sfx.pitch_scale = pitch
	sfx.volume_db = volume

	add_child(sfx)
	sfx.play()

	if type == SFXType.GAME:
		sfx.bus = "SFX"
		sfx.process_mode = Node.PROCESS_MODE_PAUSABLE
	elif type == SFXType.UI:
		sfx.bus = "UI"

func _destroy_game_sounds():
	for child in get_children():
		if child is SFX:
			if child.bus == "SFX":
				child.stop()
				child.queue_free()
