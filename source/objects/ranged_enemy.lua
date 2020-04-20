local class = require("source.packages.middleclass")
local Person = require("source.objects.Person")
local animation = require("source.objects.Animation")
local enemy = require("source.objects.enemy")
local throwable = require("source.objects.Throwable")

local ranged_enemy = class("ranged_enemy", enemy)

function ranged_enemy:initialize(x,y,w,h,r,id)

  self.animations = {}
  self.animations.walkRight = animation:new(x , y, sprites.goblin, 64, 64, '1-8', 2, 1/12)
  self.animations.standRight = animation:new(x , y, sprites.goblin, 64, 64, 11, 2, 1/12)
  self.animations.walkLeft = animation:new(x , y, sprites.goblin, 64, 64, '1-8', 4, 1/12)
  self.animations.standLeft = animation:new(x , y, sprites.goblin, 64, 64, 1, 4, 1/12)
  self.animations.attackRight = animation:new(x , y, sprites.goblin, 64, 64, '8-11', 2, 1/12)
  self.animations.attackLeft = animation:new(x , y, sprites.goblin, 64, 64, '8-11', 4, 1/12)
  self.animations.die = animation:new(x , y, sprites.goblin, 64, 64, '1-5', 5, 0.5)

  -- other variables
  self.id =id or "melee_enemy"
  self.moveSpeed = 50
  self.aggro = 250
  self.canThrow = 0
  self.ix = -70 -- atack impulse direction
  self.iy = -3
  self.isize = 8 --atack size
  self.bool = true
  self.counter = 0

  enemy.initialize(self,x, y, w, h, r, self.moveSpeed, self.id, self.aggro, self.animations.standLeft)

end

function ranged_enemy:update(dt)
  enemy.update(self, dt)
  local playerx = player.collider:getX()
  local selfx = self.collider:getX()
  local selfy = self.collider:getY()
  local _, subbeat = music.music:getBeat()

  if self.attacking == 0 then
    if self.dir == 1 then
      if self.walk == 1 and self.range == 1 then
        self.animation = self.animations.walkLeft
      else
        self.animation = self.animations.standLeft
      end
    else
      if self.walk == 1 and self.range == 1 then
        self.animation = self.animations.walkRight
      else
        self.animation = self.animations.standRight
      end
    end
  end

  if math.abs(selfx - playerx) < (player.r + self.r + 100) then
    self.range = 0
  else
    self.range = 1
  end

  if math.abs(selfx-playerx) < self.aggro + 20 then --throws on beat if a little over aggro range
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
      self.attacking = 1
      if self.dir == -1 then
        self.animation = self.animations.attackRight

      else
        self.animation = self.animations.attackLeft
      end
      local t = throwable:new(selfx - self.dir*(self.r + 12 + 5), selfy - (self.r + 12 + 5), self.isize, self.ix*self.dir, self.iy)
      t:load()
      self.counter = 0
    end
    self.attacking = 0
  end
end

function ranged_enemy:draw()
  enemy.draw(self)
end

function ranged_enemy:destroy()
  enemy.destroy(self)
end


return ranged_enemy
