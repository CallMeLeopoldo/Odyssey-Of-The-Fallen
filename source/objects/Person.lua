local vec2 = require("source.tools.vec2")
local class = require("source.packages.middleclass")

local Person = class("Person")


function Person:initialize(x,y,w,h)
	self.x,self.y = x,y
	self.w, self.h = w,h
	self.health = 100
	self.dmgdealing = 1
end


function Person:draw()
	love.graphics.setColor(255, 0, 0)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)

end


return Person