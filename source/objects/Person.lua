local vec2 = require("source.tools.vec2")
local class = require("source.packages.middleclass")
local Person = class("Person")

function Person:initialize(x, y, w, h, collider, animation)
	self.x, self.y = x, y
	self.w, self.h = w, h
	self.health = 100
	self.dmgdealing = 1
	self.collider = collider
	self.animation = animation
end

function Person:load()
	renderer:addRenderer(self)
	gameLoop:addLoop(self)
end

function Person:update(dt)
	self.animation:update(dt)
end

function Person:draw()
	self.animation:draw()
end

function Person:setAnimationPos(x, y)
	self.animation.x = x
	self.animation.y = y
end

return Person