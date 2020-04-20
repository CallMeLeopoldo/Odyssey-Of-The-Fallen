local vec2 = require("source.tools.vec2")
local class = require("source.packages.middleclass")
local animation = require("source.objects.Animation")
local Menu = require("source.objects.ShopMenu")
local Shop = class("Shop")

function Shop:initialize(x,y,w,h)
    self.x, self.y = x,y
    self.w, self.h = w,h
    self.collider = world:newRectangleCollider(x+w/4, y, w/2, h)
    self.collider:setCollisionClass("Shop")
    self.collider:setType("static")
    self.animation = animation:new(x, y, sprites.shop, 96, 96, 1, 1, 1)
    pause = false
    self.menu = nil
    --self.items
    --Criar classe Item
    --Cada Item tem preço, tipo, descrição
    self.collider:setPreSolve(
		function(collider_1, collider_2, contact)
				if (collider_2.collision_class == "Player" or collider_2.collision_class == "PlayerAttack") then
					contact:setEnabled(false)
				end
		end)

end

function Shop:load()
	renderer:addRenderer(self)
    gameLoop:addLoop(self)
end

function Shop:update()
    if self.collider:enter('Player') then
        print('Collision entered!')
    end
    
    if self.collider:stay('Player') and love.keyboard.isDown("e") then
        -- Toggle pause
        print("HERE WE GO!")
        if(not self.menu) then
            pause = true
            self.menu = Menu:new()
            self.menu:load()
        end
        elseif self.collider:stay('Player') and love.keyboard.isDown("x") then
            if(self.menu) then
                self.menu:remove()
                self.menu = nil
            end
        end

    if self.collider:exit('Player') then
        print('Collision exited!')
    end
end

function Shop:draw()
    self.animation:draw()
end

return Shop