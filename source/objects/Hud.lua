local class = require("source.packages.middleclass")
local animation = require("source.objects.Animation")

local HUD = class("hud")

function HUD:initialize(x, y)
	self.x = x
	self.y = y
end

function HUD:load()
	gameLoop:addLoop(self)
end

function HUD:update(dt)
end

function HUD:draw()
	if player == nil then return end

	love.graphics.draw(sprites.coin, 1100 - self.x, self.y)
	love.graphics.print(player.money, 1100 - self.x + 36, self.y + 8)

	-- Health and mojo bars
	local interfaceQuad = love.graphics.newQuad(0, 0, 158, 53, 288, 53)
	love.graphics.draw(sprites.ui, interfaceQuad, 15, 30)

	local phealth = player.health / player.maxHealth
	local healthQuad = love.graphics.newQuad(158, 40, 130*phealth, 11, 288, 53)
	love.graphics.draw(sprites.ui, healthQuad, 42, 70)

	local pmojo = player.mojo / player.maxMojo
	local mojoQuad = love.graphics.newQuad(158, 26, 130*pmojo, 11, 288, 53)
	love.graphics.draw(sprites.ui, mojoQuad, 42, 56)

	love.graphics.setColor(1, 1, 1)


end

return HUD
