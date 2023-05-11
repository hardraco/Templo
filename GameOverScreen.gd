extends Node



func _ready():
	
	$Sprite/MarginContainer/TextureButton.grab_focus()

func _physics_process(delta):
	if $Sprite/MarginContainer/TextureButton.is_hovered() == true:
		$Sprite/MarginContainer/TextureButton.grab_focus()
	if $Sprite/MarginContainer/TextureButton2.is_hovered() == true:
		$Sprite/MarginContainer/TextureButton2.grab_focus()
	if $Sprite/MarginContainer/TextureButton3.is_hovered() == true:
		$Sprite/MarginContainer/TextureButton3.grab_focus()

func _on_TextureButton_pressed():
	get_tree().change_scene("res://World/World.tscn")



func _on_TextureButton3_pressed():
	get_tree().quit()


func _on_TextureButton2_pressed():
	get_tree().change_scene("res://Creditos.tscn")
