extends Node

func _handle_command(e, extra):
	match e:
		#FAde Out
		#Fades out the screen
		"FAO":
			print("Fade Out Initiated")
			await Globals._fade()
		#TRAnsport
		#Transport to Map ID X, run event Y, and place player at coordinates Z:W, if v == 0001 then flip character to the left 0002 for right or 0000 if you don't wanna flip
		#XXXX:YYYY:ZZZZ:WWWW:VVVV
		"TRA":
			var items = extra.split(":")
			print("Transporting")
			print(items)
			Globals._swap_scene(items[0], items[1], (Vector2(float(items[2]), float(items[3]))), items[4])
		"Swap Scene":
			var items = extra.split(":")
			print("Transporting")
			print(items)
			Globals._swap_scene(items[0], items[1], (Vector2(float(items[2]), float(items[3]))), items[4])
		#FAde In
		#Fades out the screen
		"FAI":
			print("Fade In Initiated")
			await Globals._fade_out()
		#PLayer Stop
		#Stops the player object from being controlled by tge player
		"PLS":
			print("Player Stopped")
			Globals.playerPlayable = false
		#PLayer Go
		#Lets the player object be controlled by the Player
		"PLG":
			print("Player Go")
			Globals.playerPlayable = true
		#END
		#Ends event and allows player object to be controlled by player
		"END":
			print("Command Ended")
			Globals.playerPlayable = true
