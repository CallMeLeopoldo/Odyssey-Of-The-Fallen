local vec2 = require("source.tools.vec2")
local class = require("source.packages.middleclass")
local Person = require("source.objects.Person")
local animation = require("source.objects.Animation")
local throwable = require("source.objects.Throwable")

local OtherEnemy = class("BasicEnemy", Person)

function OtherEnemy:initialize(x, y, w, h, r, moveSpeed)

	-- OtherEnemy Collider
	local collider = world:newCircleCollider(x, y, 30)
	collider:setObject(self)
	collider:setCollisionClass("BasicEnemy")

	-- Animation
	local anim = animation:new(x - h/2, y - w/2, sprites.cube, w, h, '1-3', 1, 0.5)

	Person.initialize(self, x, y, w, h, r, collider, anim)

	-- Other Variables
	self.accuracy = 1
	self.moveSpeed = moveSpeed
	self.canThrow = 0
end

function OtherEnemy:load()
	renderer:addRenderer(self)
	gameLoop:addLoop(self)
end

function OtherEnemy:update(dt)
	
	Person.update(self, dt)
	
	local _, subbeat = music.music:getBeat()

	if subbeat > 0.99 then
		self.canThrow = self.canThrow - 1
	end
	
	if self.canThrow == 0 then
		self.canThrow = 2
		local t = throwable:new(self.x - 25, self.y - 25)
		t:load()
	end


end

function OtherEnemy:draw()
	--Person.draw(self)
	love.graphics.setColor(.8, .4, .8)
	love.graphics.circle("fill", self.collider:getX(), self.collider:getY(), 30)
	love.graphics.setColor(1, 1, 1)
end

-- Callback function for collisions
function OtherEnemy:interact(dmg_dealt)
	Person.interact(self, dmg_dealt)
	if self.health < 0 then
		self:destroy()
	end
end

function OtherEnemy:destroy()
	renderer:removeRenderer(self)
	gameLoop:removeLoop(self,0)
	Person.destroy(self)
	self.collider = nil
	self = nil
	print("otherEnemy destroyed")
end

return OtherEnemy