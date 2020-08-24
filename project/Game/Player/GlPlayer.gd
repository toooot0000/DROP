extends Node

const SAVE_PATH = "user://save.sav"
const SAVE_LEVEL_PATH = "user://save_level.sav"
const DEBUG_PATH = "res://Debug/save.sav"

var current_level:int = 1
var level_states:Array = []
var music_volume:float = 1 setget set_music_volume
var effect_volume:float = 1 setget set_effect_volume

var is_new_player:bool = true
var is_border_guide_triggered:bool = false


func init():
	for level in Gl.all_level_num:
		level_states.append({
			'passed':false,
			'star':0
		})
	current_level = 1

func _ready():
	var f = File.new()
	if Gl.is_debugging:
		var dir = Directory.new()
		dir.remove(SAVE_PATH)
		dir.remove(SAVE_LEVEL_PATH)

	if !f.file_exists(SAVE_PATH):
		init()
		save()
		pass
	else:
		load_player_save()
	pass

func save():
	var f = File.new()
	f.open(SAVE_PATH, File.WRITE)
	f.store_string(ProjectSettings.get_setting("application/config/version"))
	f.store_string("\n")
	f.store_8(int(Gl.is_debugging))
	f.store_float(music_volume)
	f.store_float(effect_volume)
	f.store_64(current_level)
	
	f.store_8(int(is_border_guide_triggered))
	f.store_8(int(is_new_player))
	f.close()
	
	f.open(SAVE_LEVEL_PATH, File.WRITE)
	f.store_64(level_states.size())
	for i in level_states:
		f.store_8(int(i['passed']))
		f.store_8(i['star'])
	f.close()
	pass

func load_player_save():
	var f = File.new()
	f.open(SAVE_PATH, File.READ)
	var _version = f.get_line()
	var _is_debugging = f.get_8()
#	if _is_debugging:#如果之前的存档是debug存档，那么这次也就新建一份存档了
#		f.close()
#		init()
#		pass
	#	else:
	self.music_volume = f.get_float()
	self.effect_volume = f.get_float()
	self.current_level = f.get_64()
	self.is_border_guide_triggered = f.get_8()
	self.is_new_player = f.get_8()
	f.close()
	
	f.open(SAVE_LEVEL_PATH, File.READ)
	
	var level_number = f.get_64()
#	if level_number<Gl.all_level_num:#如果存档关卡比现有版本少
	for i in range(Gl.all_level_num):
		if i <=level_number:
			level_states.append({
				'passed':f.get_8(),
				'star':f.get_8()
			})
		else:
			level_states.append({
				'passed':false,
				'star':0
			})
#		pass
#	elif level_number == Gl.all_level_num:
#		for i in range(level_number):
#			level_states.append({
#				'passed':f.get_8(),
#				'star':f.get_8()
#			})
	f.close()
	pass

func pass_level(stars:int):
	level_states[current_level-1]["passed"] = true
	if level_states[current_level-1].has("star"):
		if level_states[current_level-1]["star"]<=stars:
			level_states[current_level-1]["star"] = stars
	else:
		level_states[current_level-1]["star"] = stars
	#如果到达最后一关就保持在最后一关
	current_level = clamp(current_level+1, 0, Gl.all_level_num)
	save()

func set_music_volume(value:float):
	music_volume = value
	var a = 0.001
	
	var k = a*(exp(1)-1)
	var b = -1-log(a)
	
	var vol = 60*(log(value*k + a) + b)
#	print(value)
#	print(vol)
	vol = clamp(vol, -80, 0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"), vol)
#	print(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("BGM")))
#	var music = AudioServer.get_bus_channels(0)
	pass

func set_effect_volume(value:float):
	effect_volume = value
	var a = 0.001
	
	var k = a*(exp(1)-1)
	var b = -1-log(a)
	
	var vol = 60*(log(value*k + a) + b)
#	print(value)
#	print(vol)
	vol = clamp(vol, -80, 0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effect"), vol)
#	print(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Effect")))
	pass
