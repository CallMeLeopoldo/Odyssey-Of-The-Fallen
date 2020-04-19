local class = require("source.packages.middleclass")
local Person = require("source.objects.Person")
local animation = require("source.objects.Animation")
local enemy = require("source.objects.enemy")
local throwable = require("source.objects.Throwable")

local ranged_enemy = class("ranged_enemy", enemy)

function ranged_enemy:initialize(x,y,w,h,r,id)

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

  enemy.initialize(self,x, y, w, h, r, self.moveSpeed, self.id, self.aggro)

end

function ranged_enemy:update(dt)
  enemy.update(self, dt)
  local playerx = player.collider:getX()
  local selfx = self.collider:getX()
  local selfy = self.collider:getY()
  local _, subbeat = music.music:getBeat()

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

    if self.counter == 2 then
      local t = throwable:new(selfx - self.dir*(self.r + 12 + 5), selfy - (self.r + 12 + 5), self.isize, self.ix*self.dir, self.iy)
      t:load()
      self.counter = 0
    end
  end
end

function ranged_enemy:draw()
  --Person.draw(self)
  love.graphics.setColor(0.5,0.5,0.5)
  love.graphics.circle("fill", self.collider:getX(), self.collider:getY(), self.r)
  love.graphics.setColor(1, 1, 1)
end

return ranged_enemy
