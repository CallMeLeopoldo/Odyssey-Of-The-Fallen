local vec2 = require("source.tools.vec2")
local class = require("source.packages.middleclass")
local Person = require("source.objects.Person")
local animation = require("source.objects.Animation")
local throwable = require("source.objects.Throwable")

local enemy = class("enemy", Person)

function enemy:initialize(x, y, w, h, r, moveSpeed, id, aggro, animation)

  -- Enemy Collider
  local collider = world:newRectangleCollider(x, y, 32, 64)
  collider:setObject(self)
  collider:setCollisionClass("Enemy")
  collider:setSleepingAllowed(false)
  collider:setRestitution(0)
  collider:setInertia(5000)
  collider:setFixedRotation(true)
  collider:setPreSolve(
    function(c1, c2, contact)
      if c1.collision_class == "Enemy" and c2.collision_class == "Enemy" then contact:setEnabled(false) end
    end)

  -- Animation
  self.animation = animation

  Person.initialize(self, x, y, w, h, r, collider, self.animation)

  -- Other Variables
  self.accuracy = 1
  self.aggro = aggro or 1000
  self.moveSpeed = moveSpeed or 100
  self.id = id or "enemy"
  self.dir = 1
  self.walk = 1
  self.range = 1  -- variable to make them stop runnning into you
  self.w = w
  self.h = h
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
		self.walk = 0
     self.collider:setLinearVelocity(0,10)-- se calhar por para so parar se saires de duas vezes da aggro range inicial ou algo assim, have to change
    self.collider:setAngularVelocity(0)
  end

  local newX, currentY = selfx - dt*self.moveSpeed*self.dir*self.walk*self.range, selfy
  self.collider:setX(newX)

	Person.setAnimationPos(self, newX - self.w/2 - 5, currentY - self.h/4)
end

-- Callback function for collisions
function enemy:interact(dmg_dealt)
  print(dmg_dealt)
  player.nHitsDealt[player.screen] = player.nHitsDealt[player.screen] + 1
	Person.interact(self, dmg_dealt)
	if self.health < 0 then
    self.animation = self.animations.die
    self.health = 0
		self:destroy()
	end
end

function enemy:destroy()
  Person.destroy(self)
end

return enemy
