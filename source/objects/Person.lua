local vec2 = require("source.tools.vec2")
local class = require("source.packages.middleclass")
local Person = class("Person")

function Person:initialize(x, y, w, h, r, collider, animation)
	self.x, self.y = x, y
	self.w, self.h = w, h
	self.r = r
	self.health = 100
	self.baseDmg = 1
	self.currentDmg = self.baseDmg
	self.collider = collider
	self.animation = animation
	self.maxHealth = 100
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

function Person:interact(dmg_dealt)
	self.health = self.health - dmg_dealt
	print(self.health)
end

return Person