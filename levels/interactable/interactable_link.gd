extends InteractableBase

@export var link: String


func interact() -> void:
	if get_tree().has_method("send_command"):
		get_tree().send_command("open_link", [link])
	else:
		OS.shell_open(link)
