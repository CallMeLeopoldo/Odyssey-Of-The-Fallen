local vec2 = require("source.tools.vec2")
local class = require("source.packages.middleclass")
local Person = require("source.objects.Person")
local animation = require("source.objects.Animation")

local BasicEnemy = class("BasicEnemy", Person)



function BasicEnemy:initialize(x,y,w,h,moveSpeed)
	local collider = world:newRectangleCollider(x, y, w, h)
	collider:setCollisionClass("BasicEnemy")

	Person.initialize(self,x,y,w,h,collider)

	self.anim = paint
	self.accuracy = 1
	self.moveSpeed = moveSpeed
end

function BasicEnemy:collider_pos_calc()
	local vecx = self.collider:getX() - self.w / 2
	local vecy = self.collider:getY() - self.h / 2

	return vecx,vecy

end


function BasicEnemy:draw()
	self.anim:draw()

end

function BasicEnemy:update(dt)
	self.anim:update(dt)
	local currentX = self.collider:getX()
	self.collider:setX(currentX - dt*self.moveSpeed)
	self.anim.x, self.anim.y = self:collider_pos_calc() 
end 


function BasicEnemy:load()

	renderer:addRenderer(self)
	gameLoop:addLoop(self)

end


return BasicEnemy