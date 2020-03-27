local vec2 = require("source.tools.vec2")
local class = require("source.packages.middleclass")
local Person = require("source.objects.Person")

local BasicEnemy = class("BasicEnemy", Person)

function BasicEnemy:initialize(x,y,w,h, moveSpeed)
	Person:initialize(x,y,w,h)
	self.accuracy = 1
	self.moveSpeed = moveSpeed
end


function BasicEnemy:draw()
	love.graphics.setColor(0, 255, 0)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	love.graphics.setColor(255,255,255)
end


function BasicEnemy:update(dt)
	self.x = self.x - self.moveSpeed*dt
end 


function BasicEnemy:load()
	renderer:addRenderer(self,1)
	gameLoop:addLoop(self,1)

end


return BasicEnemy