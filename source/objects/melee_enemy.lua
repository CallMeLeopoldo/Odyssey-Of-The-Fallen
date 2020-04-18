local class = require("source.packages.middleclass")
local Person = require("source.objects.Person")
local animation = require("source.objects.Animation")
local enemy = require("source.objects.enemy")

local melee_enemy = class("melee_enemy", enemy)

function melee_enemy:initialize(x,y,w,h,r,id)

  -- other variables
  self.id =id or "melee_enemy"
  self.moveSpeed = 40
  self.aggro = 200

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
end

function melee_enemy:draw()
  --Person.draw(self)
  love.graphics.setColor(0.5,0.5,0.5)
  love.graphics.circle("fill", self.collider:getX(), self.collider:getY(), self.r)
  love.graphics.setColor(1, 1, 1)
end

return melee_enemy
