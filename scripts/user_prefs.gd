class_name UserPrefs extends Resource

@export var audioSettings : Array[float] = [1.0,1.0,1.0,1.0]
@export var invertLook : bool
@export var lookSettings : Array[float] = [0.0, 0.0]
@export var crosshair : bool

func save():
	ResourceSaver.save(self, "user://user_prefs.tres")
	print("saved?")
	
	
static func load() -> UserPrefs:
	var res : UserPrefs = load("user://user_prefs.tres") as UserPrefs
	if !res:
		print("failed to load!")
		res = UserPrefs.new()
	return res 
