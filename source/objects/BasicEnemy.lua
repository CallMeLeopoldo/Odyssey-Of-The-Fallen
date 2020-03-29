local vec2 = require("source.tools.vec2")
local class = require("source.packages.middleclass")
local Person = require("source.objects.Person")
local animation = require("source.objects.Animation")

local BasicEnemy = class("BasicEnemy", Person)

function BasicEnemy:initialize(x, y, w, h, r, moveSpeed)

	-- BasicEnemy Collider
	local collider = world:newCircleCollider(x, y, 30)
	collider.object = self
	collider:setCollisionClass("BasicEnemy")

	-- Animation
	local anim = animation:new(x, y, paintings, w, h, '1-3', 1, 0.5)

	Person.initialize(self, x, y, w, h, r, collider, anim)

	-- Other Variables
	self.accuracy = 1
	self.moveSpeed = moveSpeed
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

-- Callback function for collisions
function BasicEnemy:interact(dmg_dealt)
	Person.interact(self, dmg_dealt)
end



return BasicEnemy