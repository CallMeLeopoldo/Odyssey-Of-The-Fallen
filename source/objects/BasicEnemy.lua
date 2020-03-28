local vec2 = require("source.tools.vec2")
local class = require("source.packages.middleclass")
local Person = require("source.objects.Person")
local animation = require("source.objects.Animation")

local BasicEnemy = class("BasicEnemy", Person)

function BasicEnemy:initialize(x, y, w, h, r, moveSpeed)
	local collider = world:newCircleCollider(x, y, r)
	collider:setCollisionClass("BasicEnemy")

	local anim = animation:new(x, y, paintings, w, h, '1-3', 1, 0.5)

	Person.initialize(self, x, y, w, h, r, collider, anim)

	self.accuracy = 1
	self.moveSpeed = moveSpeed
end

function BasicEnemy:collider_pos_calc()
	local vecx = self.collider:getX() - self.r / 2
	local vecy = self.collider:getY() - self.r / 2

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

	Person.setAnimationPos(self, newX - self.r, currentY - self.r)
end

function BasicEnemy:draw()
	Person.draw(self)
end



return BasicEnemy