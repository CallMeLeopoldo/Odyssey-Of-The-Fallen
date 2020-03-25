local vec2 = require("tools.vec2")
local class = require("tools.middleclass")

local Person = class("Person")


function Person:initialize(x,y,w,h)
	self.x,self,y = x,y
	self.health = 100
	self.dmgdealing = 1 
end

return Person