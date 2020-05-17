local class = require("source.packages.middleclass")
local animation = require("source.objects.Animation")

local HUD = class("hud")

function HUD:initialize(x, y, player, time, enemy1, enemy2)
	self.x = x
	self.y = y
	self.player = player
	self.enemy1 = enemy1
	self.enemy2 = enemy2
end

function HUD:load()
	gameLoop:addLoop(self)
	--renderer:addRenderer(self)
end

function HUD:update(dt)
end

function HUD:draw()
	love.graphics.draw(sprites.health_and_mojo, self.x, self.y)
	love.graphics.draw(sprites.coin, 1100 - self.x, self.y)
	love.graphics.print(player.money, 1100 - self.x + 36, self.y + 8)

	local size, phealth = 289, self.player.health / self.player.maxHealth
	love.graphics.setColor(1, 0.2, 0.2)
	love.graphics.rectangle("fill",  self.x, self.y + 1 , size * phealth, 24.8)

	size = 209
	local pmojo = self.player.mojo / self.player.maxMojo
	love.graphics.setColor(.9, .9, 0)
	love.graphics.rectangle("fill",  self.x, self.y + 27 , size * pmojo, 15.5)

	love.graphics.setColor(1, 1, 1)


end

return HUD
