local vec2 = require("source.tools.vec2")
local class = require("source.packages.middleclass")

local Person = class("Person")

function Person:initialize(x, y, w, h, collider)
	self.x, self.y = x, y
	self.w, self.h = w, h
	self.health = 100
	self.dmgdealing = 1
	self.collider = collider
end

function Person:load()
	renderer:addRenderer(self)
	gameLoop:addLoop(self)
end

function Person:update(dt)
	-- This function is not required
end

function Person:draw()
	--self.animation:draw() -- This will be the only method called

	love.graphics.setColor(255, 0, 0)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	love.graphics.setColor(255, 255, 255)
end

function Person:update()

end

function Person:load()
	renderer:addRenderer(self)
	gameLoop:addLoop(self)

end


return Person