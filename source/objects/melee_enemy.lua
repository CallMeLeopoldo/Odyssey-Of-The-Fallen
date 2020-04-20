local class = require("source.packages.middleclass")
local Person = require("source.objects.Person")
local animation = require("source.objects.Animation")
local enemy = require("source.objects.enemy")

local melee_enemy = class("melee_enemy", enemy)

function melee_enemy:initialize(x,y,w,h,r,id)

  -- other variables
  self.id =id or "melee_enemy"
  self.moveSpeed = 40
  self.aggro = 150
  self.counter = 0

  enemy.initialize(self,x, y, w, h, r, self.moveSpeed, self.id, self.aggro)
end

function melee_enemy:update(dt)
  enemy.update(self, dt)
  local playerx = player.collider:getX()
  local selfx = self.collider:getX()
  local selfy = self.collider:getY()
  local _, subbeat = music.music:getBeat()

  if math.abs(selfx-playerx) < (player.r + self.r + 1) then
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

    if self.counter == 2 then
      local px, py = self.collider:getPosition()
  		local colliders = world:queryCircleArea(px + -1*self.dir*(2*self.r), py , 20, {"Player"})
      for i, c in ipairs(colliders) do
  			c.object:interact(self.currentDmg)
      end
      self.counter = 0
    end
  end
end

function melee_enemy:draw()
  --Person.draw(self)
  love.graphics.setColor(0.5,0.5,0.5)
  love.graphics.circle("fill", self.collider:getX(), self.collider:getY(), self.r)
  love.graphics.setColor(1, 1, 1)
end

function melee_enemy:destroy()
  enemy.destroy(self)
end

return melee_enemy
