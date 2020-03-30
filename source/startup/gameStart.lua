function gameStart()
	
	--love.window.setFullscreen(true)
	
	local windfield = require("source.packages.windfield")
	local Renderer = require("source.tools.renderer")
	local GameLoop = require("source.tools.gameLoop")
	local Music = require("source.tools.music")

	-- Create new world and set it's properties
	world = windfield.newWorld()
	world:setGravity(0, 100)
	world:addCollisionClass("Ground")
	world:addCollisionClass("Player")
	world:addCollisionClass("BasicEnemy")
	world:addCollisionClass("Attack")
	world:setQueryDebugDrawing(true)

	-- Global packages and variables
	anim8 = require("source.packages.anim8")
	renderer = Renderer:create()
	gameLoop = GameLoop:create()
	music = Music:new("audio/sound2.mp3")

	require("source.startup.resources")

	--This point from here on out is to be removed
	-- Create a ground and set it's properties
	ground = world:newRectangleCollider(0, 550, 500, 50)
	ground:setType("static")
	ground:setCollisionClass("Ground")
	
	ground2 = world:newRectangleCollider(600, 550, 900, 50)
	ground2:setType("static")
	ground2:setCollisionClass("Ground")

	-- Game Screen Settings
	-- TODO: ajustar a tela para um tamanho mais adequado

	g_width = love.graphics.getWidth()
	g_height= love.graphics.getHeight()

	love.graphics.setBackgroundColor(0.7, 0.7, 1)

	g_GameTime = 0 --timer do jogo
end