local class = require("source.packages.middleclass")
local animation = require("source.objects.Animation")

local HUD = class("hud")

function HUD:initialize(x, y, player, time)
	self.x = x
	self.y = y
	self.player = player
	self.animation = animation:new(x, y - 10.5, sprites.hud_bit, 100, 100, '1-2', 1, time)
end

function HUD:load()
	gameLoop:addLoop(self)
	renderer:addRenderer(self)
end

function HUD:update(dt)
	self.animation:update(dt)
end

function HUD:draw()
	love.graphics.draw(sprites.health_and_mojo, self.x + 43.68, self.y)

	local size, phealth = 289, self.player.health / self.player.maxHealth
	love.graphics.setColor(1, 0.2, 0.2)	
	love.graphics.rectangle("fill",  self.x + 45, self.y + 1 , size * phealth, 24.8)
	
	size = 209
	local pmojo = self.player.mojo / self.player.maxMojo
	love.graphics.setColor(.9, .9, 0)
	love.graphics.rectangle("fill",  self.x + 79, self.y + 27 , size * pmojo, 15.5)
	
	love.graphics.setColor(1, 1, 1)
	
	self.animation:draw()

	-- Debug only
	love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", g_width - 250, 50, 220, 25)

	local accuracy = self.player.currentDmg / self.player.baseDmg
	
	if accuracy >= 0 then accuracy = " " .. accuracy end

    love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setFont(fonts.debug)
	love.graphics.print("Accuracy: " .. accuracy, g_width - 250, 50)
	

end

return HUD

