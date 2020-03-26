local vec2 = require("tools.vec2")
local class = require("packages.middleclass")
local Person = require("objects.Person")

local BasicEnemy = class("BasicEnemy", Person)

function BasicEnemy:initialize(x,y,w,h)
	Person:initialize(x,y,w,h)
	self.accuracy = 1
end


function BasicEnemy:draw()
	love.graphics.setColor(0, 255, 0)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)

end


return BasicEnemy