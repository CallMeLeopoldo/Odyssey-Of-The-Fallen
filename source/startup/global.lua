function restart()
	player:restart(50, 400)
	currentLevel:restart()
	currentLevel:load()
	pauseScreen.paused = false
	pauseScreen:remove()
	music.music:play()
end