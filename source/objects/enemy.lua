local vec2 = require("source.tools.vec2")
local class = require("source.packages.middleclass")
local Person = require("source.objects.Person")
local animation = require("source.objects.Animation")
local throwable = require("source.objects.Throwable")

local enemy = class("enemy", Person)

function enemy:initialize(x, y, w, h, r, moveSpeed, id, aggro)


  -- BasicEnemy Collider
  local collider = world:newCircleCollider(x, y, r)
  collider:setObject(self)
  collider:setCollisionClass("Enemy")
  collider:setSleepingAllowed(false)
  collider:setRestitution(0)
  collider:setInertia(50)

  -- Animation
  local anim = animation:new(x, y, sprites.cube, w, h, '1-3', 1, 0.5)


  Person.initialize(self, x, y, w, h, r, collider, anim)

  -- Other Variables
  self.accuracy = 1
  self.aggro = aggro or 1000
  self.moveSpeed = moveSpeed or 100
  self.id = id or "enemy"
  self.dir = 1
  self.walk = 1



end




function enemy:update(dt)
  Person.update(self, dt)
	local playerx = player.collider:getX()
	local selfx = self.collider:getX()
	local selfy = self.collider:getY()


	if math.abs(selfx-playerx) < self.aggro then --segue se dentro de aggro range
    self.walk = 1
		if selfx < playerx  then
			self.dir = -1
		end
		if selfx > playerx  then
			self.dir = 1
		end
	else
		self.walk = 0 -- se calhar por para so parar se saires de duas vezes da aggro range inicial ou algo assim, have to change

  end

  local newX, currentY = selfx - dt*self.moveSpeed*self.dir*self.walk, selfy
  self.collider:setX(newX)

	Person.setAnimationPos(self, newX - self.w/2, currentY - self.h/2)



end




-- Callback function for collisions
function enemy:interact(dmg_dealt)
	Person.interact(self, dmg_dealt)
	if self.health < 0 then
    self.health = 0
		self:destroy()
	end
end

return enemy
