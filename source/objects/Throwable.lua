local animation = require("source.objects.animation")

class = require("source.packages.middleclass")

local Throwable = class("Throwable")

function Throwable:initialize(x, y, r, ix, iy, dmg, id)
	self.id = id or nill
	self.collider = world:newCircleCollider(x, y, r or 12)
	self.collider:setCollisionClass("EnemyAttack")
	self.collider:setObject(self)
	self.collider:applyLinearImpulse(ix or -70,iy or -40)
	self.collider:setPreSolve(
		function(collider_1, collider_2, contact)
			if collider_1.collision_class == "EnemyAttack" and (collider_2.collision_class == "EnemyAttack" or 
					collider_2.collision_class == "PlayerAttack" or	collider_2.collision_class == "Enemy") then
				contact:setEnabled(false)
			end
		end)
	
	self.animation = animation:new(x, y, sprites.cup, 64, 64, 1, 1, 1)

	self.remove = false
end

function Throwable:load()
	renderer:addRenderer(self)
	gameLoop:addLoop(self)
end

function Throwable:update(dt)
	self.animation.x, self.animation.y = self.collider:getPosition() 
	
	if self.collider:enter("Ground") then
		self:destroy()
	elseif self.collider:enter("Player") then
		local collision_data = self.collider:getEnterCollisionData('Player')
		local player = collision_data.collider:getObject()
		player:interact(15)
		self:destroy()
	end

end

function Throwable:draw()
	self.animation:draw()
end

function Throwable:destroy()
	renderer:removeRenderer(self)
	gameLoop:removeLoop(self)
	self.remove = true
	self.collider:destroy()
	self.animation:destroy()
	self = nil
end

return Throwable
