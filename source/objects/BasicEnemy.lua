local vec2 = require("source.tools.vec2")
local class = require("source.packages.middleclass")
local Person = require("source.objects.Person")
local animation = require("source.objects.Animation")

local BasicEnemy = class("BasicEnemy", Person)

function BasicEnemy:initialize(x, y, w, h, moveSpeed)
	local collider = world:newRectangleCollider(x, y, w, h)
	collider:setCollisionClass("BasicEnemy")

	local anim = animation:new(x, y, paintings, 64, 64, '1-3', 1, 0.5)

	Person.initialize(self, x, y, w, h, collider, anim)

	self.accuracy = 1
	self.moveSpeed = moveSpeed
end

function BasicEnemy:collider_pos_calc()
	local vecx = self.collider:getX() - self.w / 2
	local vecy = self.collider:getY() - self.h / 2

	return vecx,vecy
end

function BasicEnemy:load()
	renderer:addRenderer(self)
	gameLoop:addLoop(self)
end

function BasicEnemy:update(dt)
	Person.update(self, dt)
	local newX, currentY = self.collider:getX() - dt*self.moveSpeed, self.collider:getY()
	self.collider:setX(newX)

	Person.setAnimationPos(self, newX - self.w/2, currentY - self.h/2)
end

function BasicEnemy:draw()
	Person.draw(self)
end



return BasicEnemy