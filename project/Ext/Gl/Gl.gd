extends Node

class_name GL, "res://Ext/Gl/icon.png"

#表格文件文件夹路径
export(String) var table_root_path = 'res://Table'
#需要导入的表格列表
export(Array, String) var table_name_list
#表格后缀
export(String) var suffix = '.dat'

export(bool)var is_debugging = false

var _csv_dic = {}
onready var random_seed_array = rand_seed(OS.get_system_time_secs())
#onready var random_seed = random_seed_array[0]

# 增加个log dictionary做下log的格式化
# 以后再说吧。。。
# export var standar_log_dictionary:Dictionary = {}



func _ready():
	seed(random_seed_array[0])

func _change_type(type:String, value:String):
	match type:
		"INT":
			return int(value)
		'FLOAT':
			return float(value)
		'BOOL':
			return bool(value)
		'STRING':
			return value
		"ARRAY":
			if value == "_null":
				return []
			return value.split(";")
		"INTARRAY":
			if value == "_null":
				return []
			var _temp = value.split(";")
			var result:PoolIntArray
			for _int in _temp:
				result.append(int(_int))
			return result
	assert(false)

func _build_table(_csv_name:String):
	var _f_name = table_root_path + "/" + _csv_name + suffix
	var _f = File.new()
	_f.open(_f_name, File.READ)
	var _arr = {}
	var _header = _f.get_csv_line()
	var _type = _f.get_csv_line()
#	略过备注行
	_f.get_csv_line()
	while _f.get_position()<_f.get_len():
		var _temp = _f.get_csv_line()
		var _pair = {}
		var __arr = []
		var __arr_head = ""
		var i = 0
		while(i<_header.size()):
			var _key = _header[i]
			var _value = _change_type(_type[i], _temp[i])
			var _split_key = _key.split('_')
#			识别最后的是不是数字
			if String(int(_split_key[-1])) != _split_key[-1]:
#				最后如果不是数字，直接等于这个值就行
				_pair[_key] = _value
			else:
#				最后如果是数字
#				就往后再读几个
#				把带数字结尾的key还原成原来的
				_key = ""
				for j in _split_key.size()-1:
					if j != _split_key.size()-2:
						_key+=(_split_key[j]+'_')
					else:
						_key+=_split_key[j]
#				如果_pair里面已经有这个key了，就直接接到后面去；没有的话新建一个数组存放
				if _key in _pair.keys() and typeof(_pair[_key]) == TYPE_ARRAY:
					_pair[_key].append(_value)
				else:
					_pair[_key] = [_value]
			i+=1
		
		_arr[_pair['id']] = _pair
	_f.close()
	_csv_dic[_csv_name] = _arr
	pass

func has_table(table_name:String)->bool:
	return _csv_dic.has(table_name)

func get_table(table_name:String)->Dictionary:
	return _csv_dic[table_name]

func get_entry(table_name:String, id:int)->Dictionary:
	if id == -1:
		return {}
	return get_table(table_name)[id]

func get_value(table_name:String, id:int, key:String):
	if id == -1:
		return null
	return get_entry(table_name, id)[key]

func get_game_config(key:String):
	var value = get_table("game_config")[key]["value"]
	var type = get_table("game_config")[key]["type"]
	return _change_type(type, value)

#[[value, weight], [value, weight], ...]
func random_from_weights(value_weight_pairs:Array):
	var _arr = value_weight_pairs
	var sum_weight = [0,]
	for i in range(_arr.size()):
		sum_weight.append(sum_weight[-1]+_arr[i][1])
	var _i = randf()*sum_weight[-1]
	for i in range(_arr.size()):
		if sum_weight[i]<=_i and sum_weight[i+1]>_i:
			return _arr[i][0]

func set_from_dic(obj:Object, dic:Dictionary):
	for key in dic.keys():
		obj.set(key, dic[key])

func set_from_entry(obj:Object, table_name:String, index:int):
	var dic = get_entry(table_name, index)
	set_from_dic(obj, dic)

func between(value, left, right, equal_left = false, equal_right = false)->bool:
	return (value>left or (equal_left and value == left)) and (value<right or (value == right and equal_right))

func Vector2_clamp(vec:Vector2, _min:float, _max:float):
	return Vector2(clamp(vec.x, _min, _max), clamp(vec.y, _min, _max))

func load_game_res(table_name:String, id:int, key:String):
	return load(get_value(table_name, id, key))

func clamp_zero(num):
	return clamp(num, 0, num)

func array_link(arr1:Array, arr2:Array)->Array:
	var _arr = arr1.duplicate()
	for i in arr2:
		_arr.append(i)
	return _arr

func random_by_weight(pair_array:Array):
	return random_from_weights(pair_array)

#[content, weight]
func choose_by_weight(pair_array:Array, choose_num:int, put_back:bool=false)->Array:
	var results:Array = []
	if choose_num>=pair_array.size():#如果选择的数字太多配对太少
		for pair in pair_array:
			results.append(pair[0])
	else:#如果选择的数量少于数组里面的数量
		var _temp_pair_array = pair_array.duplicate()
		for k in range(choose_num):
			var result_pair
			var sum_weight = [0,]
			for i in range(_temp_pair_array.size()):
				sum_weight.append(sum_weight[-1]+_temp_pair_array[i][1])
			var _i = randf()*sum_weight[-1]
			for i in range(_temp_pair_array.size()):
				if sum_weight[i]<=_i and sum_weight[i+1]>_i:
					result_pair = _temp_pair_array[i]
					break
			results.append(result_pair[0])
			if !put_back:
				_temp_pair_array.erase(result_pair)
	return results

func clamp_vector2(v0:Vector2, v_min:Vector2, v_max:Vector2)->Vector2:
	var vec:Vector2
	vec.x = clamp(v0.x, v_min.x, v_max.x)
	vec.y = clamp(v0.y, v_min.y, v_max.y)
	return vec


func clear_all_children(_node:Node):
	for child in _node.get_children():
		child.queue_free()

func choose(_arr:Array):
	return _arr[randi() %_arr.size()]
	pass

func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()
	return files

func _print(msg):
	if is_debugging:
		print(msg)
