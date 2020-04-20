local class = require("source.packages.middleclass")
local Person = require("source.objects.Person")
local animation = require("source.objects.Animation")
local enemy = require("source.objects.enemy")

local melee_enemy = class("melee_enemy", enemy)

function melee_enemy:initialize(x,y,w,h,r,id)

  self.animations = {}
  self.animations.walkRight = animation:new(x , y, sprites.goblin, 64, 64, '1-8', 2, 1/12)
  self.animations.standRight = animation:new(x , y, sprites.goblin, 64, 64, 11, 2, 1/12)
  self.animations.walkLeft = animation:new(x , y, sprites.goblin, 64, 64, '1-8', 4, 1/12)
  self.animations.standLeft = animation:new(x , y, sprites.goblin, 64, 64, 1, 4, 1/12)
  self.animations.attackRight = animation:new(x , y, sprites.goblin, 64, 64, '8-11', 2, 1/12)
  self.animations.attackLeft = animation:new(x , y, sprites.goblin, 64, 64, '8-11', 4, 1/12)
  self.animations.die = animation:new(x , y, sprites.goblin, 64, 64, '1-5', 5, 0.5)
  -- other variables
  self.id = id or "melee_enemy"
  self.moveSpeed = 40
  self.aggro = 512
  self.counter = 0

  enemy.initialize(self,x, y, w, h, r, self.moveSpeed, self.id, self.aggro, self.animations.standLeft)

  self.health = 30
  self.baseDmg = 8
end

  function melee_enemy:update(dt)
  enemy.update(self,dt)
  local playerx = player.collider:getX()
  local selfx = self.collider:getX()
  local selfy = self.collider:getY()
  local _, subbeat = music.music:getBeat()
  if self.attacking == 0 then
    if self.dir == 1 then
      if self.walk == 1 and self.range == 1 then
        self.animation = self.animations.walkLeft
        self:setAnimationPos()
      else
        self.animation = self.animations.standLeft
        self:setAnimationPos()
      end
    else
      if self.walk == 1 and self.range == 1 then
        self.animation = self.animations.walkRight
        self:setAnimationPos()
      else
        self.animation = self.animations.standRight
        self:setAnimationPos()
      end
    end
  end
  if math.abs(selfx-playerx) < (player.r + 20) then
    self.range = 0
  else
    self.range = 1
  end
  if math.abs(selfx-playerx) < self.aggro then --throws on beat if a little over aggro range
    if (subbeat < 0.05 or subbeat > 0.95) then
      if self.bool == false then
          self.counter = self.counter + 1
      end

      self.bool = true
    end
    if subbeat > 0.05 and subbeat < 0.95 then
        self.bool = false
    end

    if self.counter == 1 then
      local px, py = self.collider:getPosition()
  		local colliders = world:queryCircleArea(px + -self.dir*(self.w/2), py , 20, {"Player"})
      self.attacking = 1
      local s = time

      if self.dir == -1 then
        self.animation = self.animations.attackRight
        self:setAnimationPos()

      else
          self.animation = self.animations.attackLeft
          self:setAnimationPos()
      end
      for i, c in ipairs(colliders) do
  			c.object:interact(self.currentDmg)
      end
      self.attacking = 0
      self.counter = 0
    end
  end
end

function melee_enemy:draw()
  enemy.draw(self)
end

function melee_enemy:setAnimationPos()
  self.animation.x = self.collider:getX() - self.w/2 - 5
  self.animation.y = self.collider:getY() - self.h/4 - 5

end
function melee_enemy:destroy()
  enemy.destroy(self)
end
return melee_enemy
